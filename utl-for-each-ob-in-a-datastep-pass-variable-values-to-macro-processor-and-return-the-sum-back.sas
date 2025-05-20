%let pgm=utl-for-each-ob-in-a-datastep-pass-variable-values-to-macro-processor-and-return-the-sum-back;

%stop_submission;

For each ob in a datastep pass variable values to the macro processor and return the sum back

dosubl replaces macros. I know it os slow.

I could not get any of the posted solutions to work. Probably my bad?

         Two spultions

            1 macro vars to & from dosubl
              dosubl and %dosubl are much more powerfull than macros? (although slower)
            2 environment variable to and from dosubl
            3 posted solution
            4 related repos

github
https://tinyurl.com/5x6v6jbn
https://github.com/rogerjdeangelis/utl-for-each-ob-in-a-datastep-pass-variable-values-to-macro-processor-and-return-the-sum-back

https://github.com/rogerjdeangelis/utl-twelve-interfaces-for-dosubl

actually 13
https://communities.sas.com/t5/SAS-Programming/How-to-call-macro-within-dataset/m-p/809415#M319200

/**************************************************************************************************************************/
/*     INPUT          |             PROCESS                       |     OUTTPUT                                           */
/*     =====          |             =======                       |     ======                                            */
/*                    |                                           |                                                       */
/*  WORK.HAVE obs=9   | 1 MACRO VARS TO AND FROM DOSUBL           | WORK.WANT total obs=9                                 */
/*                    |   see below to clear macros after a run   |                       sum                             */
/*  Obs inc dec       |   =====================================   |                                                       */
/*                    |                                           | INC    DEC    rc    IncDec                            */
/*   1   1   9        | data want ;                               |                                                       */
/*   2   2   8        |                                           |  1      9      0      10                              */
/*   3   3   7        |  set have;                                |  2      8      0      10                              */
/*   4   4   6        |                                           |  3      7      0      10                              */
/*   5   5   5        |  call symputx('inc',inc);                 |  4      6      0      10                              */
/*   6   6   4        |  call symputx('dec',dec);                 |  5      5      0      10                              */
/*   7   7   3        |                                           |  6      4      0      10                              */
/*   8   8   2        |  rc=dosubl('                              |  7      3      0      10                              */
/*   9   9   1        |    %let tot = %sysevalf(&inc + &dec);     |  8      2      0      10                              */
/*                    |    ');                                    |  9      1      0      10                              */
/*  data have ;       |   sumIncDec = symgetn('TOT');             |                                                       */
/*  input inc dec;    |                                           |                                                       */
/*  cards4;           | run;quit;                                 |                                                       */
/*  1 9               |                                           |                                                       */
/*  2 8               |---------------------------------------------------------------------------------------------------*/
/*  3 7               | 2 ENVIROMENT VARIABLE TO & FROM DOSUBL    | WORK.WANT total obs=9                                 */
/*  4 6               | ======================================    |                       sum                             */
/*  5 5               |                                           | INC    DEC    rc    IncDec                            */
/*  6 4               | data want;                                |                                                       */
/*  7 3               |                                           |  1      9      0      10                              */
/*  8 2               |  set have;                                |  2      8      0      10                              */
/*  9 1               |                                           |  3      7      0      10                              */
/*  ;;;;              |  call symputx('inc',inc);                 |  4      6      0      10                              */
/*  run;quit;         |  call symputx('dec',dec);                 |  5      5      0      10                              */
/*                    |                                           |  6      4      0      10                              */
/*                    |  rc=dosubl('                              |  7      3      0      10                              */
/*                    |    %let tot = %sysevalf(&inc + &dec);     |  8      2      0      10                              */
/*                    |    options set=SCRATCHAREA=&tot;          |  9      1      0      10                              */
/*                    |   ');                                     |                                                       */
/*                    |                                           |                                                       */
/*                    |   sumIncDec =                             |                                                       */
/*                    |      input(sysget('SCRATCHAREA'),best.);  |                                                       */
/*                    |                                           |                                                       */
/*                    | run;quit;                                 |                                                       */
/*                    |                                           |                                                       */
/*                    |---------------------------------------------------------------------------------------------------*/
/*                    | 3 POSTED AND ACCEPTED SOLUTION            |                                                       */
/*                    | ==============================            |                                                       */
/*                    |                                           |                                                       */
/*                    | %global ReturnVar;                        |                                                       */
/*                    | %macro macro2call                         |                                                       */
/*                    |  (ind, indst, indend, sign);              |                                                       */
/*                    |                                           |                                                       */
/*                    |      %eval(&indst.+&indend.);             |                                                       */
/*                    | &ReturnVar                                |                                                       */
/*                    | %mend;                                    |                                                       */
/*                    |                                           |                                                       */
/*                    | data ds_para;                             |                                                       */
/*                    | set  ds_para;                             |                                                       */
/*                    | call execute(                             |                                                       */
/*                    |  %macro2call(indst,indend));              |                                                       */
/*                    | mmind=&ReturnVar.;                        |                                                       */
/*                    | run;quit;                                 |                                                       */
/**************************************************************************************************************************/

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have ;
input inc dec;
cards4;
1 9
2 8
3 7
4 6
5 5
6 4
7 3
8 2
9 1
;;;;
run;quit;

