/* Clears out the common test data */

%macro _common_test_scenario_teardown();

/* Simply delete the directories, then create them again. */
/* Delete */
PROC DATASETS lib=EXPECTED nolist kill;
QUIT;
%LET l_rc=%_delfile(&g_refdata./expected);

PROC DATASETS lib=INSTALLS nolist kill;
QUIT;
%LET l_rc=%_delfile(&g_testdata./installs);


/* Create */
%_mkdir(&g_refdata./expected);

%mend _common_test_scenario_teardown;