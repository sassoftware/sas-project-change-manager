/* createchangelogtables_tc05.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangeloglock;	
	locked=0;
	lock_granted=.;
	locked_by="";
	OUTPUT;
RUN;