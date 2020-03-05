
/**
\file
\ingroup    readchangelog

\brief      Test the _readchangelog macro

*/ /** \cond */ 

/***************************************************************************/
/* MACROS */
/***************************************************************************/

/***************************************************************************/
/* TEST SCENARIO - SETUP */
/***************************************************************************/
%macro testScenarioSetup();
	%_common_test_scenario_setup();
			
	/* CONSTANTS */
	%GLOBAL G_PCM_VERSION;
	%LET G_PCM_VERSION=1.0;
	
	OPTIONS NOQUOTELENMAX;
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
	/* Delete temporary tables */
	proc datasets library=WORK nolist;
		delete changeLogResult;
	quit;
	
	PROC DATASETS library=EXPECTED nolist
		kill;
	QUIT;
%mend;


%testScenarioSetup();

/***************************************************************************/
/* TEST CASES */
/***************************************************************************/

/********************   TEST CASE 01   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that a simple changelog can be read without errors);
/* 2) Setup */
%macro setup01();
	%setup();
	
	%include "&g_root/testscenario/data/readchangelog_tc01_data.sas";
%mend;
%setup01();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc01.xml
				,o_changeLogTable=WORK.changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log, no errors, no warnings));
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Smoke testing all expected results in the result table
				,i_allow=FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown01();
	%teardown();
%mend;
%teardown01();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 02   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the changelog table has the expected attributes);
/* 2) Setup */
%macro setup02();
	%setup();
	
	%include "&g_root/testscenario/data/readchangelog_tc02_data.sas";
%mend;
%setup02();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc02.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the variable lengths in the result table
				,i_allow=BASEOBS COMPOBS FORMAT LABEL INFORMAT VALUE);
/* 6) Teardown */
%macro teardown02();
	%teardown();
%mend;
%teardown02();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 03   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the changelog table does not truncate file strings.);
/* 2) Setup */
%macro setup03();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		ATTRIB file				length=$1000;
		
		file="shortfile.sas";
		output;
		
		file="/somedirectory/nesteddirectory1/nesteddirectory2/someotherfile.sas";
		output;
	RUN;
%mend;
%setup03();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc03.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the file strings are not truncated in the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown03();
	%teardown();
%mend;
%teardown03();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 04   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the relative file path is added to all rows in the result table.);
/* 2) Setup */
%macro setup04();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		logicalFilePath="/com/sas/pcm/test/readchangelog_xml_tc04.xml";
		output;
		logicalFilePath="/com/sas/pcm/test/readchangelog_xml_tc04.xml";
		output;
		logicalFilePath="/com/sas/pcm/test/readchangelog_xml_tc04.xml";
		output;
	RUN;
%mend;
%setup04();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc04.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the logical file path is output in each observation of the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown04();
	%teardown();
%mend;
%teardown04();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 05   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Testing the result if any of the include elements do not have the required file attribute);
/* 2) Setup */
%macro setup05();
	%setup();
%mend;
%setup05();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc05.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Invalid xml.  Required attribute %"%"file%"%" for element %"%"include%"%" is missing.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
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
%initTestcase(i_object=_readchangelog.sas, i_desc=Testing the result if saschangelog element does not have the required logicalFilePath attribute);
/* 2) Setup */
%macro setup06();
	%setup();
%mend;
%setup06();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc06.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Invalid xml.  Required attribute %"%"logicalFilePath%"%" for element %"%"saschangelog%"%" is missing.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
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
%initTestcase(i_object=_readchangelog.sas, i_desc=Testing the result if there are no include elements);
/* 2) Setup */
%macro setup07();
	%setup();
	
	%include "&g_root/testscenario/data/readchangelog_tc07_data.sas";
%mend;
%setup07();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc07.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing that an empty table is created with expected columns.
				,i_allow=FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown07();
	%teardown();
%mend;
%teardown07();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 08   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Testing the logicalFilePath handles the maximum number of characters);
/* 2) Setup */
%macro setup08();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		ATTRIB logicalFilePath	length=$1000;
		
		/* 10 chars */
		logicalFilePath="1234567890";
		/* 10*10=100 chars */
		logicalFilePath=catt(logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath);
		/* 100*10=1000 chars */
		logicalFilePath=catt(logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath,logicalFilePath);
		output;
	RUN;
%mend;
%setup08();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc08.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing that the logicalFilePath column has all 1000 characters untruncated.
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown08();
	%teardown();
%mend;
%teardown08();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 09   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Testing the file handles the maximum number of characters);
/* 2) Setup */
%macro setup09();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		ATTRIB file	length=$1000;
		
		/* 10 chars */
		file="1234567890";
		/* 10*10=100 chars */
		file=catt(file,file,file,file,file,file,file,file,file,file);
		/* 100*10=1000 chars */
		file=catt(file,file,file,file,file,file,file,file,file,file);
		output;
	RUN;
%mend;
%setup09();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc09.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing that the file column has all 1000 characters untruncated.
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown09();
	%teardown();
%mend;
%teardown09();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 10   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that an error occurs when a namespace does not match.);
/* 2) Setup */
%macro setup10();
	%setup();
%mend;
%setup10();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc10.xml
				,o_changeLogTable=WORK.changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Could not read the xml document metadata.  There may be an unexpected XML namespace.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
			);
/* 6) Teardown */
%macro teardown10();
	%teardown();
%mend;
%teardown10();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 11   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the Project Change Manager version is added to all rows in the result table.);
/* 2) Setup */
%macro setup11();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		pcmVersion="1.0";
		output;
		pcmVersion="1.0";
		output;
	RUN;
