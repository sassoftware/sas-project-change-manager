# Project Change Manager

## Overview
Project Change Manager is a project change management tool. The Project Change Manager manages your project's SAS assets and sets them to a known state.  Do not make the same change twice and view an audit table to track changes.  The Project Change Manager is inspired by [Liquibase](https://www.liquibase.org/). It includes several examples on how to make the best use of the Project Chanage Manager. 

It is currently being developed on Linux SAS remotely. It can be enhanced to run on Windows or locally with only minor modifications.

Project Change Manager is a set of a SAS programs and macros that is read as input into an XML changelog. The XML changelog lists the changesets (SAS programs) to be executed. Each changeset has its log file redirected to a common log directory, and its execution will be logged in a databasechangelog data set. A changeset can run only once. By reviewing the databasechangelog, you can quickly gather information to determine the state of your SAS assets. By reviewing the logs, you can review the outcome of each changeset.

### Prerequisites
- SAS 9.4 or above
- Linux SAS

### Installation
The distribution can be found in the bin directory.  Download the appropriate archive file and extract to your SAS server.

* _project\_change\_manager\_dist-1.0.zip_ - for Windows

* _project\_change\_manager\_dist-1.0.tar_ - for Linux

---
## Table of Contents
[Getting Started with Project Change Manager](#getting-started-with-project-change-manager)

  - [Downloading and Deploying the ZIP File](#downloading-and-deploying-the-zip-file)
  - [Using the Success Example Project](#using-the-success-example-project)
    * [Review the Example Project](#review-the-example-project)
    * [Run the *Example Project*](#run-the-example-project)
    * [Investigating the Logs](#investigating-the-logs)
    * [Investigating the databasechangelog](#investigating-the-databasechangelog)
  - [Other examples](#other-examples)
    * [Conditional\_autoexec](#conditional_autoexec)
    * [Failed](#failed)
    * [Md5\_changed](#md5_changed)
    * [Resolved\_failure\_using\_autoexec](#resolved_failure_using_autoexec)
    * [Success\_with\_warnings\_due\_to\_whitelist](#success_with_warnings_due_to_whitelist)
    * [Warnings\_fail](#warnings_fail)

[Running Project Change Manager](#running-project-change-manager)

  - [Environment variables](#environment-variables)
  - [SAS command options](#sas-command-options)
  - [Integration with gradle](#integration-with-gradle)

[Defining a Project Change Manager Changelog](#defining-a-project-change-manager-changelog)

  - [Creating a changelog](#creating-a-changelog)
  - [Creating a changeset](#creating-a-changeset)
  - [How the changelog is processed](#how-the-changelog-is-processed)
  - [Failure handling](#failure-handling)
  - [Changeset validation](#changeset-validation)

[Contributing](#contributing)

[License](#license)

[Additional Resources](#additional-resources)

---
### Getting Started with Project Change Manager

This is a step-by-step guide to downloading, configuring and running one of the examples from Project Change Manager. 
It will also highlight some of the key features to review, such as log messages and the change tracking databasechangelog data set.


### Downloading and Deploying the ZIP File

1.  Select the latest version of the ZIP or TAR archive file by navigating to
    <https://github.com/sassoftware/sas-project-change-manager/tree/master/bin>
    and clicking on the desired file.

2.  Click the Download button to download the archive file to your local machine. 


    > ![image](/README/images/01_Download.png)

3.  Copy the archive file to a location accessible to your SAS installation and extract the contents. 
The contents of the file contains an example directory and a sas directory. 
The example directory contains example projects that you can run to explore the features of Project Change Manager. 
The sas directory contains the source code of Project Change Manager.

    > ![image](/README/images/02_01_SnapshotLog.png)

### Using the Success Example Project

You can start familiarizing yourself with the Project Change Manager by reviewing the example project called *success*.

#### Review the Example Project

1.  Navigate to the success directory. 

    **Note:** The success directory contains a README.txt file which contains a brief summary of the example's contents. 

The changelog for the success example project can be found in *success/Snapshot/SnapshotLog.xml*.

> ![image](/README/images/02_DirectoryContents.png)

The xml namespace (**xmlns**) must match what Project Change Manager expects. 
The **logicalFilePath** is an arbitrary string that uniquely identifies a changelog. 
Its value will be recorded in the databasechangelog with each associated changeset. 
The **schemaVersion** defines which version of the schema the changlog is using.


The **include** tags define the locations of the changesets relative to the changelog. 
Note that one of the changesets force any autoexec program not to run. 
You may view the contents of the changesets in the example which contain a PUT statement. 

#### Run the *Example Project*

2.  Navigate to the *bin* directory and open *pcm.sh* for editing. 
You may need to modify the environment variables to match them to your environment.


    > ![image](/README/images/03_shellscript.png)

**PCM\_ROOT**, **PCM\_LOG\_ROOT**, **PCM\_CHANGESET\_AUTOEXEC**, and **PCM\_INSTALLS\_LOC** are defined relative to Project Change Manager's location and should not be modified. 

Update **PCM\_SAS\_HOME** to the path of [SASHome](https://go.documentation.sas.com/?docsetId=hostunx&docsetTarget=p0u0ajlfxnn4myn17shsse44b2r2.htm&docsetVersion=9.4&locale=en).
Update **PCM\_SAS\_VERSION** to your SAS version, although 9.4 is the only supported version of SAS.

3.  Run the changes for this example by executing *pcm.sh* from the bin directory. 
    
**Note:** You may have to grant execute permissions for your user. 
If running on Windows a comparable batch script will need to be created.

> ![image](/README/images/04_execute_success.png)

This example shell script will only report errors and warnings. 
If there are no message, then the example ran successfully.

#### Investigating the Logs

The following example displays that logs are written to the log
directory within the success example. 
The location is defined in the *pcm.sh* shell script using the environment variable **PCM\_LOG\_ROOT**.
Once successfully executed, four log files are displayed. 
Each file name is prefixed with an [ISO 8601 formatted](https://go.documentation.sas.com/?docsetId=leforinforref&docsetTarget=n1vfxvbhrvzahjn1iciq1vruyc9d.htm&docsetVersion=9.4&locale=en) datetime stamp of when the corresponding program completed.

-   The log file for the main pcm program is *\<datetime\>\_pcm.log*.

-   The remaining logs are for changesets which are defined in the     changelog. 
The contents of the changeset log files, for this example, are simple PUT statement outputs. 
Review the *\<datetime\>\_pcm.log* which displays more interesting contents.

    > ![image](/README/images/05_log_directory.png)

4.  Open the log file and search for the string "NOTE:(PrjChngMgr)".
    This is the key term that helps differentiate Project Change Manager
    log output from other standard SAS output.

    > ![image](/README/images/06_pcm_log.png)


By examining these log messages, you can see what Project Change Manager is doing. 
In this example, it first creates the *databasechangelog* and *databasechangeloglock* data sets. 
It then reads the changelog and executes each changeset. 
The changesets are executed in a separate process and their log contents are each output to a separate log. 
You can see a message indicating that a changeset is about to be executed, and another message when a changeset has completed.

> ![image](/README/images/07_pcm_log_messages.png)

After running each changeset, the Project Change Manager tool inserts a record into the databasechangelog to indicate that the changeset was executed successfully.

#### Investigating the databasechangelog

In this example, the databasechangelog data sets are written to the installs directory within the success example. 
This location is defined in the *pcm.sh* shell script using the environment variable **PCM\_INSTALLS\_LOC**. 
Three entries are created in the databasechangelog once the shell script executes successfully.

> ![image](/README/images/09_databasechangelog.png)

Each changeset has a record, with the changeset defined by the *changeset* variable. 
The *logical\_changelog* is defined by the changelog that contains the changesets, and so is the same for all three records. 
The *status* will indicate the status of the changeset. 
In this case, each changeset was EXECUTED successfully. 
The *MD5Sum* is a checksum derived from the contents of the changeset. 
If the changeset was modified and executed again, the Project Change Manager tool detects the change and log an error.

### Other examples

#### Conditional\_autoexec

The **PCM\_CHANGESET\_AUTOEXEC** environment variable enables you to define an autoexec that runs before each changeset. 
However, you can optionally define a changeset to skip the autoexec. 
The conditional\_autoexec example highlights that feature.

#### Failed

This example illustrates a result when a changeset has an error.

#### Md5\_changed

This example contains preloaded records in the databasechangelog for a changeset. 
However, MD5Sum is different.

#### Resolved\_failure\_using\_autoexec

This example contains two shell scripts which does the following:

-   The first shell script defines an autoexec.

-   The second shell script executes without an autoexec and results in one of the changesets failing. 
When this script runs again, it uses the autoexec from the first shell script thus resulting in the changeset in executing successfully.

#### Success_with_warnings_due_to_whitelist

The Project Change Manager tool will fail in execution if there are warnings in a changeset. 
This example illustrates the common warnings that are exempt.

#### Warnings\_fail

This example highlights a changelog which will fail if any of the changesets contains a warning.

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

* **insert** - Used to add Project Change Manager macros to the SASAUTOS system option, for example, `-insert SASAUTOS $PCM_ROOT/sas`.

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

When a changeset is executed Project Change Manager will pass it a global macrovariable _g\_pcm\_root_, which can then be used in the changeset. This is the root location of Project Change Manager as defined by the **PCM\_ROOT** environment variable.

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
