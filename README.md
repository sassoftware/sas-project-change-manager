# Project Change Manager

## Overview
Project Change Manager is a project change management tool. The Project Change Manager manages manage your project's SAS assets and sets them to a known state.  Do not make the same change twice and view an audit table to track changes.  The Project Change Manager is inspired by [Liquibase](https://www.liquibase.org/). It includes several examples on how to make the best use of the Project Chanage Manager. 

It is currently being developed on Linux SAS remotely. It can be enhanced to run on Windows or locally with only minor modifications.

Project Change Manager is a set of a SAS programs and macros that is read as input into an XML changelog. The XML changelog, which lists the changesets (SAS programs) to be executed. Each changeset has its log file redirected to a common log directory, and its execution will be logged in a databasechangelog data set. A changeset can run only once. By reviewing the databasechangelog, you can quickly gather information to determine the state of your SAS assets. By reviewing the logs, you can review the outcome of each changeset.

### Prerequisites
- SAS 9.4 or above
- Linux SAS

### Installation
The distribution can be found in the bin directory.  Download the appropriate archive file and extract to your SAS server.

* _project\_change\_manager\_dist-1.0.zip_ - for Windows

* _project\_change\_manager\_dist-1.0.tar_ - for Linux

---
## Running Project Change Manager
Project Change Manager is invoked by running a SAS program, pcm.sas in batch mode. pcm.sas requires a combination of the following:
* Environment variables. 
* SAS command options to define your SAS environment specifics.
* The location of the log files. 
* The location of the databasechangelog data sets.
* The location of the changelog.

See the examples for shell scripts that invoke Project Change Manager, as well as _changelog_ and _changeset_ examples.

### Environment variables
* **PCM\_ROOT** - Defines the path to the top level Project Change Manager directory.

* **PCM\_SAS\_HOME** - Defines the path to SASHome. 

* **PCM\_SAS\_VERSION** - The major and minor release version of SAS.

* **PCM\_LOG\_ROOT** - Defines the path to where the Project Change Manager log files will be written.

* **PCM\_CHANGESET\_AUTOEXEC** - The path of the autoexec file to be executed before each changeset.  Leave blank if no autoexec is to be run.

* **PCM\_INSTALLS\_LOC** - The path to the location where the install data sets are located. For example: databasechangelog and databasechangeloglock. 

### SAS command options
* **sysin** Defines the path to the main pcm.sh program.

* **log** - Defines the location for the Project Change Manager log.

* **print** - Defines the location for the Project Change Manager LISTING output file.

* **insert** - Used to add Project Change Manager macros to the SASAUTOS system option, for example, `-insert SASAUTOS $PCM\_ROOT/sas`.

* **initstmt** - Used to assign the g\_changeLog macrovariable to the path to the _changelog_, for example, `-initstmt "%LET g_changeLog=<pathToChangelog/changelog.xml;"`.


### Integration with gradle
In the examples, Project Change Manager executes with a shell (.sh) script. In practice, you might want to invoke it with a build tool. Project Change Manager is used against gradle, but any tool that execute a command line process will do.

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
* The changlog is defined by `/src/main/resources/xml/xsd/SASChangLog.xsd`.
* The changelog must define a namespace, logicalFilePath, and schemaVersion.
* The changelog should define 1 or more changesets by specifying an _include_ xml tag for each changeset.

**ChangeLog tag attributes**:

* **Namespace** - The namespace is a constant value of _http://xml.pcm.sas.com/saschangelog_.
* **logicalFilePath** - Must be unique.
* **schemaVersion** - Must match the current version expected by Project Change Manager.

**Include tag attributes**:

* **file (required)** - Defines the relative location of the changeset to be included.
* **noAutoexec (optional)** - If an autoexec is given to the main Project Change Manager program on execution it will run by default before each changeset. By setting noAutoexec to N the autoexec won't run for that changeset. Valid values are Y and N. Defaults to Y.

### Creating a changeset
A changeset is a SAS program. A changeset can be as simple or complex as you make it. A good principle to follow is to make sure you have lots of informative put statements in case you need to review the logs.

When a changeset is executed Project Change Manager will pass it a global macrovariable g_pcm_root, which can then be used in the changeset. This is the root location of Project Change Manager as defined by the **PCM_ROOT** environment variable.

Although a changeset is limited to being a SAS program, SAS programs themselves can use the [system function](https://go.documentation.sas.com/?docsetId=lefunctionsref&docsetTarget=p028ivnihf9y1hn1n05tp55587jz.htm&docsetVersion=9.4&locale=en) to invoke OS commands. A potential enhancement could be to broaden what could be executed as a changeset.  This leaves a broad range of possibilities, such as managing directories and files, invoking gradle targets, and executing other command line tools.  

Some SAS-specific code that can be written include the following:
* Managing data sets through Data steps and [PROC Datasets](https://go.documentation.sas.com/?docsetId=proc&docsetTarget=p0xdkenol7pi1cn14p0iq38shax4.htm&docsetVersion=9.4&locale=en). 
* Managing metadata through the [metadata interface](https://go.documentation.sas.com/?docsetId=lrmeta&docsetTarget=lrmetawhatsnew94.htm&docsetVersion=9.4&locale=en#p1w92uhg2qn2pyn1b2mon8yhxn3y).
* Any SAS code can do and interface with.

### How the changelog is processed
Project Change Manager reads the changelog and compares the changesets with the list of changesets registered in the databasechangelog data set. If a changeset has previously been run successfully, the changeset will be skipped.

### Failure handling
If you encounter a failure on any changeset, it is marked as failed in the databasechangelog.  The Project Change Manager ends execution. None of the proceeding changesets is executed.

If a warning is encountered in any changeset, then it will be handled as an error and Project Change Manager will cease processing changesets. There are a few warnings that are allowed, and they are registered to an internal whitelist.

### Changeset validation
When a changeset is successfully executed, Project Change Manager will store in the databasechangelog a validation checksum on the contents of the changeset. If the changeset runs again, as identified by the changelog logicalFilePath and changeset name, Project Change Manager compares its validation checksum with that of the changeset registered in the databasechangelog. If the changeset has been modified, an error is thrown and execution stops. 

## Contributing
We welcome your contributions! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to submit contributions to this project.

## License
This project is licensed under the [Apache 2.0 License](LICENSE).

## Additional Resources
* [SAS Documentation](www.documentation.sas.com)
