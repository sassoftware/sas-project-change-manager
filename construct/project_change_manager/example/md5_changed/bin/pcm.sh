##############################################################################
# Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. #
# SPDX-License-Identifier: Apache-2.0                                        #
##############################################################################

cd ..
export PCM_ROOT=$(readlink -f ../../.)
export PCM_SAS_HOME=/sas/SASHome
export PCM_SAS_VERSION=9.4
export PCM_LOG_ROOT=$PCM_ROOT/example/md5_changed/log
export PCM_CHANGESET_AUTOEXEC=
export PCM_INSTALLS_LOC=$PCM_ROOT/example/md5_changed/installs

NOW=$(date +%Y%m%dT%H%M%S%3N)

echo "Starting Project Change Manager ..."  
$PCM_SAS_HOME/SASFoundation/$PCM_SAS_VERSION/sas -nosyntaxcheck -noovp -sysin $PCM_ROOT/sas/pcm.sas -log ./log/${NOW}_pcm.log -print ./log/pcm.lst -insert SASAUTOS $PCM_ROOT/sas -initstmt "%let g_changeLog=Snapshot/SnapshotLog.xml;"

# Show SAS exit status
RETVAL=$?
if [ $RETVAL -eq 1 ] 
	then printf "\nSAS ended with warnings. Review log/${NOW}_pcm.log for details.\n"
elif [ $RETVAL -eq 2 ] 
	then printf "\nSAS ended with errors! Check log/${NOW}_pcm.log for details!\n"
fi
