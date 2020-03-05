REM ############################################################################ REM
REM # Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. REM
REM # SPDX-License-Identifier: Apache-2.0                                        REM
REM ############################################################################ REM

cd %~dp0/../construct/project_change_manager
REM -------------------------------------------------------------------------------
REM Clean the directories - delete the vm code and sasunit build directories and run gradle clean
REM -------------------------------------------------------------------------------
call gradle clean

REM -------------------------------------------------------------------------------
REM deploy and run the code
REM -------------------------------------------------------------------------------
call gradle sharedUnitTests

pause