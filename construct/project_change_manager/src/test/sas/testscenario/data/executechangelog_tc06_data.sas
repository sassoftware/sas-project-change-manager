/* executechangelog_tc06.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/
DATA changeLog;
	ATTRIB file length=$1000;
	
	SET _NULL_;
RUN;

/* Mark the table as locked */
%_populatetablewithdatastep(i_numericColumnName=locked,
	i_dataStatement=%str(
	DATA INSTALLS.databasechangeloglock;
		locked=1;
		OUTPUT;
	RUN;
));



/****************     EXPECTED TABLES     ****************/