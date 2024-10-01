%let pgm=utl-interplay-of-data-structures-in-sas-inteleaving-retaining-and-subsetting;

Interplay of data structures in sas inteleaving retaining and subsetting


https://tinyurl.com/ykkk4j9a
https://github.com/rogerjdeangelis/utl-interplay-of-data-structures-in-sas-inteleaving-retaining-and-subsetting

MARKS POST ON END

    1 my lame attempt

    2 Marks post
      for a better explanation see
      Mixing Time Series of Differing Frequencies
      https://www.basug.org/archives

Mark, I hope I got this right?

It is omportant to understand some key points in Marks post.
These points have many useful properties.

Keintz, Mark
mkeintz@outlook.com

SOAPBOX ON

I think the behavior below comes from IBM sort merge modules?
These modules were the bread and butter of SAS in the early
IBM mainframe days?

SOAPBOX OFF

/*               _     _
 _ __  _ __ ___ | |__ | | ___ _ __ ___
| `_ \| `__/ _ \| `_ \| |/ _ \ `_ ` _ \
| |_) | | | (_) | |_) | |  __/ | | | | |
| .__/|_|  \___/|_.__/|_|\___|_| |_| |_|
|_|
*/

/**************************************************************************************************************************/
/*                                    |                                          |                                       */
/* INPUTS (all columns are character) |             PROCESS                      |            OUTPUT                     */
/* ================================== |             =======                      |            ======                     */
/*                                    |                                          |                                       */
/*                                    | Qithout looping,                         |                                       */
/* TRANS total obs=4                  | iterate through four dates in trans      |    DATE    CODE STARTDATE   ENDDATE   */
/*                                    | and test if trans date is between        |                                       */
/*     DATE                           | startdate and end date                   | 2024-07-03  a   2024-07-01 2024-08-03 */
/*                                    |                                          | 2024-08-04                            */
/*  2024-07-03                        |  TRANS                                   | 2024-08-10  b   2024-08-06 2024-08-10 */
/*  2024-08-04                        |    DATE   CODE  STARTDATE    ENDDATE     | 2024-08-11  c   2024-08-11 2024-08-31 */
/*  2024-08-10                        |                                          |                                       */
/*  2024-08-11                        | 2024-07-03   a  2024-07-01  2024-08-03   |                                       */
/*                                    |                                          |                                       */
/*                                    | 2024-08-04                               |                                       */
/* MASTER total obs=3                 |                                          |                                       */
/*                                    | 2024-08-10   b  2024-08-06  2024-08-10   |                                       */
/*  CODE    STARTDATE      ENDDATE    | 2024-08-11   c  2024-08-11  2024-08-31   |                                       */
/*                                    |                                          |                                       */
/*   a      2024-07-01    2024-08-03  |                                          |                                       */
/*   b      2024-08-06    2024-08-10  |                                          |                                       */
/*   c      2024-08-11    2024-08-31  |                                          |                                       */
/*                                    |                                          |                                       */
/*-----------------------------------------------------------------------------------------------------------------------*/
/*                                    |                                          |                                       */
/*                                    |  EXPLANATION BELOW (MARKS SOLUTION)      |                                       */
/*                                    |  ===================================     |                                       */
/*                                    |                                          |                                       */
/* options validvarname=upcase;       | data want (drop=_:);                     |                                       */
/* libname sd1 "d:/sd1";              |                                          |                                       */
/*                                    |   set master (                           |                                       */
/* data sd1.master;                   |       keep=startdate                     |                                       */
/*    input code$ startdate $11.      |       rename=startdate=_sortdate in=inm) |                                       */
/*          enddate $11.;             |     trans  (                             |                                       */
/* cards4;                            |       keep=date                          |                                       */
/* a 2024-07-01 2024-08-03            |       rename=date=_sortdate in=int) ;    |                                       */
/* b 2024-08-06 2024-08-10            |   by _sortdate;                          |                                       */
/* c 2024-08-11 2024-08-31            |                                          |                                       */
/* ;;;;                               |   if inm then set master;                |                                       */
/* run;quit;                          |   if int;                                |                                       */
/*                                    |                                          |                                       */
/* data sd1.trans;                    |   if _sortdate>enddate                   |                                       */
/*   input date : $11. @@  ;          |         then call missing(of _all_);     |                                       */
/* cards4;                            |                                          |                                       */
/* 2024-07-03                         |   set trans;                             |                                       */
/* 2024-08-04                         |                                          |                                       */
/* 2024-08-10                         | run;                                     |                                       */
/* 2024-08-11                         |                                          |                                       */
/* ;;;;                               |
/* run;quit;                                                                     |                                           |                                       */
/**************************************************************************************************************************/

/*                     _                             _   _                       _
/ |  _ __ ___  _   _  | | __ _ _ __ ___   ___   __ _| |_| |_ ___ _ __ ___  _ __ | |_
| | | `_ ` _ \| | | | | |/ _` | `_ ` _ \ / _ \ / _` | __| __/ _ \ `_ ` _ \| `_ \| __|
| | | | | | | | |_| | | | (_| | | | | | |  __/| (_| | |_| ||  __/ | | | | | |_) | |_
|_| |_| |_| |_|\__, | |_|\__,_|_| |_| |_|\___| \__,_|\__|\__\___|_| |_| |_| .__/ \__|
               |___/                                                      |_|
 _                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

options validvarname=upcase;
libname sd1 "d:/sd1";

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

/**************************************************************************************************************************/
/*                                    |                                          |                                       */
/* TRANS total obs=4                  | Iterate through four dates in trans      |    DATE    CODE STARTDATE   ENDDATE   */
/*                                    | and test if trans date is between        |                                       */
/*     DATE                           | startdate and end date                   | 2024-07-03  a   2024-07-01 2024-08-03 */
/*                                    |                                          | 2024-08-04                            */
/*  2024-07-03                        |  TRANS                                   | 2024-08-10  b   2024-08-06 2024-08-10 */
/*  2024-08-04                        |    DATE   CODE  STARTDATE    ENDDATE     | 2024-08-11  c   2024-08-11 2024-08-31 */
/*  2024-08-10                        |                                          |                                       */
/*  2024-08-11                        | 2024-07-03   a  2024-07-01  2024-08-03   |                                       */
/*                                    |                                          |                                       */
/*                                    | 2024-08-04                               |                                       */
/* MASTER total obs=3                 |                                          |                                       */
/*                                    | 2024-08-10   b  2024-08-06  2024-08-10   |                                       */
/*  CODE    STARTDATE      ENDDATE    | 2024-08-11   c  2024-08-11  2024-08-31   |                                       */
/*                                    |                                          |                                       */
/*   a      2024-07-01    2024-08-03  |                                          |                                       */
/*   b      2024-08-06    2024-08-10  |                                          |                                       */
/*   c      2024-08-11    2024-08-31  |                                          |                                       */
/*                                    |                                          |                                       */
/**************************************************************************************************************************/

/*
 _                _                                   _
| |__   __ _  ___| | ____ _ _ __ ___  _   _ _ __   __| |
| `_ \ / _` |/ __| |/ / _` | `__/ _ \| | | | `_ \ / _` |
| |_) | (_| | (__|   < (_| | | | (_) | |_| | | | | (_| |
|_.__/ \__,_|\___|_|\_\__, |_|  \___/ \__,_|_| |_|\__,_|
                      |___/
*/

Data Step Operations Explanation

1. Initial Setup
   - The initial interleaved set operations determine
     the seven iterations the data step will take.
   - This sets the foundation for how the data will be processed.

2. Date Comparisons
   - Subsetting by 'inmaster' or 'intrans' allows
     date comparisons in the correct order.
   - Because the data is ordered, you only need to test if the
     transaction date is greater than the master date.

3. Subsequent Set Operations
   - These operations will retain the dates in the master table for comparison.
   - They will not update the record counter (_n_).
   - However, they do retain key values.

4. Important Notes
   - The data is processed in a specific order to ensure accurate comparisons.
   -  The record counter (_n_) is not updated after the initial set operations.

5. Technical Detail
   There is an _n_=8 that appears after the 7th iteration is completed and before
   the interleaved set, immediately after the data statement. This doesn't affect
   the results and may be SAS's way of ending the data step before an eighth iteration.

6. The seven interations that update _n_

   data want  ;
     set master (keep=startdate rename=startdate=_sortdate  in=inmaster)
         trans  (keep=date      rename=date=_sortdate       in=intrans) ;
     by _sortdate ;
     inmaster = inm;
     intrans  = int;
   run;quit;

   DATA IS INTERLEAVED AND ORDERED BY TRANS DATE and MASTER STARTDATE

    _SORTDATE    INMASTER    INTRANS

    01JUL2024        1          0
    03JUL2024        0          1
    04AUG2024        0          1
    06AUG2024        1          0
    10AUG2024        0          1
    11AUG2024        1          0
    11AUG2024        0          1

/*       _                 _   _
(_)_ __ | |_ ___ _ __ __ _| |_(_) ___  _ __  ___
| | `_ \| __/ _ \ `__/ _` | __| |/ _ \| `_ \/ __|
| | | | | ||  __/ | | (_| | |_| | (_) | | | \__ \
|_|_| |_|\__\___|_|  \__,_|\__|_|\___/|_| |_|___/

*/

FIST OF SEVEN ITERATIONS (NO OUTPUT)
=====================================

  set master (keep=startdate rename=startdate=_sortdate  in=inmaster)
      trans  (keep=date rename=date=_sortdate in=intrans) ;
  by _sortdate;
  if inm then set master;
  if int;

  EXPLANTION (NO OUTPUT)

  inmaster=1 intrans=0

  if inmaster then set master(in=inmaster)  (first master date preceeds all dates)
  therfore inmaster=1 and intrans=0.
  if intrans ; (if 0 is never true) stops the datastep without any output

  Master variables retained ie code startdate and enddate


SECOND OBSERVATION (FIRST OUTPUT)
=================================

  inmaster=0 intrans=1 (transdate in _sortdate - master date retained)

  set master (keep=startdate rename=startdate=_sortdate  in=inmaster)
      trans  (keep=date rename=date=_sortdate in=intrans) ;
  by _sortdate;
  if inmaster then set master; set not performed inmaster=0
  if int;                      in=1 so we continue
  because int=1 we have the trans date in _sortdate.
  Since code , startdate and enddate are

                                 RETAINED
                      ============================================
  _SORTDATE=03JUL2024 CODE=a STARTDATE=01JUL2024 ENDDATE=03AUG2024
  if _sortdate>enddate then call missing(of _all_);

  _sortdate is less than enddate so we output the record

  set trans;   get trans date
               this does not bump up _n_


THIRD OBSERVATION (SECOND OUTPUT)
=================================

  inmaster=0 intrans=1

  set master (keep=startdate rename=startdate=_sortdate  in=inm)
      trans  (keep=date rename=date=_sortdate in=int) ;
  by _sortdate;
  if inm then set master;   set not performed inmsater=0
  if int;                   intrans=1 so we continue
  because intrans=1 we have the trans date in _sortdate

                                            RETAINED
                      ============================================

  _SORTDATE=04AUG2024 CODE=a DATE=03JUL2024 STARTDATE=01JUL2024 ENDDATE=03AUG2024
  if _sortdate>enddate then call missing(of _all_);  this is true so we set missings

  NOTE THE DATE IS WRONG
 _SORTDATE=  CODE=  STARTDATE=  ENDDATE=  DATE=2024-07-03

  set trans;  get the correct date. only date is populated

 _SORTDATE=  CODE=  STARTDATE=  ENDDATE=  DATE=2024-08-04  _N_=3

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|

*/

/* elegant and not much code */

data want (drop=_:);

  set master (
      keep=startdate
      rename=startdate=_sortdate in=inm)
    trans  (
      keep=date
      rename=date=_sortdate in=int) ;
  by _sortdate;

  if inm then set master;
  if int;

  if _sortdate>enddate
        then call missing(of _all_);
  set trans;

run;

/**************************************************************************************************************************/
/*                                                                                                                        */
/* WORK.WANT total obs=4 01OCT2024:09:30:36                                                                               */
/*                                                                                                                        */
/* Obs    CODE    STARTDATE      ENDDATE         DATE                                                                     */
/*                                                                                                                        */
/*  1      a      2024-07-01    2024-08-03    2024-07-03                                                                  */
/*  2                                         2024-08-04                                                                  */
/*  3      b      2024-08-06    2024-08-10    2024-08-10                                                                  */
/*  4      c      2024-08-11    2024-08-31    2024-08-11                                                                  */
/*                                                                                                                        */
/*                                                                                                                        */
/* _N_ IS THE INTERATION THAT LEEADS TO OUTPUT RECORDS                                                                    */
/*                                                                                                                        */
/*    DATE       _N_   MASTER     TRANS       CODE    STARTDATE    ENDDATE                                                */
/*                                                                                                                        */
/*  024-07-03     2       1          0         a      2024-07-01  2024-08-03                                              */
/*  024-08-04     3       0          1                                                                                    */
/*  024-08-10     5       1          0         b      2024-08-06  2024-08-10                                              */
/*  024-08-11     7       1          0         c      2024-08-11  2024-08-31                                              */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*___    __  __            _                          _
|___ \  |  \/  | __ _ _ __| | _____   _ __   ___  ___| |_
  __) | | |\/| |/ _` | `__| |/ / __| | `_ \ / _ \/ __| __|
 / __/  | |  | | (_| | |  |   <\__ \ | |_) | (_) \__ \ |_
|_____| |_|  |_|\__,_|_|  |_|\_\___/ | .__/ \___/|___/\__|
                                     |_|
*/


In the case of SAS, this is too much coding in the DATA step solution.
As you imply, it really requires no use of arrays or loops.  And I think
it is often more informative to use each language in its most effective way,
rather than create parallel code scripts using loops when they are not needed.

Assuming the STARTDATE/ENDDATE ranges in MASTER do not overlap,
then sort MASTER by startdate, and TRANS by date.
Then it is a case of using conditional SET statements:

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



data want (drop=_:);
  set master (keep=startdate rename=startdate=_sortdate  in=inm)
      trans  (keep=date rename=date=_sortdate in=int) ;
  by _sortdate;
  if inm then set master;
  if int;
  if _sortdate>enddate then call missing(of _all_);
  set trans;
run;


The benefit of the conditional SET  (as in IF INM then set master) is that the variables from master
(code,startdate,enddate) are retained until the next occurrence of INM=1.
So whenever a subsequent TRANS is encountered, it will inherent the preceding MASTER variables.
Just be sure to call missing (of _ALL_)  if DATE from TRANS (renamed to SORTDATE)
comes after ENDDATE from the preceding MASTER.



I have a much fuller explanation of this in a BASUG presentation I gave in MAY
See “History Carried Forward, Future Carried Back: Mixing Time Series of
Differing Frequencies “ in https://www.basug.org/archives.

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
