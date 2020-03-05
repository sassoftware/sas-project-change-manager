
/**
\file
\ingroup    initpcm

\brief      Test the _initpcm makro.

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
%initTestcase(i_object=_initpcm.sas, i_desc=Test that an output message is displayed indicating the name of the changelog file);
/* 2) Setup */
%macro setup01();
	%setup();
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_initpcm(i_changeLog=%str(Here is a note));
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log, no errors, no warnings));
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) ChangeLog file is %"%"Here is a note%"%")       
               ,i_desc=%str(Test that the log message displays the ChangeLog location, and that it is in double quotes)
             );
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