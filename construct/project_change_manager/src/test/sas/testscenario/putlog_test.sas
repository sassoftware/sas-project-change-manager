
/**
\file
\ingroup    putnote

\brief      Test the _putlog makro.

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
%initTestcase(i_object=_putlog.sas, i_desc=Test that the message is displayed with a Project Change Manager note log level by default);
/* 2) Setup */
%macro setup01();
	%setup();
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_putlog(i_msg=a message to you Rudy);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log, no errors, no warnings));
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) a message to you Rudy)       
               ,i_desc=Test that the message is displayed with a Project Change Manager specific note
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
%initTestcase(i_object=_putlog.sas, i_desc=Test that a message is displayed with a Project Change Manager note log level when explicitly set);
/* 2) Setup */
%macro setup02();
	%setup();
%mend;
%setup02();
/* 3) Invocation of the program under test */
%_putlog(i_msg=a note to you Rudy
			,i_logLevel=0);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertLogMsg(i_logmsg=%str(^NOTE:\%(PrjChngMgr\%) a note to you Rudy)       
               ,i_desc=Test that the message is displayed with a note level
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
%initTestcase(i_object=_putlog.sas, i_desc=Test that a message is displayed with a Project Change Manager warning log level when explicitly set);
/* 2) Setup */
%macro setup03();
	%setup();
%mend;
%setup03();
/* 3) Invocation of the program under test */
%_putlog(i_msg=a warning to you Rudy
			,i_logLevel=1);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertLog(i_errors=0, i_warnings=1, i_desc=%str(Test that the Project Change Manager warning is captured));
%assertLogMsg(i_logmsg=%str(^WARNING:\%(PrjChngMgr\%) a warning to you Rudy)       
               ,i_desc=Test that the message is displayed with a warning level
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
%initTestcase(i_object=_putlog.sas, i_desc=Test that a message is displayed with a Project Change Manager error log level when explicitly set);
/* 2) Setup */
%macro setup04();
	%setup();
%mend;
%setup04();
/* 3) Invocation of the program under test */
%_putlog(i_msg=an error to you Rudy
			,i_logLevel=2);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
/* These asserts include:
*/
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(Test that the Project Change Manager error is captured));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) an error to you Rudy)       
               ,i_desc=Test that the message is displayed with a error level
             );
/* 6) Teardown */
%macro teardown04();
	%teardown();
%mend;
%teardown04();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */