/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

PROC SQL noprint;
	INSERT INTO INSTALLS.databasechangeloglock
	SET locked=0,
		lock_granted=.,
		locked_by="";
QUIT;