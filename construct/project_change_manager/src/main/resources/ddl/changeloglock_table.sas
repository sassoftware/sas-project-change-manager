/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

DATA INSTALLS.databasechangeloglock;
	ATTRIB LOCKED		length=8												label="Locked";
	ATTRIB LOCK_GRANTED	length=8	format=DATETIME27.6	informat=DATETIME27.6	label="Lock Granted";
	ATTRIB LOCKED_BY	length=$38												label="Locked By";

	SET _NULL_;
RUN;