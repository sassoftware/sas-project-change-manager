/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/*
	Reads in the change log file and outputs the contents in a table.

*/

%MACRO _readChangeLog(i_changeLog		  	/* Path of the changelog xml file */
						,o_changeLogTable	/* Output table containing the contents of the changeLog file*/
					);
	%LOCAL L_SCHEMA_VERSION;
	%LET L_SCHEMA_VERSION=2018.07;
					
	%_putlog(Reading the ChangeLog...);
	
	/******************************************************/
	/* Declare the xml map and the changelog as a library */
	/******************************************************/
	
	/* Resolve root path for Project Change Manager */
	%LOCAL l_pcmRoot;
	LIBNAME _tmp "%sysget(PCM_ROOT)";
	%let l_pcmRoot=%sysfunc(pathname(_tmp));
	LIBNAME _tmp CLEAR;
	FILENAME CHNGLGMP "&l_pcmRoot./sas/xml/map/SASChangeLog.map";
	LIBNAME inxml xmlv2 "&i_changeLog" xmlmap=CHNGLGMP access=readonly;
	
	
	/******************************************************/
	/* Read in and validate the SASChangeLog xml */	
	/******************************************************/
	
	/* Read in and validate the changelog meta information */
	%LOCAL l_changeLogHasMissingLgclPath l_changeLogHasMissingSchemaVsn;
	%LET l_changeLogHasMissingLgclPath=N;
	%LET l_changeLogHasMissingSchemaVsn=N;
	
	DATA WORK.changelog;
		SET inxml.sasChangeLog;
		IF (missing(sasChangeLog_logicalFilePath)) THEN
			call symput("l_changeLogHasMissingLgclPath","Y");
		IF (missing(sasChangeLog_schemaVersion)) THEN
			call symput("l_changeLogHasMissingSchemaVsn","Y");
	RUN;
	
	/* Validate for required logicalFilePath */
	%IF (&l_changeLogHasMissingLgclPath eq Y) %THEN %DO;
		%_putlog(i_msg=%str(Invalid xml.  Required attribute "logicalFilePath" for element "saschangelog" is missing.  Please validate against SASChangeLog.xsd)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	
	/* Validate for required schemaVersion */
	%IF (&l_changeLogHasMissingSchemaVsn eq Y) %THEN %DO;
		%_putlog(i_msg=%str(Invalid xml.  Required attribute "schemaVersion" for element "saschangelog" is missing.  Please validate against SASChangeLog.xsd)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	
	/* If the namespace does not match than there will be 0 observations in the changelog meta information. */
	/* There may be other reasons for this to happen to, so output a generic enough error message that also suggests maybe a namespace problem. */
	PROC SQL noprint;
		SELECT count(*) INTO :l_changeLogSuccessfullyRead
			FROM WORK.changelog;
	QUIT;
	
	%IF (&l_changeLogSuccessfullyRead. eq 0) %THEN %DO;
		%_putlog(i_msg=%str(Could not read the xml document metadata.  There may be an unexpected XML namespace.  Please validate against SASChangeLog.xsd.)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	
	/* Read in and validate the changelog include files */
	%LOCAL l_includeHasMissingFile l_includeHasInvalidNoAutoexec;
	%LET l_includeHasMissingFile=N;
	%LET l_includeHasInvalidNoAutoexec=N;

	DATA WORK.includes;
		SET inxml.include;
		IF (missing(include_file)) THEN
			call symput("l_includeHasMissingFile","Y");

		/* Default include_noautoexec */
		IF (MISSING(include_noautoexec)) THEN
			include_noautoexec="N";

		/* Ensure is include_noautoexec upper case */
		include_noautoexec=upcase(include_noautoexec);

		/* Check for an invalid noAutoexec attribute */
		IF ( (include_noautoexec ne "Y") AND
				(include_noautoexec ne "N") ) THEN DO;
			call symput("l_includeHasInvalidNoAutoexec","Y");
		END;
	RUN;
	
	%IF (&l_includeHasMissingFile eq Y) %THEN %DO;
		%_putlog(i_msg=%str(Invalid xml.  Required attribute "file" for element "include" is missing.  Please validate against SASChangeLog.xsd)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	
	/* Validate for invalid noAutoexec */
	%IF (&l_includeHasInvalidNoAutoexec eq Y) %THEN %DO;
		%_putlog(i_msg=%str(Invalid noAutoexec attribute value.  Expecting "Y" or "N".)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	
	/******************************************************/
	/* Now combine the changelog info in one master table */
	/******************************************************/
	
	/* 1) Read in the changelog attributes */
	%LOCAL l_logicalFilePath
			l_schemaVersion;
	PROC SQL NOPRINT;
		SELECT sasChangeLog_logicalFilePath, sasChangeLog_schemaVersion into :l_logicalFilePath, :l_schemaVersion
		FROM WORK.changelog;
	QUIT;
	/* Remove whitespace */
	%LET l_logicalFilePath=&l_logicalFilePath.;
	%LET l_schemaVersion=&l_schemaVersion.;
	
	/* 2) Validate values of changelog attributes */
	%IF (%datatyp(&l_schemaVersion.) ne NUMERIC) %THEN %DO;
		%_putlog(i_msg=%str(The version of the schema used by the changelog "&l_schemaVersion." is invalid and can not be read.  Please validate against SASChangeLog.xsd.)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	%ELSE %IF (&l_schemaVersion. gt &L_SCHEMA_VERSION.) %THEN %DO;
		%_putlog(i_msg=%str(The version of the schema used by the changelog "&l_schemaVersion." is unsupported because it is too high.  Please validate against SASChangeLog.xsd.)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	%ELSE %IF (&l_schemaVersion. lt &L_SCHEMA_VERSION.) %THEN %DO;
		%_putlog(i_msg=%str(The version of the schema used by the changelog "&l_schemaVersion." is an unsupported older version.  Please validate against SASChangeLog.xsd.)
					,i_logLevel=2);
		%GOTO exit;
	%END;
	
	/* 3) Add the attributes to the include table */
	DATA &o_changeLogTable;
		length logicalFilePath	$1000;
		length pcmVersion	$20;
		length schemaVersion	$20;
		 
		RETAIN logicalFilePath
				pcmVersion
				schemaVersion;

		SET WORK.includes(rename=(include_file=file include_noautoexec=noAutoexec));
		
		IF (_N_ = 1) THEN DO;
			logicalFilePath="&l_logicalFilePath.";
			pcmVersion="%trim(&G_PCM_VERSION.)";
			schemaVersion="&l_schemaVersion.";
		END;
	RUN;

%exit:
%MEND _readChangeLog;