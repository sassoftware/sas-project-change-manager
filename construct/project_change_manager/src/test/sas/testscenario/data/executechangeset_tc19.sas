/* executechangeset_tc19.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/
%_populatetablewithdatastep(i_numericColumnName=date_executed,
	i_dataStatement=%str(
	DATA INSTALLS.databasechangelog;
		
		logical_changelog="";
		changeSet="/../changesets/executechangeset_tc_any.sas";
		order_executed=1;
		status="FAILED";
		OUTPUT;
	RUN;
));



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	ATTRIB logical_changelog changeSet status length=$50;
	
	logical_changelog="";
	changeSet="/../changesets/executechangeset_tc_any.sas";
	order_executed=1;
	status="FAILED";
	OUTPUT;
	
	logical_changelog="";
	changeSet="/../changesets/executechangeset_tc_any.sas";
	order_executed=2;
	status="EXECUTED";
	OUTPUT;
RUN;