/**************************************************************************************************************************/
/*  WORK.HAVE obs=9                                                                                                       */
/*                                                                                                                        */
/*  Obs inc dec                                                                                                           */
/*                                                                                                                        */
/*   1   1   9                                                                                                            */
/*   2   2   8                                                                                                            */
/*   3   3   7                                                                                                            */
/*   4   4   6                                                                                                            */
/*   5   5   5                                                                                                            */
/*   6   6   4                                                                                                            */
/*   7   7   3                                                                                                            */
/*   8   8   2                                                                                                            */
/*   9   9   1                                                                                                            */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                                                          _           ___      __                           _                 _     _
/ |  _ __ ___   __ _  ___ _ __ ___   __   ____ _ _ __ ___  | |_ ___    ( _ )    / _|_ __ ___  _ __ ___     __| | ___  ___ _   _| |__ | |
| | | `_ ` _ \ / _` |/ __| `__/ _ \  \ \ / / _` | `__/ __| | __/ _ \   / _ \/\ | |_| `__/ _ \| `_ ` _ \   / _` |/ _ \/ __| | | | `_ \| |
| | | | | | | | (_| | (__| | | (_) |  \ V / (_| | |  \__ \ | || (_) | | (_>  < |  _| | | (_) | | | | | | | (_| | (_) \__ \ |_| | |_) | |
|_| |_| |_| |_|\__,_|\___|_|  \___/    \_/ \__,_|_|  |___/  \__\___/   \___/\/ |_| |_|  \___/|_| |_| |_|  \__,_|\___/|___/\__,_|_.__/|_|

*/

/*---- clean enviroment ----*/

proc datasets lib=work
 nolist nodetails ;
 delete sasmac1 sasmac2 sasmac3 /  mt=cat;
 delete want;
run;quit;

%symdel inc dec tot/ nowarn;

data want ;

 set have;

 call symputx('inc',inc);
 call symputx('dec',dec);

 rc=dosubl('
   %let tot = %sysevalf(&inc + &dec);
   ');
  sumIncDec = symgetn('TOT');

run;quit;


/**************************************************************************************************************************/
/*  WORK.WANT total obs=9                                                                                                 */
/*                         sum                                                                                            */
/*   inc    dec    rc    IncDec                                                                                           */
/*                                                                                                                        */
/*    1      9      0      10                                                                                             */
/*    2      8      0      10                                                                                             */
/*    3      7      0      10                                                                                             */
/*    4      6      0      10                                                                                             */
/*    5      5      0      10                                                                                             */
/*    6      4      0      10                                                                                             */
/*    7      3      0      10                                                                                             */
/*    8      2      0      10                                                                                             */
/*    9      1      0      10                                                                                             */
/**************************************************************************************************************************/

/*___                    _                                      _                    _       _     _
|___ \    ___ _ ____   _(_)_ __ ___  _ __  _ __ ___   ___ _ __ | |_ __   ____ _ _ __(_) __ _| |__ | | ___
  __) |  / _ \ `_ \ \ / / | `__/ _ \| `_ \| `_ ` _ \ / _ \ `_ \| __|\ \ / / _` | `__| |/ _` | `_ \| |/ _ \
 / __/  |  __/ | | \ V /| | | | (_) | | | | | | | | |  __/ | | | |_  \ V / (_| | |  | | (_| | |_) | |  __/
|_____|  \___|_| |_|\_/ |_|_|  \___/|_| |_|_| |_| |_|\___|_| |_|\__|  \_/ \__,_|_|  |_|\__,_|_.__/|_|\___|
*/


*---- CLEAN ENVIONMENT?    ----*;

options validvarname=v7;

proc datasets lib=work
 nolist nodetails;
 delete sasmac1 sasmac2 sasmac3 /mt=cat;
 delete want;
run;quit;

%symdel inc dec tot/ nowarn;

options set=SCRATCHAREA=0;
%symdel indst indend tot/ nowarn;
*---- check ----*;
%put SCRATCHAREA = %sysget(SCRATCHAREA)
*---- SCRATCHAREA = 0 ----*;

data want;

 set have;

 call symputx('inc',inc);
 call symputx('dec',dec);

 rc=dosubl('
   %let tot = %sysevalf(&inc + &dec);
   options set=SCRATCHAREA=&tot;
  ');

  sumIncDec =
     input(sysget('SCRATCHAREA'),best.);

run;quit;


/**************************************************************************************************************************/
/*  WORK.WANT total obs=9                                                                                                 */
/*                         sum                                                                                            */
/*   inc    dec    rc    IncDec                                                                                           */
/*                                                                                                                        */
/*    1      9      0      10                                                                                             */
/*    2      8      0      10                                                                                             */
/*    3      7      0      10                                                                                             */
/*    4      6      0      10                                                                                             */
/*    5      5      0      10                                                                                             */
/*    6      4      0      10                                                                                             */
/*    7      3      0      10                                                                                             */
/*    8      2      0      10                                                                                             */
/*    9      1      0      10                                                                                             */
/**************************************************************************************************************************/

/*  _              _       _           _
| || |    _ __ ___| | __ _| |_ ___  __| |  _ __ ___ _ __   ___  ___
| || |_  | `__/ _ \ |/ _` | __/ _ \/ _` | | `__/ _ \ `_ \ / _ \/ __|
|__   _| | | |  __/ | (_| | ||  __/ (_| | | | |  __/ |_) | (_) \__ \
   |_|   |_|  \___|_|\__,_|\__\___|\__,_| |_|  \___| .__/ \___/|___/
                                                   |_|
*/

REPO
-------------------------------------------------------------------------------------------------------------------------------------------
https://github.com/rogerjdeangelis/utl_passing-in-memory-sas-objects-to-and-from-dosubl
https://github.com/rogerjdeangelis/utl_sharing_a_block_of_memory_with_dosubl
https://github.com/rogerjdeangelis/utl-sharing-a-common-block-of-memory-with-dosubl-using-sas-peek-and-poke

https://github.com/rogerjdeangelis/-utl-delete-dosubl-created-sas-macro-libraries
https://github.com/rogerjdeangelis/Dynamic_variable_in_a_DOSUBL_execute_macro_in_SAS
https://github.com/rogerjdeangelis/utl-DOSUBL-running-sql-inside-a-datastep-to-check-if-variables-exist-in-another-table
https://github.com/rogerjdeangelis/utl-Interesting-property-of-sas-dosubl
https://github.com/rogerjdeangelis/utl-No-need-to-convert-your-datastep-code-to-macro-code-use-DOSUBL
https://github.com/rogerjdeangelis/utl-a-better-call-execute-using-dosubl
https://github.com/rogerjdeangelis/utl-academic-pipes-dosubl-open-defer-and-dropping-dowm-to-multiple-languages-in-one-datastep
https://github.com/rogerjdeangelis/utl-adding-female-students-to-an-all-male-math-class-using-sql-insert_and_dosubl
https://github.com/rogerjdeangelis/utl-adding-summary-statistics-to-your-datastep-input-table-macro-dosubl
https://github.com/rogerjdeangelis/utl-append-and-split-tables-into-two-tables-one-with-common-variables-and-one-without-dosubl-hash
https://github.com/rogerjdeangelis/utl-applying-meta-data-and-dosubl-to-create-mutiple-subset-tables
https://github.com/rogerjdeangelis/utl-cleaner-macro-code-using-dosubl
https://github.com/rogerjdeangelis/utl-create-mutiple-pdf-files-from-one-table-dosubl-ods-newfile-option
https://github.com/rogerjdeangelis/utl-dosubl-a-more-powerfull-macro-sysfunc-command
https://github.com/rogerjdeangelis/utl-dosubl-and-do-over-as-alternatives-to-explicit-macros
https://github.com/rogerjdeangelis/utl-dosubl-more-precise-eight-byte-float-computations-at-macro-excecution-time
https://github.com/rogerjdeangelis/utl-dosubl-persistent-hash-across-datasteps-and-procedures
https://github.com/rogerjdeangelis/utl-dosubl-remove-text-within-parentheses-of-macro-variable-using-regex
https://github.com/rogerjdeangelis/utl-dosubl-using-meta-data-with-column-names-and-labels-to-create-mutiple-proc-reports
https://github.com/rogerjdeangelis/utl-drop-down-using-dosubl-from-sas-datastep-to-wps-r-perl-powershell-python-msr-vb
https://github.com/rogerjdeangelis/utl-embed-sql-code-inside-proc-report-using-dosubl
https://github.com/rogerjdeangelis/utl-embedding-dosubl-in-a-macro-and-returning-an-updated-environment-variable-contents
https://github.com/rogerjdeangelis/utl-error-checking-sql-and-executing-a-datastep-inside-sql-dosubl
https://github.com/rogerjdeangelis/utl-extracting-sas-meta-data-using-sas-macro-fcmp-and-dosubl
https://github.com/rogerjdeangelis/utl-get-dataset-attributes-at-macro-time-within-a-datastep-using-attrn-dosubl-macros
https://github.com/rogerjdeangelis/utl-given-six-monthly-of-columns-hgt-and-wgt-create-l-table-of-six-columns-of-hgt-minus-wgt-dosubl
https://github.com/rogerjdeangelis/utl-in-memory-hash-output-shared-with-dosubl-hash-subprocess
https://github.com/rogerjdeangelis/utl-let-dosubl-and-the-sas-interpreter-work-for-you
https://github.com/rogerjdeangelis/utl-load-configuation-variable-assignments-into-an-sas-array-macro-and-dosubl
https://github.com/rogerjdeangelis/utl-loop-through-one-table-and-find-data-in-next-table--hash-dosubl-arts-transpose
https://github.com/rogerjdeangelis/utl-macro-klingon-solution-or-simple-dosubl-you-decide
https://github.com/rogerjdeangelis/utl-macro-with-dosubl-to-compute-last-day-of-month
https://github.com/rogerjdeangelis/utl-maitainable-macro-function-code-using-dosubl
https://github.com/rogerjdeangelis/utl-passing-a-datastep-array-to-dosubl-squaring-the-elements-passing-array-back-to-parent
https://github.com/rogerjdeangelis/utl-potentially-useful-dosubl-interface
https://github.com/rogerjdeangelis/utl-proof-of-concept-using-dosubl-to-create-a-fcmp-like-function-for-a-rolling-sum-of-size-three
https://github.com/rogerjdeangelis/utl-re-ordering-variables-into-alphabetic-order-in-the-pdv-macros-dosubl
https://github.com/rogerjdeangelis/utl-rename-variables-with-the-same-prefix-dosubl-varlist
https://github.com/rogerjdeangelis/utl-running-dosubl-at-macro-time-inside-a-macro-and-returning-a-macro-variable-to-open-code
https://github.com/rogerjdeangelis/utl-sas-array-macro-fcmp-or-dosubl-take-your-choice
https://github.com/rogerjdeangelis/utl-select-high-payment-periods-and-generating-code-with-do_over-and-dosubl
https://github.com/rogerjdeangelis/utl-sharing-a-common-block-of-memory-with-dosubl-using-sas-peek-and-poke
https://github.com/rogerjdeangelis/utl-sharing-datastep-memory-with-dosubl-using-assembler-like-load-and-store-instructions
https://github.com/rogerjdeangelis/utl-some-interesting-applications-of-dosubl
https://github.com/rogerjdeangelis/utl-transpose-multiple-rows-into-one-row-do_over-dosubl-and-varlist-macros
https://github.com/rogerjdeangelis/utl-twelve-interfaces-for-dosubl
https://github.com/rogerjdeangelis/utl-use-dosubl-to-save-your-format-code-inside-proc-report
https://github.com/rogerjdeangelis/utl-using-dosubl-and-a-dynamic-arrays-to-add-new-variables
https://github.com/rogerjdeangelis/utl-using-dosubl-to-avoid-klingon-obsucated-macro-coding
https://github.com/rogerjdeangelis/utl-using-dosubl-to-avoid-macros-and-add-an-error-checking-log
https://github.com/rogerjdeangelis/utl-using-dosubl-to-exceute-r-for-each-row-in-a-dataset
https://github.com/rogerjdeangelis/utl-using-dosubl-with-data-driven-business-rules-to-split-a-table
https://github.com/rogerjdeangelis/utl-using-dynamic-tables-to-interface-with-dosubl
https://github.com/rogerjdeangelis/utl_avoiding_macros_and_call_execute_by_using_dosubl_with_log
https://github.com/rogerjdeangelis/utl_dosubl_do_regressions_when_data_is_between_dates
https://github.com/rogerjdeangelis/utl_dosubl_macros_to_select_max_value_of_a_column_at_datastep_execution_time
https://github.com/rogerjdeangelis/utl_dosubl_subroutine_interfaces
https://github.com/rogerjdeangelis/utl_dynamic_subroutines_dosubl_with_error_checking
https://github.com/rogerjdeangelis/utl_overcoming_serious_deficiencies_in_call_execute_with_dosubl
https://github.com/rogerjdeangelis/utl_pass_character_and_numeric_arrays_to_dosubl
https://github.com/rogerjdeangelis/utl_passing-in-memory-sas-objects-to-and-from-dosubl
https://github.com/rogerjdeangelis/utl_read_all_datasets_in_a_library_and_conditionally_split_them_with_error_checking_dosubl
https://github.com/rogerjdeangelis/utl_sharing_a_block_of_memory_with_dosubl
https://github.com/rogerjdeangelis/utl_using_dosubl_instead_of_a_macro_to_avoid_numeric_truncation
https://github.com/rogerjdeangelis/utl_using_dosubl_to_avoid_klingon_macro_quoting_functions
https://github.com/rogerjdeangelis/utl_why_proc_import_export_needs_to_be_deprecated_and_dosubl_acknowledged

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
