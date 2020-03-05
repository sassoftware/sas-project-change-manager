/* executechangeset_tc14.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	changeset="/../changesets/executechangeset_tc_any.sas";
	OUTPUT;
RUN;