%mend;
%setup11();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc11.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the Project Change Manager version is output in each observation of the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown11();
	%teardown();
%mend;
%teardown11();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 12   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the schema version is added to all rows in the result table.);
/* 2) Setup */
%macro setup12();
	%setup();
	
	%include "&g_root/testscenario/data/readchangelog_tc12_data.sas";
%mend;
%setup12();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc12.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the schema version is output in each observation of the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown12();
	%teardown();
%mend;
%teardown12();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 13   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that an error occurs when a the changelog schema version is higher than the Project Change Manager schema version.);
/* 2) Setup */
%macro setup13();
	%setup();
%mend;
%setup13();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc13.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) The version of the schema used by the changelog %"%"2018.09%"%" is unsupported because it is too high.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
			);
/* 6) Teardown */
%macro teardown13();
	%teardown();
%mend;
%teardown13();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 14   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that an error occurs when a the schema version is lower than the Project Change Manager schema version.);
/* 2) Setup */
%macro setup14();
	%setup();
%mend;
%setup14();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc14.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) The version of the schema used by the changelog %"%"2016%"%" is an unsupported older version.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
			);
/* 6) Teardown */
%macro teardown14();
	%teardown();
%mend;
%teardown14();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 15   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Testing the result if saschangelog element does not have the required schemaVersion attribute);
/* 2) Setup */
%macro setup15();
	%setup();
%mend;
%setup15();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc15.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Invalid xml.  Required attribute %"%"schemaVersion%"%" for element %"%"saschangelog%"%" is missing.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
			);
/* 6) Teardown */
%macro teardown15();
	%teardown();
%mend;
%teardown15();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 16   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that an error occurs when a the schema version is non-numeric.);
/* 2) Setup */
%macro setup16();
	%setup();
%mend;
%setup16();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc16.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log, 1 error, no warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) The version of the schema used by the changelog %"%"character%"%" is invalid and can not be read.  Please validate against SASChangeLog.xsd.)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
%assertEquals(i_expected=%sysfunc(exist(WORK.changeLogResult))
				,i_actual=0
				,i_desc=Testing that the result table is not created
			);
/* 6) Teardown */
%macro teardown16();
	%teardown();
%mend;
%teardown16();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 17   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the no autoexec flag is read.);
/* 2) Setup */
%macro setup17();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		file="/somedirectory/yesauto.sas";
		noAutoexec="N";
		OUTPUT;
		
		file="/somedirectory/noauto.sas";
		noAutoexec="Y";
		OUTPUT;
	RUN;
%mend;
%setup17();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc17.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown17();
	%teardown();
%mend;
%teardown17();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 18   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the no autoexec flag is optional and defaults to N.);
/* 2) Setup */
%macro setup18();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		noAutoexec="N";
		OUTPUT;
	RUN;
%mend;
%setup18();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc18.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=0, i_desc=%str(check log, 0 errors, no warnings));
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown18();
	%teardown();
%mend;
%teardown18();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 19   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the no autoexec flag is restricted to 1 character.);
/* 2) Setup */
%macro setup19();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		noAutoexec="Y";
		OUTPUT;
	RUN;
%mend;
%setup19();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc19.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=0, i_warnings=1, i_desc=%str(check log for errors and warnings));
%assertLogMsg(i_logmsg=%str(^WARNING: Data truncation occurred on variable include_noautoexec Column length=1 Additional length=3.)       
               ,i_desc=%str(Test that the log message displays a truncation warning)
             );
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown19();
	%teardown();
%mend;
%teardown19();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 20   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that an error occurs for an invalid no autoexec flag.);
/* 2) Setup */
%macro setup20();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		noAutoexec="N";
		OUTPUT;
	RUN;
%mend;
%setup20();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc20.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertLog(i_errors=1, i_warnings=0, i_desc=%str(check log for errors and warnings));
%assertLogMsg(i_logmsg=%str(^ERROR:\%(PrjChngMgr\%) Invalid noAutoexec attribute value.  Expecting %"%"Y%"%" or %"%"N%"%".)       
               ,i_desc=%str(Test that the log message displays the ChangeLog error)
             );
/* 6) Teardown */
%macro teardown20();
	%teardown();
%mend;
%teardown20();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/********************   TEST CASE 21   ********************/
/* 1) Init Test Case */
%initTestcase(i_object=_readchangelog.sas, i_desc=Test that the no autoexec flag is case insensitive.);
/* 2) Setup */
%macro setup21();
	%setup();
	
	DATA EXPECTED.changeLogResult;
		noAutoexec="N";
		OUTPUT;
		
		noAutoexec="Y";
		OUTPUT;
	RUN;
%mend;
%setup21();
/* 3) Invocation of the program under test */
%_readChangeLog(i_changeLog=testscenario/data/xml/readchangelog_xml_tc21.xml
				,o_changeLogTable=changeLogResult);
/* 4) End Test Call */
/* %endTestcall() can be omitted, will be called implicitly by the first assert */
/* 5) Assertions */
%assertcolumns(i_expected=EXPECTED.changeLogResult
				,i_actual=WORK.changeLogResult
				,i_desc=Testing the result table
				,i_allow=COMPVAR FORMAT LABEL LENGTH INFORMAT);
/* 6) Teardown */
%macro teardown21();
	%teardown();
%mend;
%teardown21();
/* 7) End Test Case */
%endTestcase(i_assertLog=0);


/***************************************************************************/
/* END TEST CASES */
/***************************************************************************/

%testScenarioTeardown();

/** \endcond */