## How to Contribute

We'd love to accept your patches and contributions to this project. There are
just a few small guidelines you need to follow.

### Code conventions
Please follow the conventions in the existing code base to keep the code human readable and understandable.  This relates to things like commenting, indentation, and naming conventions.
The following are some (but by no means all) conventions:

* Indentation should be made with a tab 4 characters wide
* Indent all code nested in Data steps, macros, loops, if-statements, etc.
* Code comments should be inline with blocks of code
* Macrovariables should be preceeded by the scope
	* _l\__ for local macrovariables, _g\__ for global macrovariables
	* _i\__ for input macrovariables, _o\__ for output macrovariables
* Macrovariable names should use camelCase
* Data set variables should use under_score
* Temporary data set variables should use camelCase
* Make use of the _%putlog(...)_ macro for output to the log in order to maintain standard Project Change Manager log message formatting.  Do not use _put_ statements or _%put()_ functions whenever possible

### Unit test creation/update
* Contributions must add unit tests to /src/test/sas/testscenario to validate the changes being added in the code
* if there's already a test scenario where your tests would make sense; put them in there
* if it's something new or you feel it needs its own file, create a new scenario

#### Using SASUnit
1. Download [SASUnit](https://sourceforge.net/projects/sasunit/) v1.x from sourceforge
2. Extract SASUnit to `construct/project\_change\_manager/src/test/sasunit/` (this directory should contain `resources` and `saspgm` directories)
3. Run the unit tests using the _SASUnit\_run\_SASUnit.bat_ batch file in the BuildScripts, or by using the appropriate gradle tasks

