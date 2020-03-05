/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/*
	Executes a SAS changeset program.

*/

%MACRO _executeChangeSet(i_changeLog 		/* Input changelog */
						,i_changeSet		/* Input changeset program name */
						,i_noAutoexec		/* Input autoexec flag to explicitly not run an autoexec for this changeset */
						,i_filePath			/* Input logicalFilePath of the changeset */
						,o_cleanExecution	/* Output: 1 if completed succesfully, 0 otherwise */ 
						,i_executionDatetime=%sysfunc(datetime())		/* The datetime */
						);
						
	%LOCAL l_pcm_root l_pcm_SASHome l_pcm_SASVersion l_pcm_AutoExec
			l_changeLogFullPath l_changeLogFileName l_changeLogDirectory
			l_changeSetFullPath;
	
	/* Initialize the output flag */
	%LET &o_cleanExecution=0;
	/******************************************************/
	/* Determine the full path of the executable ChangeSet */
	/******************************************************/
	
	/* Find the SAS Executable - get environment variable values */
	%LET l_pcm_root = %sysget(PCM_ROOT);
	%LET l_pcm_SASHome = %sysget(PCM_SAS_HOME);
	%LET l_pcm_SASVersion = %sysget(PCM_SAS_VERSION);
	%LET l_pcm_AutoExec = %sysget(PCM_CHANGESET_AUTOEXEC);
	%LET l_pcm_AutoExec=&l_pcm_AutoExec;/* Strip whitespaces*/
	
	/* Find the SAS Executable - get full path to the changeset - it is relative to changelog */
	/* Get changelog directory */
	LIBNAME _tmp xmlv2 "&i_changeLog" access=readonly;
	%LET l_changeLogFullPath=%sysfunc(pathname(_tmp));
	LIBNAME _tmp CLEAR;
	%LET l_changeLogFullPath=%sysfunc(translate(&l_changeLogFullPath,%str(/),%str(\)));
	%LET l_changeLogFileName=%scan(&l_changeLogFullPath,-1,"/");
	%LET l_changeLogDirectory=%substr(&l_changeLogFullPath,1,%eval(%length(&l_changeLogFullPath)-%length(&l_changeLogFileName)));
	/* Strip off the trailing slash if it exists */
	%if ("%substr(&l_changeLogDirectory,%length(&l_changeLogDirectory),1)" = "/") %then
		%LET l_changeLogDirectory=%substr(&l_changeLogDirectory,1,%eval(%length(&l_changeLogDirectory)-1));
	
	/* Add the changeLog directory to the change Set */
	%LET l_changeSetFullPath=&l_changeLogDirectory.&i_changeSet.;
	
	/******************************************************/
	/* Determine the log path */
	/******************************************************/
	%LOCAL l_pcm_LogRoot l_changeSetFileName l_changeSetLogDir
			l_datetimeStamp;
	
	%LET l_pcm_LogRoot = %sysget(PCM_LOG_ROOT);
	%LET l_pcm_LogRoot=%sysfunc(translate(&l_pcm_LogRoot,%str(/),%str(\)));
	%LET l_changeSetLogDir = &l_pcm_LogRoot;
	/* Strip off the trailing slash if it exists */
	%if ("%substr(&l_changeSetLogDir,%length(&l_changeSetLogDir),1)" = "/") %then
		%LET l_changeSetLogDir=%substr(&l_changeSetLogDir,1,%eval(%length(&l_changeSetLogDir)-1));
	
	/* Determine the filename (minus extension) of the changeSet file, to use in the log file name */
	%LET l_changeSetFileName=%scan(&l_changeSetFullPath,-1,"/");
	/* Strip off the ".sas" extension, if it exists */
	%if ("%substr(&l_changeSetFileName,%eval(%length(&l_changeSetFileName)-3),4)" = ".sas") %then
		%LET l_changeSetFileName=%substr(&l_changeSetFileName,1,%eval(%length(&l_changeSetFileName)-4));
	
	/* Eliminate whitespace from the timestamp */
	/* Set the timestamp in ISO 8601 format*/
	%LET l_datetimeStamp=%sysfunc(putn(&i_executionDatetime.,B8601DT.3));
	%LET l_datetimeStamp=&l_datetimeStamp;
	
	
	/******************************************************/
	/* Validate and initialize the entry in the database change log table */
	/******************************************************/
	
	/* First check if the changeset exists */
	%IF (%sysfunc (fileexist(&l_changeSetFullPath.)) ne 1) %THEN %DO;
		%_putlog(i_msg=ChangeSet "&l_changeSetFullPath." can not be found.  Check if the file exists and has Read permissions for the Project Change Manager user.
				,i_logLevel=2);
		%_putlog(i_msg=Unable to execute ChangeSet.
				,i_logLevel=2);
		%GOTO exit;
	%END;
		
	/* Get the MD5 of the changeset */
	FILENAME f_chngst "&l_changeSetFullPath.";
	
	%LOCAL l_md5Checksum;
	DATA _NULL_;
		LENGTH text1 $32767;
		RETAIN text1;
		
		INFILE f_chngst end=last;
		INPUT;
		
		text1=cats(text1,_infile_);
		
		IF (last) THEN DO;
			md5Checksum=put(md5(compress(text1)), hex32.);
			CALL symputx("l_md5Checksum", md5Checksum, "L");
		END;
	RUN;
	FILENAME f_chngst clear;
	
	/* Check if the changeset has already been executed successfully */
	%LOCAL l_hasBeenSuccessfullyExecuted
			l_oldMd5Sum;
	PROC SQL noprint;
		SELECT count(*), md5sum INTO :l_hasBeenSuccessfullyExecuted, :l_oldMd5Sum
			FROM INSTALLS.databasechangelog
			WHERE logical_changelog="&i_filePath."
				AND changeset="&i_changeSet."
				AND status="EXECUTED";
	QUIT;
	
	%IF (&l_hasBeenSuccessfullyExecuted.) %THEN %DO;
		/* Check the md5 */
		%IF (&l_oldMd5Sum. ne &l_md5Checksum.) %THEN %DO;
			%_putlog(i_msg=%str(ChangeSet "&l_changeSetFullPath." has previously been executed, but the MD5 does not match.)
					,i_logLevel=2);
			%_putlog(i_msg=The ChangeSet will not be executed.
					,i_logLevel=2);
			%GOTO exit;
		%END;
		
		%_putlog(Changeset "&l_changeSetFullPath." has previously executed successfully.);
		%LET &o_cleanExecution=1;
		%GOTO exit;
	%END;
	
	/* Get the latest entry order number */
	%LOCAL l_latestOrderNo l_orderExecuted;
	PROC SQL noprint;
		SELECT max(order_executed) INTO: l_latestOrderNo
			FROM INSTALLS.databasechangelog;
	QUIT;
	%LET l_latestOrderNo=&l_latestOrderNo.;
	
	%IF (&l_latestOrderNo eq .) %THEN %DO;
		%LET l_orderExecuted=1;
	%END;
	%ELSE %DO;
		%LET l_orderExecuted=%eval(&l_latestOrderNo.+1);
	%END;
	
	/* Add an entry to the changelog table */
	PROC SQL noprint;
		INSERT INTO INSTALLS.databasechangelog
		(user, logical_changelog, date_executed, order_executed, status, md5sum, changeset, pcm_version)
		VALUES ("&SYSUSERID.", "&i_filePath.", &i_executionDatetime., &l_orderExecuted., "RUNNING", "&l_md5Checksum.", "&i_changeSet.", "&G_PCM_VERSION.");
	QUIT;
	
	/******************************************************/
	/* Execute the ChangeSet */
	/******************************************************/
		
	/* Find the SAS Executable - execute the command */
	%_putlog(Executing ChangeSet "&l_changeSetFullPath.");
	
	/* Linux - verified on redhat */
	%let l_cmd="&l_pcm_SASHome/SASFoundation/&l_pcm_SASVersion/sas";
	%let l_cmd=&l_cmd -nosyntaxcheck -noovp;
	%let l_cmd=&l_cmd -sysin "&l_changeSetFullPath";
	%let l_cmd=&l_cmd -initstmt "%nrstr(%%GLOBAL g_pcm_root; %%LET g_pcm_root=)&l_pcm_root.;";
	%IF (%length(&l_pcm_AutoExec)) %THEN %DO;
