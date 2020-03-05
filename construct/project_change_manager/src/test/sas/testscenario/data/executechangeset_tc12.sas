/* executechangeset_tc12.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/
%_populatetablewithdatastep(i_numericColumnName=date_executed,
	i_dataStatement=%str(
	DATA INSTALLS.databasechangelog;
		
		order_executed=1;
		OUTPUT;
		order_executed=2;
		OUTPUT;
		order_executed=3;
		OUTPUT;
		order_executed=4;
		OUTPUT;
	RUN;
));


/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	order_executed=1;
	OUTPUT;
	order_executed=2;
	OUTPUT;
	order_executed=3;
	OUTPUT;
	order_executed=4;
	OUTPUT;
	order_executed=5;
	OUTPUT;
RUN;