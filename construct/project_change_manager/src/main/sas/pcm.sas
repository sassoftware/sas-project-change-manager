/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

/**

Environment Variables (required):
PCM_ROOT :                The root location of Project Change Manager
PCM_SAS_HOME :            The location of SASHome 
PCM_SAS_VERSION :         The version of SAS
PCM_INSTALLS_LOC :        The full path of the location where the install data sets are kept.
PCM_LOG_ROOT :            The location for Project Change Manager log files
PCM_CHANGESET_AUTOEXEC :  The full path of the autoexec files to use for changesets.  Leave blank if no autoexec is to be processed.


**/

/* Paths can be quite large.  String length related options to MAX */
OPTIONS LINESIZE=MAX
		NOQUOTELENMAX;

/* Define the macrovariable that contains the changeLogLocation */
/* This is to be set as a parameter when the program is called */
%GLOBAL G_PCM_VERSION;
%GLOBAL g_changeLog;

%LET G_PCM_VERSION=1.0;

%_initPCM(i_changeLog=&g_changeLog);

%_readChangeLog(i_changeLog=&g_changeLog
				,o_changeLogTable=changeLog
				);
				
%_executeChangeLog(i_changeLog=&g_changeLog
					,i_changeLogTable=changeLog);