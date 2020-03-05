DATA INSTALLS.databasechangeloglock;
	ATTRIB LOCKED		length=8												label="Locked";
	ATTRIB LOCK_GRANTED	length=8	format=DATETIME27.6	informat=DATETIME27.6	label="Lock Granted";
	ATTRIB LOCKED_BY	length=$38												label="Locked By";

	locked=0;
	lock_granted=.;
	locked_by="";
	OUTPUT;
RUN;