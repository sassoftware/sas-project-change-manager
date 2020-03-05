# Construct Overview
***
The construct directory contains source code that can be built in several ways depending on the need (archived in a .zip or .tar for example).  There are no environment-specific configuration files here, except those that can be used to speed up testing during the development of Project Change Manager.


## Key Gradle targets
clean - Deletes the project build directory

distTar - Creates a .tar archive for distribution to Unix based systems.  This archive is what should be distributed to end users.

distZip - Creates a .zip archive for distribution to Windows based systems.  This archive is what should be distributed to end users.

distTest - Creates an archive which includes test files.  These can then be deployed to an environment for SASUnit testing.

## `shared*` targets
Project Change Manager was developed using SAS Unix on a (VMWare Workstation) virtual machine with a Windows file system shared to the Unix system.  Any gradle task with the prefix "shared" will be removed unless the `gradle.properties` `SAS_CODE_ON_SHARED_VM` is set to **true**.
`shared*` targets require a `known_hosts` file and `gradle.properties` values to be set.

sharedUnitTests - Runs SASUnit tests and automatically opens the html report when complete.
