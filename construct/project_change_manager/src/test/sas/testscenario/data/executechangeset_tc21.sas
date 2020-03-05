/* executechangeset_tc21.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/
%_populatetablewithdatastep(i_numericColumnName=date_executed,
	i_dataStatement=%str(
	DATA INSTALLS.databasechangelog;
		
		logical_changelog="";
		changeSet="/../changesets/executechangeset_tc_any.sas";
		order_executed=1;
		status="EXECUTED";
		md5sum="1234567890ABCDEF1234567890ABCDEF";
		OUTPUT;
	RUN;
));



/****************     EXPECTED TABLES     ****************/