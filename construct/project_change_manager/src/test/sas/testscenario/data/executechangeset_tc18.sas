/* executechangeset_tc18.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/
%_populatetablewithdatastep(i_numericColumnName=date_executed,
	i_dataStatement=%str(
	DATA INSTALLS.databasechangelog;
		
		logical_changelog="";
		changeSet="/../changesets/executechangeset_tc_any.sas";
		order_executed=1;
		status="EXECUTED";
		md5sum="8C4F9C78BF14F6E09A889FDC221A1C8D";
		OUTPUT;
	RUN;
));


/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	logical_changelog="";
	changeSet="/../changesets/executechangeset_tc_any.sas";
	order_executed=1;
	status="EXECUTED";
	OUTPUT;
RUN;