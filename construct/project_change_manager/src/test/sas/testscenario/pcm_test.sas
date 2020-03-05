
/**
\file
\ingroup    pcm

\brief      Smoke testing the main pcm program

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
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=pcm.sas, i_desc=Testing that pcm can run error and warning free);
/* 2) Setup */
%macro setup01();
	%setup();
	
	%GLOBAL g_changeLog;
	%let g_changeLog=testscenario/data/xml/pcm_xml_tc01.xml;
%mend;
%setup01();
/* 3) Invocation of the program under test */
%include "&g_root/../../sas/pcm.sas";
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log, no errors, no warnings));
/* 6) Teardown */
%macro teardown01();
	%teardown();
%mend;
%teardown01();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 2   ********************/


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */