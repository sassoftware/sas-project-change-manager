DATA INSTALLS.databasechangelog;
	ATTRIB USER					length=$255												label="User";
	ATTRIB LOGICAL_CHANGELOG	length=$255												label="ChangeLog Logical File Path";
	ATTRIB DATE_EXECUTED		length=8	format=DATETIME27.6	informat=DATETIME27.6	label="Date Executed";
	ATTRIB ORDER_EXECUTED		length=8	format=10.			informat=10.			label="Order Executed";
	ATTRIB STATUS				length=$10												label="Status";
	ATTRIB MD5SUM				length=$35												label="MD5 Checksum";
	ATTRIB CHANGESET			length=$255												label="Changeset File Path";
	ATTRIB PCM_VERSION			length=$20												label="Project Change Manager Version";

	SET _NULL_;
RUN;