# Deploy Overview
***

## Key Gradle targets
clean - Deletes the project build directory

cleanRemote - Deletes the deployed archive and temporary files from the remote machine

cleanUnitTestReport - Deletes the local unit test files

deployAll - Deploys Project Change Manager to the configured install directory

unitTests - Deploys Project Change Manager and runs SASUnit tests and automatically opens the html report when complete.


## Property files to be created and configured:
- gradle.properties
- known_hosts

### gradle.properties
Configures how the analytics archive is deployed.

DISTRIBUTION\_DIR - should point to the directory that contains the project_change_manager_dist-<version>.<ext> file

PCM\_INSTALL\_DIR - the directory path to the Project Change Manager directory

DEPLOY_METHOD - set this to 'copy' if the archive to to be copied to a local or remote directory.
Set this to 'remote' if this archive is being copied via ssh. If so then the other remote
				parameters must be set.

If the DEPLOY_METHOD = 'remote' then set these:

	REMOTE_HOST - ip or DNS name of the host
	REMOTE_USER - user name on the host
	REMOTE_PASSWORD - password on the host





### known_hosts

Create a known_hosts file with the public key from the host you are accessing. File should be in the form of:
<hostname or ip address> ssh-rsa <public key ...>
To find the public key in the host machine, run the following command:
`ssh-keyscan -t rsa <hostname or ip address>`
	



