
/**
\file
\ingroup    executechangelog

\brief      Test the _executechangelog makro.

*/ /** \cond */ 

/***************************************************************************/
/* MACROS */
/***************************************************************************/

/***************************************************************************/
/* TEST SCENARIO - SETUP */
/***************************************************************************/
%macro testScenarioSetup();
	%_common_test_scenario_setup();
%mend;

/***************************************************************************/
/* TEST SCENARIO - TEARDOWN */
/***************************************************************************/
%macro testScenarioTeardown();
	%_common_test_scenario_teardown();
%mend;


/********************   SETUP and TEARDOWN   ********************/
%macro setup();
	%include "&g_root/fixture/installs/changeloglock_table.sas";
	%include "&g_root/fixture/installs/changelog_table.sas";
%mend;


%macro teardown();
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangelog.sas, i_desc=Test that a message is displayed for each changeset);
/* 2) Setup */
%macro setup01();
	%setup();
	
	DATA changeLog;
		ATTRIB file length=$1000;
		
		file="/../changesets/executechangelog_tc01_cs01.sas";
		noAutoexec="N";
		output;
		file="/../changesets/executechangelog_tc01_cs02.sas";
		noAutoexec="N";
		output;
	RUN;
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_executechangelog(i_changeLog=%str(testscenario/data/xml/noactuallogrequired.xml)
					,i_changeLogTable=changeLog
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Processing ChangeSet %"%"\/\.\.\/changesets\/executechangelog_tc01_cs01\.sas%"%")       
               ,i_desc=Test that a message is displayed for file 1
             );
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Processing ChangeSet %"%"\/\.\.\/changesets\/executechangelog_tc01_cs02\.sas%"%")       
               ,i_desc=Test that a message is displayed for file 2
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
%initTestcase(i_object=_executechangelog.sas, i_desc=Test that changelog execution stops after a changeset warning);
/* 2) Setup */
%macro setup02();
	%setup();
	
	DATA changeLog;
		ATTRIB file length=$1000;
		
		file="/../changesets/executechangelog_tc02_cs01.sas";
		noAutoexec="N";
		output;
		file="/../changesets/executechangelog_tc02_cs02.sas";
		noAutoexec="N";
		output;
	RUN;
%mend;
%setup02();
/* 3) Invocation of the program under test */
%_executechangelog(i_changeLog=%str(testscenario/data/xml/noactuallogrequired.xml)
					,i_changeLogTable=changeLog
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Processing ChangeSet %"%"\/\.\.\/changesets\/executechangelog_tc02_cs01\.sas%"%")       
               ,i_desc=Test that a message is displayed for ChangeSet 1
             );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Aborting execution of further changes due to previous error.)       
               ,i_desc=Test that a message is displayed indicating no more changesets will be executed
             );
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Processing ChangeSet %"%"\/\.\.\/changesets\/executechangelog_tc02_cs02\.sas%"%")       
               ,i_desc=Test that a message is not displayed for ChangeSet 2  
               ,i_not=1
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
%initTestcase(i_object=_executechangelog.sas, i_desc=Test that changelog execution stops after a changeset error);
/* 2) Setup */
%macro setup03();
	%setup();
	
	DATA changeLog;
		ATTRIB file length=$1000;
		
		file="/../changesets/executechangelog_tc03_cs01.sas";
		noAutoexec="N";
		output;
		file="/../changesets/executechangelog_tc03_cs02.sas";
		noAutoexec="N";
		output;
	RUN;
%mend;
%setup03();
/* 3) Invocation of the program under test */
%_executechangelog(i_changeLog=%str(testscenario/data/xml/noactuallogrequired.xml)
					,i_changeLogTable=changeLog
					);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Processing ChangeSet %"%"\/\.\.\/changesets\/executechangelog_tc03_cs01\.sas%"%")       
               ,i_desc=Test that a message is displayed for ChangeSet 1
             );
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Aborting execution of further changes due to previous error.)       
               ,i_desc=Test that a message is displayed indicating no more changesets will be executed
             );
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Processing ChangeSet %"%"\/\.\.\/changesets\/executechangelog_tc03_cs02\.sas%"%")       
               ,i_desc=Test that a message is not displayed for ChangeSet 2  
               ,i_not=1
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
%initTestcase(i_object=_executechangelog.sas, i_desc=Test that a message is displayed indicating a change log lock was acquired and released.);
/* 2) Setup */
%macro setup04();
	%setup();
	
	DATA changeLog;
		ATTRIB file length=$1000;
		
		SET _NULL_;
	RUN;
%mend;
%setup04();
/* 3) Invocation of the program under test */
%_executechangelog(i_changeLog=%str(testscenario/data/xml/noactuallogrequired.xml)
					,i_changeLogTable=changeLog
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Successfully acquired change log lock.)
               ,i_desc=Test that a message is displayed
             );
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) Successfully released change log lock.)
               ,i_desc=Test that a message is displayed
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
%initTestcase(i_object=_executechangelog.sas, i_desc=Test that the change log lock table is released after the change sets are executed.);
/* 2) Setup */
%macro setup05();
	%setup();
	
	%include "&g_root./testscenario/data/executechangelog_tc05_data.sas";
%mend;
%setup05();
/* 3) Invocation of the program under test */
%_executechangelog(i_changeLog=%str(testscenario/data/xml/noactuallogrequired.xml)
					,i_changeLogTable=changeLog
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.databasechangeloglock
				,i_actual=INSTALLS.databasechangeloglock
				,i_desc=Testing the values of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown05();
	%teardown();
%mend;
%teardown05();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 06   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_executechangelog.sas, i_desc=Test that a message is displayed indicating a change log lock can not be acquired.);
/* 2) Setup */
%macro setup06();
	%setup();
	
	%include "&g_root./testscenario/data/executechangelog_tc06_data.sas";
%mend;
%setup06();
/* 3) Invocation of the program under test */
%_executechangelog(i_changeLog=%str(testscenario/data/xml/noactuallogrequired.xml)
					,i_changeLogTable=changeLog
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Unable to acquire the change log lock.  ChangeSets will not be executed.)
               ,i_desc=Test that a message is displayed
             );
/* 6) Teardown */
%macro teardown06();
	%teardown();
%mend;
%teardown06();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */