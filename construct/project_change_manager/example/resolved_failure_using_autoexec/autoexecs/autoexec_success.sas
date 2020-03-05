/*----------------------------------------------------------------------------*/
/* Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. */
/* SPDX-License-Identifier: Apache-2.0                                        */
/*----------------------------------------------------------------------------*/

%PUT ==================================================================;
%PUT Running the autoexec program which will cause a changeset to pass.;
%PUT ==================================================================;

%GLOBAL g_failSecondProgram;
%let g_failSecondProgram=0;