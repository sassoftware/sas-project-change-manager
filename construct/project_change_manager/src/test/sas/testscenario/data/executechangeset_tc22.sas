/* executechangeset_tc22.sas */

/****************     GLOBALS     ****************/



/****************     INPUT TABLES     ****************/



/****************     EXPECTED TABLES     ****************/
DATA EXPECTED.databasechangelog;
	
	logical_changelog="/com/sas/pcm/test/executechangeset_xml_tc22.xml";
	OUTPUT;
RUN;