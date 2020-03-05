/* executechangelog_tc05.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/
DATA changeLog;
	ATTRIB file length=$1000;
	
	SET _NULL_;
RUN;



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangeloglock;	
	locked=0;
	lock_granted=.;
	locked_by="";
	OUTPUT;
RUN;