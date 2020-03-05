#!/bin/bash

cd ..
export SASUNIT_ROOT=$(readlink -f ../sasunit/.)
export SASUNIT_OVERWRITE=1
export SASUNIT_COVERAGEASSESSMENT=0
export SASUNIT_LANGUAGE=en
export SASUNIT_HOST_OS=linux
export SASUNIT_SAS_VERSION=9.4
export SASCFGPATH=./bin/sasv9.cfg

export PCM_ROOT=$(readlink -f ../../.)
export PCM_SAS_HOME=/sas/SASHome
export PCM_SAS_VERSION=9.4
export PCM_INSTALLS_LOC=$SASUNIT_ROOT/dat/installs
export PCM_LOG_ROOT=$SASUNIT_ROOT/doc/log
export PCM_CHANGESET_AUTOEXEC=


#echo SASUnit root path     = $SASUNIT_ROOT
#echo SASUnit config        = $SASCFGPATH
#echo Overwrite             = $SASUNIT_OVERWRITE
#echo Testcoverage          = $SASUNIT_COVERAGEASSESSMENT
echo

echo "Starting SASUnit ..."  
@SAS_HOME@/SASFoundation/$SASUNIT_SAS_VERSION/bin/sas_$SASUNIT_LANGUAGE -nosyntaxcheck -noovp


# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review pcmtestsuite.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check pcmtestsuite.log for details!\n"
fi
