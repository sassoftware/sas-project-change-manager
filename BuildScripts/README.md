# BuildScripts Overview
The buildscripts are batch files used to quickly execute common sets of gradle tasks.

## Requirements
- [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
- A Windows environment connecting to a remote Unix-based SAS server is assumed

## Batch scripts
* **deploy\_Project_Change_Manager** - Builds and deploys Project Change Manager to the configured install directory
* **distZip\_Project_Change_Manager** - Creates a .zip archive for distribution to Windows based systems. This archive is what should be distributed to end users
* **example\_run\_\*** - Builds and deploys Project Change Manager and runs the corresponding example
* **SASUnit\_run\_SASUnit** - Deploys Project Change Manager and runs SASUnit tests and automatically opens the html report when complete.
* **SASUnit\_shared\_run\_SASUnit** - Runs SASUnit tests and automatically opens the html report when complete.  Requires a shared directory with the SAS server.

## Running the example_*.bat batch files
1. Copy the `remote\_commands\_samples` directory and paste it to the same location, renaming it to `remote\_commands`.
2. For each file in `remote_commands`, rename it by removing the `.sample` extension.
3. Edit the `remoteServer.properties` file contents with the values for your environment.
4. Edit each `*_sh\_commands.txt` file with the sudo password for your environment.
5. Now you can execute the `example\_run_*.bat' batch file(s) and they should complete successfully.

## How the example_* batch files work
- The credentials to the remote machine are set from the `remote\_commands/remoteServer.properties` file.
- In the `../construct/project_change_manager' directory the _clean_ and _distTest_ targets are run to assemble the code and example files.
- In the `../deploy/project_change_manager' directory the _clean_, _cleanRemote_, and _deployAll_ targets are run to deploy the files
- putty is then used to execute the shell command(s) contained in the corresponding `*_sh\_commands.txt`
- The `*_sh\_commands.txt` commands will modify permissions to make the main `pcm.sh` script executable by the user, and then run it.