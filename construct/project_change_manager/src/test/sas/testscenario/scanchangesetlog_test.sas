
/**
\file
\ingroup    scanchangesetlog

\brief      Test the _scanchangesetlog makro.

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
	%GLOBAL g_test_hasWarnings
			g_test_hasErrors;
%mend;

/***************************************************************************/
/* TEST SCENARIO - TEARDOWN */
/***************************************************************************/
%macro testScenarioTeardown();
	%_common_test_scenario_teardown();
	
	/* Test Scenario variables */
	%SYMDEL g_test_hasWarnings;
	%SYMDEL g_test_hasErrors;
%mend;


/********************   SETUP and TEARDOWN   ********************/
%macro setup();
	%let g_test_hasWarnings=;
	%let g_test_hasErrors=;
%mend;


%macro teardown();
	%let g_test_hasWarnings=;
	%let g_test_hasErrors=;
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that a no warnings and no errors results in no flags);
/* 2) Setup */
%macro setup01();
	%setup();
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_01.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that no warning is flagged
			);
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasErrors      
              ,i_desc=Testing that no error is flagged
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
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that a warning and no errors results in a warning flag);
/* 2) Setup */
%macro setup02();
	%setup();
%mend;
%setup02();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_02.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=Y
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that the warning is flagged
			);
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasErrors      
              ,i_desc=Testing that no error is flagged
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
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that no warnings and an error results in an error flag);
/* 2) Setup */
%macro setup03();
	%setup();
%mend;
%setup03();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_03.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that no warning is flagged
			);
%assertEquals(i_expected=Y
              ,i_actual=&g_test_hasErrors      
              ,i_desc=Testing that the error is flagged
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
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that a warning and an error results in both flags);
/* 2) Setup */
%macro setup04();
	%setup();
%mend;
%setup04();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_04.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=Y
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that the warning is flagged
			);
%assertEquals(i_expected=Y
              ,i_actual=&g_test_hasErrors      
              ,i_desc=Testing that the error is flagged
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
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that a warning in the log body is not flagged);
/* 2) Setup */
%macro setup05();
	%setup();
%mend;
%setup05();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_05.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that the warning is not flagged
			);
/* 6) Teardown */
%macro teardown05();
	%teardown();
%mend;
%teardown05();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 06   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that an error in the log body is not flagged);
/* 2) Setup */
%macro setup06();
	%setup();
%mend;
%setup06();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_06.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasErrors      
              ,i_desc=Testing that the error is not flagged
			);
/* 6) Teardown */
%macro teardown06();
	%teardown();
%mend;
%teardown06();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 07   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that a SAS expiration warning in the log is not flagged);
/* 2) Setup */
%macro setup07();
	%setup();
%mend;
%setup07();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_07.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that the warning is not flagged
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
%initTestcase(i_object=_scanchangesetlog.sas, i_desc=Test that a warning due to being unable to write to the SASUser registry catalog in the log is not flagged);
/* 2) Setup */
%macro setup08();
	%setup();
%mend;
%setup08();
/* 3) Invocation of the program under test */
%_scanchangesetlog(i_changeSetLog=%str(testscenario/data/logs/scanchangesetlog_tc_08.log)
					,o_hasWarnings=g_test_hasWarnings
					,o_hasErrors=g_test_hasErrors
				);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertEquals(i_expected=N
              ,i_actual=&g_test_hasWarnings      
              ,i_desc=Testing that the warning is not flagged
			);
/* 6) Teardown */
%macro teardown08();
	%teardown();
%mend;
%teardown08();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);



/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */