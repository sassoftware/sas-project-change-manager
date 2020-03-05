/* executechangeset_tc10.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	date_executed=&g_test_executionDatetime.;
	OUTPUT;
RUN;