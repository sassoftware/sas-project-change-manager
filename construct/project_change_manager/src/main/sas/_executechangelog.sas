/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/*
	Reads over the files in the change log and executes the programs.

*/

%MACRO _executeChangeLog(i_changeLog		/* Path of the changelog xml file */
						,i_changeLogTable	/* Input table containing the contents of the changeLog files*/
						);
	
	/******************************************************/
	/* Acquire the change log lock */
	/******************************************************/
	DATA _NULL_;
		SET INSTALLS.databasechangeloglock;
		call symput("l_lockedStatus", locked);
	RUN;
	
	%IF (&l_lockedStatus eq 1) %THEN %DO;
		%_putlog(i_msg=%str(Unable to acquire the change log lock.  ChangeSets will not be executed.),i_logLevel=2);
		%GOTO exit;
	%END;
	
	/* Set the lock */
	PROC SQL noprint;
		UPDATE INSTALLS.databasechangeloglock
		SET locked=1,
			lock_granted=datetime(),
			locked_by="&sysuserid."
		WHERE locked=0;
	QUIT;
	
	%_putlog(Successfully acquired change log lock.);
	
	/******************************************************/
	/* Iterate over the changelog */
	/******************************************************/
	%LOCAL l_i l_numChangeSets l_file l_logicalFilePath l_noAutoexec;
	
	%_putlog(Iterating through the ChangeLog...);
	
	/* First get a count */
	%LET l_numChangeSets=0;
	PROC SQL NOPRINT;
		SELECT count(*) INTO :l_numChangeSets
		FROM &i_changeLogTable;
	QUIT;
	
	%DO l_i=1 %TO &l_numChangeSets;
		
		/* Read the changeset info */
		DATA _NULL_;
			changeSetObs=&l_i;
			SET &i_changeLogTable point=changeSetObs;
			
			call symputx("l_file", file, "L");
			call symputx("l_logicalFilePath", logicalFilePath, "L");
			call symputx("l_noAutoexec", noAutoexec, "L");
			
			STOP;
		RUN;
		
		/******************************************************/
		/* Process the changeset */
		/******************************************************/
		%LOCAL l_cleanExecution;
		
		%_putlog(Processing ChangeSet "&l_file");
		%_executeChangeSet(i_changeLog=&i_changeLog
							,i_changeSet=&l_file
							,i_noAutoexec=&l_noAutoexec
							,i_filePath=&l_logicalFilePath.
							,o_cleanExecution=l_cleanExecution
						);

		%IF (NOT &l_cleanExecution) %THEN %DO;
			%_putlog(i_msg=Aborting execution of further changes due to previous error.
						,i_logLevel=2);
			%GOTO leave;			
		%END;
		
	%END; /* %DO l_i=1 %TO &l_numChangeSets; */
	%leave: /* Exit the above loop */
	
	
	/******************************************************/
	/* Release the change log lock */
	/******************************************************/
	PROC SQL noprint;
		UPDATE INSTALLS.databasechangeloglock
		SET locked=0,
			lock_granted=.,
			locked_by=""
		WHERE locked=1;
	QUIT;
	
	%_putlog(Successfully released change log lock.);
	
%exit:
%MEND _executeChangeLog;