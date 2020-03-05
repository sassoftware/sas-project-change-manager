/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

%MACRO _createchangelogtables();
	
	/******************************************************/
	/* Determine the dml path */
	/******************************************************/
	%LOCAL l_pcm_root l_ddlDir l_dmlDir;
	
	/* First get the root of Project Change Manager */
	%LET l_pcm_root=%sysget(PCM_ROOT);
	%LET l_pcm_root=%sysfunc(translate(&l_pcm_root,%str(/),%str(\)));
	/* Now assemble the path to the ddl and dml */
	%LET l_dmlDir = &l_pcm_root.;
	/* Strip off the trailing slash if it exists */
	%if ("%substr(&l_dmlDir,%length(&l_dmlDir),1)" = "/") %then
		%LET l_dmlDir=%substr(&l_dmlDir,1,%eval(%length(&l_dmlDir)-1));
	/* Initialize the ddl too */
	%LET l_ddlDir=&l_dmlDir.;
	/* Add the ddl and dml relative paths */
	%LET l_ddlDir=&l_dmlDir./sas/ddl;
	%LET l_dmlDir=&l_dmlDir./sas/dml;

	/******************************************************/
	/* Check if tables exist.  If they don't, create them */
	/******************************************************/

	/* DatabaseChangeLog */
	%IF (%sysfunc(exist(INSTALLS.databasechangelog)) eq 1) %THEN %DO;
		%_putlog(i_msg=INSTALLS.databasechangelog already exists.);
	%END;
	%ELSE %DO;
		%_putlog(i_msg=INSTALLS.databasechangelog does not exist.  Install file is &l_ddlDir./changelog_table.sas.);
		%include "&l_ddlDir./changelog_table.sas";
	%END;

	/* DatabaseChangeLogLock */
	%IF (%sysfunc(exist(INSTALLS.databasechangeloglock)) eq 1) %THEN %DO;
		%_putlog(i_msg=INSTALLS.databasechangeloglock already exists.);
	%END;
	%ELSE %DO;
		%_putlog(i_msg=INSTALLS.databasechangeloglock does not exist.  Install file is &l_ddlDir./changeloglock_table.sas);
		%include "&l_ddlDir./changeloglock_table.sas";
		%include "&l_dmlDir./changeloglock_table_data.sas";
	%END;
%MEND;