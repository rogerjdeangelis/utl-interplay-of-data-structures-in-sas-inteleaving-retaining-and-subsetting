/* Interplay of data structures: building the MASTER and TRANS inputs.          */
/* Character-string date variant, from rogerjdeangelis'                         */
/* utl-interplay-of-data-structures-in-sas-inteleaving-retaining-and-subsetting  */
/*                                                                              */
/* MASTER holds three non-overlapping [STARTDATE, ENDDATE] ranges keyed by CODE, */
/* read with a $11. character informat. TRANS holds four transaction dates read  */
/* with a $11. informat and the @@ double-trailing line-hold so several dates    */
/* on one line stream into successive observations. These are the exact input    */
/* tables the writeup documents (MASTER obs=3, TRANS obs=4).                     */

options validvarname=upcase;

data master;
   input code$ startdate $11.
         enddate $11.;
cards4;
a 2024-07-01 2024-08-03
b 2024-08-06 2024-08-10
c 2024-08-11 2024-08-31
;;;;
run;quit;

data trans;
  input date : $11. @@  ;
cards4;
2024-07-03
2024-08-04
2024-08-10
2024-08-11
;;;;
run;quit;

proc print data=master;
  title "MASTER - non-overlapping date ranges by CODE";
run;

proc print data=trans;
  title "TRANS - transaction dates";
run;
