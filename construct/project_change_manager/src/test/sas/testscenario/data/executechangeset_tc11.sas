/* executechangeset_tc11.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/


/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	order_executed=1;
	OUTPUT;
RUN;