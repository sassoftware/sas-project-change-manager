/* createchangelogtables_tc02.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
%include "&g_root/fixture/installs/changeloglock_table.sas";

PROC SQL noprint;
	CREATE TABLE EXPECTED.databasechangeloglock
		LIKE INSTALLS.databasechangeloglock;
QUIT;
/* Add 1 row of arbitrary data so that the table can be inspected via the html report */
%_populatetablewithdatastep(i_numericColumnName=locked,
	i_dataStatement=%str(
	DATA EXPECTED.databasechangeloglock;
		
		locked=0;
		OUTPUT;
	RUN;
));

PROC DATASETS library=INSTALLS nolist;
	DELETE databasechangeloglock;
QUIT;