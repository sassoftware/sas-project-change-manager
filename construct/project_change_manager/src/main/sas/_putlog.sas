/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/*
	Outputs a message to the log with a level of NOTE.  Will note that the message is sourced
	from the "PrjChngMgr" project.  Will set sysrc for appropriately levelled messages.

*/

%MACRO _putlog(i_msg			/* Body of the message to be output to the log */
				,i_logLevel=0	/* Log level of the message.  0 is NOTE, 1 is WARNING, 2 is ERROR.  Default is 0 */
				);
	%IF (&i_logLevel eq 0) %THEN
		%put NOTE:(PrjChngMgr) &i_msg;
	%IF (&i_logLevel eq 1) %THEN
		%put WARNING:(PrjChngMgr) &i_msg;
	%IF (&i_logLevel eq 2) %THEN %DO;
		%put ERROR:(PrjChngMgr) &i_msg;
		/* Set SYSCC and SYSRC so OS picks up failure. Tested on linux */
		%let sysrc=2;
		%let syscc=3000;
	%END;
%MEND _putlog;