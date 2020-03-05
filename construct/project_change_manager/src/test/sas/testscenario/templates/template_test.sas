
/**
\file
\ingroup    <some text>

\brief      <description>

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
	/* Common Test Data */
	/*e.g. %include "&g_root/fixture/installs/changelog_table.sas";*/
	
%mend;


%macro teardown();
	PROC DATASETS library=EXPECTED nolist kill;
	QUIT;
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=<target code>, i_desc=<description of test case>);
/* 2) Setup */
%macro setup01();
	%setup();
%mend;
%setup01();
/* 3) Invocation of the program under test */
%include "&g_root/../<target code>";
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log for errors and warnings));				
%assertcolumns(i_expected=EXPECTED.someTable
				,i_actual=WORK.someTable
				,i_desc=Testing the formats of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR LABEL LENGTH INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.someTable
				,i_actual=WORK.someTable
				,i_desc=Testing the informats of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LABEL LENGTH VALUE);
%assertcolumns(i_expected=EXPECTED.someTable
				,i_actual=WORK.someTable
				,i_desc=Testing the lengths of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LABEL INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.someTable
				,i_actual=WORK.someTable
				,i_desc=Testing the labels of the table
				,i_allow=BASEOBS BASEVAR COMPOBS COMPVAR  FORMAT LENGTH INFORMAT VALUE);
%assertcolumns(i_expected=EXPECTED.someTable
				,i_actual=WORK.someTable
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


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */