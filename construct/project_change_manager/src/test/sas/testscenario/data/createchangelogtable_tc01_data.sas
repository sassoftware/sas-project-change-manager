/* createchangelogtables_tc01.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
%include "&g_root/fixture/installs/changelog_table.sas";

PROC SQL noprint;
	CREATE TABLE EXPECTED.databasechangelog
		LIKE INSTALLS.databasechangelog;
QUIT;
/* Add 1 row of arbitrary data so that the table can be inspected via the html report */
%_populatetablewithdatastep(i_numericColumnName=date_executed,
	i_dataStatement=%str(
	DATA EXPECTED.databasechangelog;
		
		date_executed=0;
		OUTPUT;
	RUN;
));

PROC DATASETS library=INSTALLS nolist;
	DELETE databasechangelog;
QUIT;