/*		%let l_cmd=&l_cmd -autoexec "&l_pcm_AutoExec";*/

		%IF (&i_noAutoexec. eq N) %THEN %DO;
			%let l_cmd=&l_cmd -autoexec "&l_pcm_AutoExec";
		%END;
		%ELSE %DO;
			%_putlog(AUTOEXEC is set to not be processed for this changeset.);
		%END;
	%END;
	%let l_cmd=&l_cmd -log "&l_changeSetLogDir./&l_datetimeStamp._&l_changeSetFileName..log";
	
	%sysexec &l_cmd;
				
	/******************************************************/
	/* Check for problems executing the ChangeSet */
	/******************************************************/
	
	%IF (&sysrc eq 0) %THEN	%DO;
	
		/******************************************************/
		/* Check for ERRORS and WARNINGS produced by the ChangeSet */
		/******************************************************/
		%LOCAL l_hasWarnings l_hasErrors;
		%_scanChangeSetLog(i_changeSetLog=&l_changeSetLogDir./&l_datetimeStamp._&l_changeSetFileName..log
							,o_hasWarnings=l_hasWarnings
							,o_hasErrors=l_hasErrors);
		
		%IF (&l_hasErrors = Y) %THEN %DO;
			%_putlog(i_msg=ChangeSet "&l_changeSetFullPath." has completed with errors.
						,i_logLevel=2);
			%_putlog(i_msg=Please review the log at "&l_changeSetLogDir./&l_datetimeStamp._&l_changeSetFileName..log".
						,i_logLevel=2);
		%END;
		%ELSE %IF (&l_hasWarnings = Y) %THEN %DO;
			%_putlog(i_msg=ChangeSet "&l_changeSetFullPath." has completed with unhandled warnings.
						,i_logLevel=2);
			%_putlog(i_msg=Please review the log at "&l_changeSetLogDir./&l_datetimeStamp._&l_changeSetFileName..log".
						,i_logLevel=2);
		%END;
		%ELSE %DO;	
			%LET &o_cleanExecution=1;
			%_putlog(i_msg=ChangeSet "&l_changeSetFullPath." has completed successfully.);
		%END;	
								
	%END;
	/* 102 for ChangeSet that doesn't exist or where there is no read permission */
	%ELSE %IF (&sysrc eq 102) %THEN	%DO;
		%_putlog(i_msg=ChangeSet "&l_changeSetFullPath." can not be found.  Check if the file exists and has Read permissions for the Project Change Manager user.
				,i_logLevel=2);
		%_putlog(i_msg=Unable to execute ChangeSet.
				,i_logLevel=2);
	%END;
	%ELSE %IF (&sysrc ne 0) %THEN %DO;
		%_putlog(i_msg=ChangeSet "&l_changeSetFullPath." could not be successfully executed due to an unknown reason.  Return code &sysrc..;
				,i_logLevel=2);
		%_putlog(i_msg=ChangeSet Return message: &sysmsg;
				,i_logLevel=2);
	%END;
	/* 127 is unknown direct cause (executable isn't found?), but happens when the environment variables aren't found */
	/* 104 getting this in the gradle terminal: ERROR: Insufficient authorization to access /20160519T113727333_exampleTableA.log. */
	/* Windows RC 9009 with no error message.  In Windows command prompt seeing
		'C:/Program' is not recognized as an internal or external command, operable program or batch file. */
		
	/* Update the changelog table */
	%IF (NOT &&&o_cleanExecution.) %THEN %DO;
		/* Mark the entry as FAILED in the changelog table */
		PROC SQL noprint;
			UPDATE INSTALLS.databasechangelog
			SET status="FAILED"
			WHERE logical_changelog="&i_filePath."
				AND order_executed=&l_orderExecuted.
				AND status="RUNNING";
		QUIT;
	%END;
	%ELSE %DO;
		/* Mark the entry as successful in the changelog table */
		PROC SQL noprint;
			UPDATE INSTALLS.databasechangelog
			SET status="EXECUTED"
			WHERE logical_changelog="&i_filePath."
				AND order_executed=&l_orderExecuted.
				AND status="RUNNING";
		QUIT;
	%END;
	
%exit:
%MEND _executeChangeSet;