/**
   \file
   \ingroup    PCM_SASUNIT

   \brief      Run all test scenarios for Project Change Manager project

               (see also <A href="https://sourceforge.net/p/sasunit/wiki/User's%20Guide/" target="_blank">SASUnit User's Guide</A>)\n
               
*/ /** \cond */  

OPTIONS 
   MPRINT MAUTOSOURCE NOMLOGIC NOSYMBOLGEN
   SASAUTOS=(SASAUTOS "%sysget(SASUNIT_ROOT)/saspgm/sasunit") /* SASUnit macro library */
;

/* open test repository or create when needed */
%initSASUnit(
   i_root            = . 									/* root path, all other paths can then be relative paths */
  ,io_target         = doc 									/* Output of SASUnit: test repository, logs, results, reports */
  ,i_overwrite       = %sysget(SASUNIT_OVERWRITE)        	/* set to 1 to force all test scenarios to be run, else only changed 
                                         					scenarios or scenarios with changed unit under test will be run*/
  ,i_project         = SASUnit for Project Change Manager	/* Name of project, for report */
  ,i_sasunit         = %sysget(SASUNIT_ROOT)/saspgm/sasunit /* SASUnit macro library */
  /* Explicitly set the sasautos, since we want to include the sasunit macros in our testing */
  ,i_sasautos        = %sysget(SASUNIT_ROOT)/saspgm/sasunit /* Search for units under test here */
  ,i_sasautos1       = %sysget(SASUNIT_ROOT)/../../sas
  ,i_sasautos2       = %sysget(SASUNIT_ROOT)/pgm
  ,i_testdata        = dat         					/* test data, libref testdata */
  ,i_refdata         = dat         					/* reference data, libref refdata */
  ,i_sascfg          = bin/sasv9.cfg
  ,i_testcoverage    = %sysget(SASUNIT_COVERAGEASSESSMENT)              /* set to 1 to assess test coverage assessment */
  ,i_verbose         = 0									/* verbose 1 causes error messages, casusing an error-value return code. */
  															/*    These may be due to errors creating directories when they exist in the test scn _mkdirs */   
)

/* Run specified test scenarios. There can be more than one call to runSASUnit */
%runSASUnit(i_source = testscenario/%str(*)_test.sas);

/*
%runSASUnit(i_source = testscenario/createchangelogtables_test.sas);
%runSASUnit(i_source = testscenario/executechangelog_test.sas);
%runSASUnit(i_source = testscenario/executechangeset_test.sas);
%runSASUnit(i_source = testscenario/initpcm_test.sas);
%runSASUnit(i_source = testscenario/pcm_test.sas);
%runSASUnit(i_source = testscenario/putlog_test.sas);
%runSASUnit(i_source = testscenario/readchangelog_test.sas);
%runSASUnit(i_source = testscenario/scanchangesetlog_test.sas);
*/

/* Create or recreate HTML pages for report where needed */
%reportSASUnit(
   i_language=%upcase(%sysget(SASUNIT_LANGUAGE))
  ,o_html=1
  ,o_junit=1
);

/** \endcond */
