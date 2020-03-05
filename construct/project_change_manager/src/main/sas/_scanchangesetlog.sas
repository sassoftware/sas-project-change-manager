/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/*
	Scans a changeset log file looking for errors and warnings.

*/

%MACRO _scanChangeSetLog(i_changeSetLog		/* Path of the changeset log file */
						,o_hasWarnings		/* Flag to set if there are warnings found in the log */
						,o_hasErrors		/* Flag to set if there are errors found in the log */
						);
	
	/* Initialize the output variables to N */
	%let &o_hasWarnings=N;
	%let &o_hasErrors=N;
	
	%LOCAL l_changeSetLog;
	%LET l_changeSetLog=%sysfunc(translate(&i_changeSetLog,%str(/),%str(\)));
	
	/******************************************************/
	/* Scan the log file
	/******************************************************/
	
	DATA _NULL_;
		INFILE "&l_changeSetLog" TRUNCOVER END=isEnd;
		INPUT curLine $char47.;
		
		RETAIN l_hasWarnings l_hasErrors warningId errorId
				warningWhiteListId1
				warningWhiteListId2
				warningWhiteListId3
				warningWhiteListId4;
		
		/* Initialize the local warning/error flags and create the regular expressions */
		IF (_N_ = 1) THEN DO;
			l_hasWarnings="N";
			l_hasErrors="N";

			warningId=prxparse("/^WARNING: /m");
			errorId=prxparse("/^ERROR: /m");
			
			/* Warning white list */
			warningWhiteListId1=prxparse("/^WARNING: Your system is scheduled to expire on/m"); /* SAS Expiration */
			warningWhiteListId2=prxparse("/^WARNING: Unable to copy SASUSER registry to WO/m"); /* Can't write to SASUSER.registry catalog */
			warningWhiteListId3=prxparse("/^WARNING: The Base SAS Software product with wh/m"); /* SAS Expiration when running DATASTEP */
			warningWhiteListId4=prxparse("/^WARNING: No physical cube exists/m"); /* Attempt to delete physical cube when it doesn't exit but cube is registered */
		END;

		/* Check for a match and set flags */		
		IF ( prxmatch(warningId, curLine)
				AND NOT prxmatch(warningWhiteListId1, curLine)
				AND NOT prxmatch(warningWhiteListId2, curLine)
				AND NOT prxmatch(warningWhiteListId3, curLine)
				AND NOT prxmatch(warningWhiteListId4, curLine)
			) THEN DO;
			CALL SYMPUT("&o_hasWarnings", "Y");
			l_hasWarnings="Y";
		END;
		ELSE IF (prxmatch(errorId, curLine)) THEN DO;
			CALL SYMPUT("&o_hasErrors", "Y");
			l_hasErrors="Y";
		END;
		
		/* Exit if both warnings and errors have been found */
		IF ( (l_hasWarnings eq "Y") AND (l_hasErrors eq "Y") ) THEN
			STOP; 
	RUN;
	

%MEND _scanChangeSetLog;