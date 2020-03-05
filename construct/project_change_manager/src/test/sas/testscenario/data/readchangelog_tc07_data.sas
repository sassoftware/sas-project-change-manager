/* readchangelog_tc07_data */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
%include "&g_root/fixture/readchangelog_output.sas";

PROC SQL noprint;
	CREATE TABLE EXPECTED.changeLogResult
		LIKE WORK.changeLogResult;
QUIT;

PROC DATASETS library=WORK nolist;
	DELETE changeLogResult;
QUIT;	 