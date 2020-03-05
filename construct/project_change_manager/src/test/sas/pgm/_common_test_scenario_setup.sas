/**
 Defines specific test and reference data locations. 
 From there create test librefs: v12br, staging, etc.
 
 */

%macro _common_test_scenario_setup();


/* Create physical TEST data libraries*/
%_mkdir(&g_refdata./expected);
%_mkdir(&g_testdata./installs);

/* Setup the reference data library */
libname EXPECTED "&g_refdata./expected";
libname INSTALLS "&g_testdata./installs";

%mend _common_test_scenario_setup;