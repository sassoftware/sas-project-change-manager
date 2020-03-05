/* readchangelog_tc02_data */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
%include "&g_root/fixture/readchangelog_output.sas";

PROC SQL noprint;
	CREATE TABLE EXPECTED.changeLogResult
		LIKE WORK.changeLogResult;
QUIT;

/* Add 1 row of arbitrary data so that the table can be inspected via the html report */
%_populatetablewithdatastep(i_characterColumnName=file,
	i_dataStatement=%str(
	DATA EXPECTED.changeLogResult;
		file="dummy";
		OUTPUT;
	RUN;
));

PROC DATASETS library=WORK nolist;
	DELETE changeLogResult;
QUIT;	 