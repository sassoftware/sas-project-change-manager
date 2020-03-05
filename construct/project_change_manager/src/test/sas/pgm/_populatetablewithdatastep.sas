/**
   \file
   \ingroup    BRUNIT 

   \brief      Write to a predefined table, maintaining the variable attributes.

               This will overwrite the table, not append.  However any lengths, labels, formats,
               etc., will be maintained, and will not need to be redefined in the data step.

   \param   i_numericColumnName     the name of any numeric column, needed to create an empty data row
   \param   i_dataStatement    		the data statement with the table output.
   									It must conform to the expected format of:
   									DATA <libname>.<tablename>;
   										<variable1_observation1>=<value1_1>;
   										<variable2_observation1>=<value2_1>;
   										output;
   										<variable1_observation2>=<value1_2>;
   										<variable2_observation2>=<value2_2>;
   										output;
   										...
   									run;
   \param   i_characterColumnName   (Optional) the name of any character column, needed to create an empty data row
   										
   
*/ /** \cond */ 

%MACRO _populatetablewithdatastep(i_numericColumnName, i_dataStatement, i_characterColumnName=%str());

/* 1 - PARSE THE DATA STATEMENT */
/* Get the first line (except for the semicolon */
%let l_firstLine=%qscan(&i_dataStatement,1,';');
/* Get all the lines after the first line */
%let l_nonFirstLines=%substr(&i_dataStatement,%length(&l_firstLine)+2);
/* Get the library and table name */
%let l_library=%qscan(&i_dataStatement,2);
%let l_tableName=%qscan(&i_dataStatement,3);


/* 2 - CREATE THE TABLE */
/* Write sql statement to create an empty table that inherits all of the attributes of the base table. */
proc sql noprint;
	create table WORK.tempTable like &l_library..&l_tableName;	
	/*pick any numeric or string variable to insert an empty row into the table*/	
	%IF (&i_numericColumnName ne ) %THEN %DO;
		insert into WORK.tempTable set &i_numericColumnName.=.;
	%END;
	%ELSE %IF (&i_characterColumnName ne ) %THEN %DO;
		insert into WORK.tempTable set &i_characterColumnName.="";
	%END;
quit;

/* Write data step, inserting empty observation */
&l_firstLine;
	/*Use the empty row, so that column attributes are maintained*/                                                                                                                                                                                                          
	set WORK.tempTable;
	
/* Now define the actual data.*/
/* Since the empty row is not yet output, it will effectively be overwritten by the first observation.*/
&l_nonFirstLines /*no semicolon - the macrovariable has one */

/* Delete the temporary table */
proc datasets library=WORK nolist;
	delete tempTable;
run;

%mend;