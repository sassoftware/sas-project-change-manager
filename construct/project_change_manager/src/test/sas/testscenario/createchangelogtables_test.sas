
/**
\file
\ingroup    createchangelogtables

\brief      Test the _createchangelogtables makro.

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
%mend;


%macro teardown();
	PROC DATASETS lib=INSTALLS nolist
		kill;
	RUN;
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_createchangelog.sas, i_desc=Test that the changelog table is created with the expected important attributes.);
/* 2) Setup */
%macro setup01();
	%setup();
	
	%include "&g_root/testscenario/data/createchangelogtable_tc01_data.sas";
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_createchangelogtables();
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for errors and warnings));
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the formats of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR LABEL LENGTH INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the informats of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LABEL LENGTH VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the lengths of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LABEL INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the labels of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LENGTH INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangelog
				,i_actual=INSTALLS.databasechangelog
				,i_desc=Testing the columns of the table
				,i_allow=BASEOBS COMPOBS FORMAT LABEL LENGTH INFORMAT VALUE);
/* 6) Teardown */
%macro teardown01();
	%teardown();
%mend;
%teardown01();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 02   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_createchangelog.sas, i_desc=Test that the changeloglock table is created with the expected important attributes.);
/* 2) Setup */
%macro setup02();
	%setup();
	
	%include "&g_root/testscenario/data/createchangelogtable_tc02_data.sas";
%mend;
%setup02();
/* 3) Invocation of the program under test */
%_createchangelogtables();
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for errors and warnings));
%assertcolumns(i_expected=EXPECTED.databasechangeloglock
				,i_actual=INSTALLS.databasechangeloglock
				,i_desc=Testing the formats of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR LABEL LENGTH INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangeloglock
				,i_actual=INSTALLS.databasechangeloglock
				,i_desc=Testing the informats of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LABEL LENGTH VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangeloglock
				,i_actual=INSTALLS.databasechangeloglock
				,i_desc=Testing the lengths of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LABEL INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangeloglock
				,i_actual=INSTALLS.databasechangeloglock
				,i_desc=Testing the labels of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LENGTH INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.databasechangeloglock
				,i_actual=INSTALLS.databasechangeloglock
				,i_desc=Testing the columns of the table
				,i_allow=BASEOBS COMPOBS FORMAT LABEL LENGTH INFORMAT VALUE);
/* 6) Teardown */
%macro teardown02();
	%teardown();
%mend;
%teardown02();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 03   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_createchangelog.sas, i_desc=Test that the expected messages are output when the tables do not exist.);
/* 2) Setup */
%macro setup03();
	%setup();
%mend;
%setup03();
/* 3) Invocation of the program under test */
%_createchangelogtables();
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%nrstr(^NOTE:\%(PrjChngMgr\%) INSTALLS.databasechangelog does not exist.  Install file is .*\/ddl\/changelog_table.sas.)       
               ,i_desc=Test that a message is displayed for the changelog table.
             );
%assertLogMsg(i_logmsg=%nrstr(^NOTE:\%(PrjChngMgr\%) INSTALLS.databasechangeloglock does not exist.  Install file is .*\/ddl\/changeloglock_table.sas.)       
               ,i_desc=Test that a message is displayed for the changeloglock table.
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
%initTestcase(i_object=_createchangelog.sas, i_desc=Test that the expected messages are output when the tables already exist.);
/* 2) Setup */
%macro setup04();
	%setup();
	
	/* Create the tables */
	%include "&g_root/fixture/installs/changelog_table.sas";
	%include "&g_root/fixture/installs/changeloglock_table.sas";
%mend;
%setup04();
/* 3) Invocation of the program under test */
%_createchangelogtables();
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLogMsg(i_logmsg=%nrstr(^NOTE:\%(PrjChngMgr\%) INSTALLS.databasechangeloglock already exists.)       
               ,i_desc=Test that a message is displayed for the changelog table.
             );
%assertLogMsg(i_logmsg=%nrstr(^NOTE:\%(PrjChngMgr\%) INSTALLS.databasechangeloglock already exists.)       
               ,i_desc=Test that a message is displayed for the changeloglock table.
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
%initTestcase(i_object=_createchangelog.sas, i_desc=Test that the changeloglock table is created with an unlocked observation.);
/* 2) Setup */
%macro setup05();
	%setup();
	
	%include "&g_root/testscenario/data/createchangelogtable_tc05_data.sas";
%mend;
%setup05();
/* 3) Invocation of the program under test */
%_createchangelogtables();
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


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */