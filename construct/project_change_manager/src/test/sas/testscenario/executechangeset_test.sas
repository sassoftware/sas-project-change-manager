
/**
\file
\ingroup    executechangeset

\brief      Test the _executechangeset makro.

*/ /** \cond */ 

/***************************************************************************/
/* MACROS */
/***************************************************************************/

/***************************************************************************/
/* TEST SCENARIO - SETUP */
/***************************************************************************/
%macro testScenarioSetup();
	%_common_test_scenario_setup();
	
	/* Test Scenario variables */
	%GLOBAL g_test_executionDatetime
			g_test_datetimestamp
			g_test_cleanExecution;
			
	/* CONSTANTS */
	%GLOBAL G_PCM_VERSION;
	%LET G_PCM_VERSION=1.0;
%mend;

/***************************************************************************/
/* TEST SCENARIO - TEARDOWN */
/***************************************************************************/
%macro testScenarioTeardown();
	%_common_test_scenario_teardown();
	
	/* Test Scenario variables */
	%SYMDEL g_test_executionDatetime
			g_test_datetimestamp
			g_test_cleanExecution;
%mend;


/********************   SETUP and TEARDOWN   ********************/
%macro setup();
	/* Common Test Data */
	%include "&g_root/fixture/installs/changelog_table.sas";
	
	%LET g_test_executionDatetime=%sysfunc(datetime());
	%let g_test_datetimestamp=%sysfunc(putn(&g_test_executionDatetime.,B8601DT.3));
	%let g_test_cleanExecution=;
%mend;


%macro teardown();
	PROC DATASETS library=EXPECTED nolist kill;
	QUIT;
	
	%let g_test_datetimestamp=;
	%let g_test_cleanExecution=;
	%LET g_test_executionDatetime=;
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the messages displayed and output flag when execution is successful);
/* 2) Setup */
%macro setup01();
	%setup();
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Executing ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc_any\.sas%"%")       
               ,i_desc=Test that a message is displayed indicating execution of the changeset file
             );
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc_any\.sas%"%" has completed successfully\.)       
               ,i_desc=Test that a message is displayed indicating execution completion
             );
%assertEquals(i_expected=1
              ,i_actual=&g_test_cleanExecution      
              ,i_desc=Testing that output flag reflects a successful execution
			);
/* 6) Teardown */
%macro teardown01();
	%teardown();
%mend;
%teardown01();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 02   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the executable program was executed);
/* 2) Setup */
%macro setup02();
	%setup();
%mend;
%setup02();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc02.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc02.log
                    ,i_desc=Test that a log file exists
                    ,i_manual=0
                    );
/* 6) Teardown */
%macro teardown02();
	%teardown();
%mend;
%teardown02();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 03   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the error log messages when a changeset is not found);
/* 2) Setup */
%macro setup03();
	%setup();
%mend;
%setup03();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/nonexistentchangeset.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=2, i_warnings=0, i_desc=%str(check log for appropriate number of errors and warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/nonexistentchangeset\.sas%"%" can not be found\.  Check if the file exists and has Read permissions for the Project Change Manager user\.)       
               ,i_desc=Test that a message is displayed indicating the changeset does not exist
             );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Unable to execute ChangeSet\.)       
               ,i_desc=Test that a second error message is displayed indicating that the ChangeSet cannot be run
             );
/* 6) Teardown */
%macro teardown03();
	%teardown();
%mend;
%teardown03();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 04   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the error log messages and output flag when a changeset has warnings);
/* 2) Setup */
%macro setup04();
	%setup();
%mend;
%setup04();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc04.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=2, i_warnings=0, i_desc=%str(check log for appropriate number of errors and warnings));
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc04.log
                    ,i_desc=Test that a log file exists and provide a link
                    ,i_manual=0
                    );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc04\.sas%"%" has completed with unhandled warnings\.) 
               ,i_desc=Test that an error message is displayed indicating the changeset has warnings
             );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Please review the log at %"%".+\/&g_test_datetimestamp._executechangeset_tc04\.log%"%"\.) 
               ,i_desc=Test that an error message is displayed indicating the location of the log file
             );
%assertEquals(i_expected=0
              ,i_actual=&g_test_cleanExecution      
              ,i_desc=Testing that output flag reflects a faulty execution
			);
/* 6) Teardown */
%macro teardown04();
	%teardown();
%mend;
%teardown04();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 05   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the error log messages and output flag when a changeset has errors);
/* 2) Setup */
%macro setup05();
	%setup();
%mend;
%setup05();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc05.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=2, i_warnings=0, i_desc=%str(check log for appropriate number of errors and warnings));
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc05.log
                    ,i_desc=Test that a log file exists and provide a link
                    ,i_manual=0
                    );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc05\.sas%"%" has completed with errors\.) 
               ,i_desc=Test that an error message is displayed indicating the changeset has errors
             );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Please review the log at %"%".+\/&g_test_datetimestamp._executechangeset_tc05\.log%"%"\.) 
               ,i_desc=Test that an error message is displayed indicating the location of the log file
             );
%assertEquals(i_expected=0
              ,i_actual=&g_test_cleanExecution      
              ,i_desc=Testing that output flag reflects a faulty execution
			);
/* 6) Teardown */
%macro teardown05();
	%teardown();
%mend;
*%teardown05();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 06   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the program is run using the autoexec specified);
/* 2) Setup */
%macro setup06();
	%setup();
	
	/* Set the PCM_CHANGESET_AUTOEXEC env var - Linux */
	%let autopath=%sysget(SASUNIT_ROOT)/testscenario/data/executechangeset_autoexec06.sas;
	options set=PCM_CHANGESET_AUTOEXEC="&autopath";
%mend;
%setup06();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc06.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for a clean execution));
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc06.log
                    ,i_desc=%str(Test the autoexec ran.  This message should be present: "NOTE: AUTOEXEC processing beginning") 
                    ,i_manual=1
                    );
/* 6) Teardown */
%macro teardown06();
	%teardown();
	
	/* Clear the PCM_CHANGESET_AUTOEXEC env var - Linux */
	options set=PCM_CHANGESET_AUTOEXEC="";
%mend;
%teardown06();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 07   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the program is not run using an autoexec);
/* 2) Setup */
%macro setup07();
	%setup();
%mend;
%setup07();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for a clean execution));
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc_any.log
                    ,i_desc=%str(Test the autoexec did not ran.  This message should NOT be present: "NOTE: AUTOEXEC processing beginning")
                    );
/* 6) Teardown */
%macro teardown07();
	%teardown();
%mend;
%teardown07();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 08   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the changeset has a global pcm_root macrovariable set.);
/* 2) Setup */
%macro setup08();
	%setup();
%mend;
%setup08();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc08.sas)
					,i_noAutoexec=N
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for a clean execution which indicates macrovariable is resolved));
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc08.log
                    ,i_desc=%str(Optionally check that the macrovariable was resolved as expected.)
                    ,i_manual=0
                    );
/* 6) Teardown */
%macro teardown08();
	%teardown();
%mend;
%teardown08();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 09   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the changelog.);
/* 2) Setup */
%macro setup09();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc09.sas";
%mend;
%setup09();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_noAutoexec=N
					,i_filePath=%str(/com/sas/pcm/test/executechangeset_xml_tc09.xml)
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown09();
	%teardown();
%mend;
%teardown09();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 10   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the execution date.);
/* 2) Setup */
%macro setup10();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc10.sas";
%mend;
%setup10();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown10();
	%teardown();
%mend;
%teardown10();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 11   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the correct order for the first change.);
/* 2) Setup */
%macro setup11();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc11.sas";
%mend;
%setup11();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown11();
	%teardown();
%mend;
%teardown11();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 12   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the next order in sequence.);
/* 2) Setup */
%macro setup12();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc12.sas";
%mend;
%setup12();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown12();
	%teardown();
%mend;
%teardown12();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 13   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the completed status on success.);
/* 2) Setup */
%macro setup13();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc13.sas";
%mend;
%setup13();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown13();
	%teardown();
%mend;
%teardown13();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 14   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the changeset filename.);
/* 2) Setup */
%macro setup14();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc14.sas";
%mend;
%setup14();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown14();
	%teardown();
%mend;
%teardown14();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 15   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the Project Change Manager version.);
/* 2) Setup */
%macro setup15();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc15.sas";
%mend;
%setup15();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown15();
	%teardown();
%mend;
%teardown15();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 16   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with a user.);
/* 2) Setup */
%macro setup16();
	%setup();
	
	%LOCAL l_userIsPopulated;
%mend;
%setup16();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* Determine if user is populated */
DATA _NULL_;
	SET INSTALLS.databasechangelog;
	userPopulated=not missing(user);
	
	CALL symputx("l_userIsPopulated", userPopulated, "L");
RUN;
%assertequals(i_expected=&l_userIsPopulated.
				,i_actual=1
				,i_desc=Testing the user is not null);
/* 6) Teardown */
%macro teardown16();
	%SYMDEL l_userIsPopulated;
	
	%teardown();
%mend;
%teardown16();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 17   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with the failed status on error.);
/* 2) Setup */
%macro setup17();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc17.sas";
%mend;
%setup17();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc17.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown17();
	%teardown();
%mend;
%teardown17();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 18   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that a changeset is not executed if it has been previously executed successfully.);
/* 2) Setup */
%macro setup18();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc18.sas";
%mend;
%setup18();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc18\.sas%"%" has completed successfully\.)       
               ,i_desc=Test that a message is displayed indicating execution completion
               ,i_not=1
             );
%assertEquals(i_expected=1
              ,i_actual=&g_test_cleanExecution      
              ,i_desc=Testing that output flag reflects a successful execution
			);
/* 6) Teardown */
%macro teardown18();
	%teardown();
%mend;
%teardown18();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 19   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that a changeset is executed if it has previously failed.);
/* 2) Setup */
%macro setup19();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc19.sas";
%mend;
%setup19();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc_any\.sas%"%" has completed successfully\.)       
               ,i_desc=Test that a message is displayed indicating execution completion
             );
%assertEquals(i_expected=1
              ,i_actual=&g_test_cleanExecution      
              ,i_desc=Testing that output flag reflects a successful execution
			);
/* 6) Teardown */
%macro teardown19();
	%teardown();
%mend;
%teardown19();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 20   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test that the changelog table is populated with a validation checksum.);
/* 2) Setup */
%macro setup20();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc20.sas";
%mend;
%setup20();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown20();
	%teardown();
%mend;
%teardown20();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 21   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the error log messages and output flag when an MD5 checksum does not match.);
/* 2) Setup */
%macro setup21();
	%setup();
	
	%INCLUDE "&g_root/testscenario/data/executechangeset_tc21.sas";
%mend;
%setup21();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc_any.sas)
					,i_filePath=%str()
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=2, i_warnings=0, i_desc=%str(check log for appropriate number of errors and warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) ChangeSet %"%".+\/\.\.\/changesets\/executechangeset_tc_any\.sas%"%" has previously been executed, but the MD5 does not match\.) 
               ,i_desc=Test that an error message is displayed indicating the changeset has errors
             );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) The ChangeSet will not be executed\.) 
               ,i_desc=Test that an error message is displayed indicating the changeset will not be executed
             );
%assertEquals(i_expected=0
              ,i_actual=&g_test_cleanExecution      
              ,i_desc=Testing that output flag reflects a faulty execution
			);
/* 6) Teardown */
%macro teardown21();
	%teardown();
%mend;
%teardown21();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 22   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangeset.sas, i_desc=Test the program is not run using an autoexec when the changeset is specified not to.);
/* 2) Setup */
%macro setup22();
	%setup();
	
	/* Set the PCM_CHANGESET_AUTOEXEC env var - Linux */
	%let autopath=%sysget(SASUNIT_ROOT)/testscenario/data/executechangeset_autoexec22.sas;
	options set=PCM_CHANGESET_AUTOEXEC="&autopath";
%mend;
%setup22();
/* 3) Invocation of the program under test */
%_executechangeset(i_changeLog=%str(testscenario/data/xml/nonexistentfile.xml)
					,i_changeSet=%str(/../changesets/executechangeset_tc22.sas)
					,i_noAutoexec=Y
					,o_cleanExecution=g_test_cleanExecution
					,i_executionDatetime=&g_test_executionDatetime
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for a clean execution));
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) AUTOEXEC is set to not be processed for this changeset.)
                    ,i_desc=Test the Project Change Manager noAutoexec message iss output.
				);
%assertReport(i_actual=&g_log/&g_test_datetimestamp._executechangeset_tc22.log
             	,i_desc=%str(Test the autoexec did not run.  This message should NOT be present: "NOTE: AUTOEXEC processing beginning")
              );
/* 6) Teardown */
%macro teardown22();
	%teardown();
	
	/* Clear the PCM_CHANGESET_AUTOEXEC env var - Linux */
	options set=PCM_CHANGESET_AUTOEXEC="";
%mend;
%teardown22();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */