/* Interplay of data structures: building the MASTER and TRANS inputs.          */
/* Numeric-date variant (the "elegant" version), from rogerjdeangelis'          */
/* utl-interplay-of-data-structures-in-sas-inteleaving-retaining-and-subsetting  */
/*                                                                              */
/* Same two inputs as the character variant, but read as real SAS date values:  */
/* TRANS reads four dates from a single line with the :yymmdd10. informat and    */
/* the @@ line-hold, and MASTER reads CODE plus two :yymmdd10. dates. Both carry  */
/* a date9. format so the stored values print as 01JUL2024-style dates.          */

data trans;
  input date :yymmdd10. @@  ;
  format date date9.;
datalines;
2024-07-03   2024-08-04   2024-08-10   2024-08-11
run;

data master;
  input code :$1  startdate :yymmdd10. enddate :yymmdd10. ;
  format startdate enddate date9.;
datalines;
a 2024-07-01 2024-08-03
b 2024-08-06 2024-08-10
c 2024-08-11 2024-08-31
run;

proc print data=trans;
  title "TRANS - transaction dates as SAS date values";
run;

proc print data=master;
  title "MASTER - date ranges by CODE as SAS date values";
run;
