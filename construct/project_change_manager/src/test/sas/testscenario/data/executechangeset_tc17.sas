/* executechangeset_tc17.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	status="FAILED";
	OUTPUT;
RUN;