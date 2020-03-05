# Project Change Manager

## Overview
Project Change Manager is a project change management tool that will manage your project's SAS assets and set them to a known state.  Never make the same change twice, and view an audit table to track changes.  It is inspired by [Liquibase](https://www.liquibase.org/).
Includes many examples to help learn how to make the best use out of this tool.

While initially developed on Linux SAS remotely, it could be enhanced to run on Windows or locally with only minor modifications.

Project Change Manager is a set of a SAS programs and macros that will read as input an XML changelog which lists the changesets (SAS programs) to be executed. Each changeset will have its log file redirected to a common log directory, and its execution will be logged in a databasechangelog data set. A changeset can be run only once. By reviewing the databasechangelog you can quickly gather information to determine the state of your SAS assets, and by reviewing the logs you can review the outcome of each changeset.

### Prerequisites
- SAS 9.4 or above
- Linux SAS

### Installation
The distribution can be found in the bin directory.  Download the appropriate archive file and extract to your SAS server.

* _project\_change\_manager\_dist-1.0.zip_ - for Windows

* _project\_change\_manager\_dist-1.0.tar_ - for Linux

---
## Running Project Change Manager
Project Change Manager is invoked by running a SAS program, pcm.sas in batch mode.  pcm.sas requires a combination of environment variables and SAS command options to define your SAS environment specifics, as well as things such as where the log files should be located, where the databasechangelog data sets should be located, and where the changelog is located.

See the examples for shell scripts that invoke Project Change Manager, as well as _changelog_ and _changeset_ examples.


### Environment variables
* **PCM\_ROOT** - the path to the top level Project Change Manager directory

* **PCM\_SAS\_HOME** - the path to SASHome

* **PCM\_SAS\_VERSION** - the major and minor release version of SAS

* **PCM\_LOG\_ROOT** - The path to where the Project Change Manager log files will be written

* **PCM\_CHANGESET\_AUTOEXEC** - The path of the autoexec file to be executed before each changeset.  Leave blank if no autoexec is to be run.

* **PCM\_INSTALLS\_LOC** - The path to the location where the install data sets are located (i.e databasechangelog, databasechangeloglock)



### SAS command options
* **sysin** - the path to the main pcm.sh program

* **log** - the location for the Project Change Manager log.

* **print** - the location for the Project Change Manager LISTING output file

* **insert** - used to add Project Change Manager macros to the SASAUTOS system option, e.g. `-insert SASAUTOS $PCM\_ROOT/sas`

* **initstmt** - used to assign the g\_changeLog macrovariable to the path to the _changelog_, e.g. `-initstmt "%LET g_changeLog=<pathToChangelog/changelog.xml;"`


### Integration with gradle
In the examples Project Change Manager is executed with a shell (.sh) script.  In practice you may wish to invoke it with a build tool.  Project Change Manager has been used against gradle, but any tool that execute a command line process will do.

Here is an example of using Project Change Manager using gradle.

	task Apply_Snapshot(type: Exec) {
		
		workingDir "${project.rootDir}/Setup/install/snapshot"	
		ignoreExitValue = true // Do errorCheck to handle the error with a helpful message 
			
		// Add the metadata 
		def NOW=pcmDateFormat.format(new Date())	
		commandLine "${config.sas.directories.sashome}/SASFoundation/${config.sas.version}/sas",
					"-nosyntaxcheck",
					"-noovp",
					"-sysin", "${project.rootDir}/project_change_manager_dist-1.0/sas/pcm.sas",
					"-log", "${config.sas.directories.sasconfig}/${config.sas.directories.level}/${config.sas.servers.appserver.name}/${installedAppName}/Logs/${NOW}_pcm.log",
					"-print", "${config.sas.directories.sasconfig}/${config.sas.directories.level}/${config.sas.servers.appserver.name}/${installedAppName}/Logs/${NOW}_pcm.lst",
					"-insert", "SASAUTOS", "${project.rootDir}/project_change_manager_dist-1.0/sas",
					"-initstmt", "\"%let g_changeLog=${project.rootDir}/Setup/install/snapshot/SnapshotLog.xml;\""

		environment PCM_ROOT: "${project.rootDir}/project_change_manager_dist-1.0",
					PCM_SAS_HOME: "${config.sas.directories.sashome}", 
					PCM_SAS_VERSION: "${config.sas.version}",
					PCM_LOG_ROOT: "${config.sas.directories.sasconfig}/${config.sas.directories.level}/${config.sas.servers.appserver.name}/${installedAppName}/Logs",
					PCM_CHANGESET_AUTOEXEC: ""
					
		// Check after execution for anything higher than a warning 	
		doLast {
			errorCheck(execResult.getExitValue(), name, "Check the log file at ${config.sas.directories.sasconfig}/${config.sas.directories.level}/${config.sas.servers.appserver.name}/${installedAppName}/Logs/${NOW}_pcm.log")
		}
	}

## Defining a Project Change Manager Changelog

### Creating a changelog
* The changlog is defined by `/src/main/resources/xml/xsd/SASChangLog.xsd`
* The changelog must define a namespace, logicalFilePath, and schemaVersion.
* The changelog should define 1 or more changesets by specifying an _include_ xml tag for each changeset.

**ChangeLog tag attributes**:

* **Namespace** - The namespace is a constant value of _http://xml.pcm.sas.com/saschangelog_
* **logicalFilePath** - Must be unique.
* **schemaVersion** - Must match the current version expected by Project Change Manager




**Include tag attributes**:

* **file (required)** - Defines the relative location of the changeset to be included.
* **noAutoexec (optional)** - If an autoexec is given to the main Project Change Manager program on execution it will run by default before each changeset.  By setting noAutoexec to _N_ the autoexec won't run for that particular changset.  Valid values are _Y_ and _N_.  Defaults to _Y_.


### Creating a changeset
A changeset is a SAS program.  It can be as simple or complex as you make it.  A good principle to follow is to make sure you have lots of informative _put_ statements in case you need to review the logs.

When a changeset is executed Project Change Manager will pass it a global macrovariable _g\_pcm\_root_ which can then be used in the changeset.  This is the root location of Project Change Manager as defined by the **PCM\_ROOT** environment variable.

Although a changeset is limited to being a SAS program, SAS programs themselves can use the [system function](https://go.documentation.sas.com/?docsetId=lefunctionsref&docsetTarget=p028ivnihf9y1hn1n05tp55587jz.htm&docsetVersion=9.4&locale=en) to invoke OS commands. (A potential enhancement could be to broaden what could be executed as a changeset).  This leaves a broad range of possibilities, such as managing directories and files, invoking gradle targets, and executing other command line tools.  

Some SAS-specific code that can be written include managing data sets through Data steps and [PROC Datasets](https://go.documentation.sas.com/?docsetId=proc&docsetTarget=p0xdkenol7pi1cn14p0iq38shax4.htm&docsetVersion=9.4&locale=en), managing metadata through the [metadata interface](https://go.documentation.sas.com/?docsetId=lrmeta&docsetTarget=lrmetawhatsnew94.htm&docsetVersion=9.4&locale=en#p1w92uhg2qn2pyn1b2mon8yhxn3y), and anything else that SAS code can do and interface with.

### How the changelog is processed
Project Change Manager will read the changelog and compare the changesets with the list of changesets registered in the databasechangelog data set.  If a changeset has previously been run successfully, the changeset will be skipped.


### Failure handling
If a failure is encountered on any changeset it will be marked as failed in the databasechangelog and Project Change Manager will end execution.  None of the proceeding changesets will be executed.

If a warning is encountered in any changeset then it will be handled as an error and Project Change Manager will cease processign changesets.  (There are a number of warnings that are allowed and they are registered to an internal whitelist.)

### Changeset validation
When a changeset is succesfully executed Project Change Manager will store in the databasechangelog an validation checksum on the contents of the changeset.  If the changeset runs again (as identified by the changelog logicalFilePath and changeset name) Project Change Manager will compare its validation checksum with that of the changeset registered in the databasechangelog.  If the changeset has been modified an error will be thrown and execution will stop.

## Contributing
We welcome your contributions! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to submit contributions to this project.

## License
This project is licensed under the [Apache 2.0 License](LICENSE).

## Additional Resources

