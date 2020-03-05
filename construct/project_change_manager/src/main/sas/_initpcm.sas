/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/*
	Performs Project Change Manager initialization tasks.

*/

%MACRO _initPCM(i_changeLog /* Path of the changelog xml file */);

	/******************************************************/
	/* Define the installs library */
	/******************************************************/

	/* Assign the libref */
	%LET l_pcm_installs_location = %sysget(PCM_INSTALLS_LOC);
	LIBNAME installs "&l_pcm_installs_location.";
	/* Create the changelog and lock tables if necessary */
	%_putlog(i_msg=Installs directory is "&l_pcm_installs_location.");

	
	/******************************************************/
	/* Ensure changlog tables are ready */
	/******************************************************/

	/* Create the changelog tables if needed */
	%_createchangelogtables();
	
	/******************************************************/
	/* Process the changelog */
	/******************************************************/

	/* Simply output the changelog location */
	%_putlog(i_msg=ChangeLog file is "&i_changeLog");
%MEND _initPCM;