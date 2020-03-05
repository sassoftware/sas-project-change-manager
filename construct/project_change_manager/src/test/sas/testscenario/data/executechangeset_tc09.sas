/* executechangeset_tc09.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	logical_changelog="/com/sas/pcm/test/executechangeset_xml_tc09.xml";
	OUTPUT;
RUN;