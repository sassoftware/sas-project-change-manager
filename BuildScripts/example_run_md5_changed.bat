REM ############################################################################ REM
REM # Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved. REM
REM # SPDX-License-Identifier: Apache-2.0                                        REM
REM ############################################################################ REM

For /F "tokens=1* delims==" %%A IN (remote_commands/remoteServer.properties) DO ( 
	IF "%%A"=="remoteUser" set remoteUser=%%B
	IF "%%A"=="remoteHost" set remoteHost=%%B
	IF "%%A"=="remotePassword" set remotePassword=%%B
	IF "%%A"=="sudoPassword" set sudoPassword=%%B
) 

cd %~dp0/../construct/project_change_manager
REM -------------------------------------------------------------------------------
REM Clean the directories and construct the archive
REM -------------------------------------------------------------------------------
call gradle clean distTest

cd %~dp0/../deploy/project_change_manager
REM -------------------------------------------------------------------------------
REM deploy and unpack the archive
REM -------------------------------------------------------------------------------
call gradle clean cleanRemote deployAll

ECHO Executing putty with "%remoteUser%" and "%remoteHost%"

putty.exe -ssh %remoteUser%@%remoteHost% -pw %remotePassword% -m %~dp0/remote_commands/example_run_md5_changed_sh_commands.txt

PAUSE