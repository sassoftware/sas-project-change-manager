/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

%MACRO doIFail();
	%IF (&g_failSecondProgram.) %THEN %DO;
		%PUT ERROR: This will fail due to the global error flag being set in the initstmt argument in the shell script.;
	%END;
	%ELSE %DO;
		%PUT This will pass due to the cleared global error flag from the initstmt argument in the shell script.; 
	%END;
%MEND;
%doIFail();