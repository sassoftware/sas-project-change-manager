/* executechangeset_tc13.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	status="EXECUTED";
	OUTPUT;
RUN;