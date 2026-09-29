*******************************************************************************
* ECON 381: Stata Do-File Assignment - Answer Key
* Fall 2026
* Instructor: Prof. Ren
*
* Place this do-file and caschool.dta in the same working folder before running.
*******************************************************************************

version 18.0
clear all
set more off

* Task 1: Start the log and load the data
capture log close
log using "ECON381_Stata_Answer_Key.log", text replace
use "caschool.dta", clear

* Task 2: Summarize average test scores
summarize testscr

* Answer: Mean = 654.1565; standard deviation = 19.05335;
* minimum = 605.55; maximum = 706.75.

* Task 3: Classify districts by income (A simple approach)
summarize avginc, detail

* Task 3: Classify districts by income (A more advanced approach)
* Obtain the sample median and store it in a local macro.
quietly _pctile avginc, p(50)
local median_income = r(r1)
display "Median district income = " `median_income'

* Generate the indicator. Observations exactly at the median remain missing.
generate byte inc_indicator = .
replace inc_indicator = 1 if avginc > `median_income' & !missing(avginc)
replace inc_indicator = 0 if avginc < `median_income' & !missing(avginc)

* Label the variable as District income relative to sample median
label variable inc_indicator "District income relative to sample median"

tabulate inc_indicator, missing
count if avginc == `median_income' & !missing(avginc)

* Answer: The sample median of avginc is 13.7278 (thousand dollars).
* No district has avginc exactly equal to the sample median, so the number of
* observations left missing because income equals the median is 0.

* Task 4: Compare test scores across income groups
tabstat testscr, by(inc_indicator) statistics(mean n) columns(statistics)

* Answer: Mean testscr = 643.9639 for low-income districts and 664.3492 for
* high-income districts. High-income districts average about 20.3854 points
* higher than low-income districts.

* Task 5: Summarize districts in Los Angeles County
count if county == "Los Angeles"
summarize testscr avginc if county == "Los Angeles"

* Answer: There are 27 districts in Los Angeles County. For these districts,
* mean testscr = 645.5371 and mean avginc = 14.64412 (thousand dollars).

* Task 6: Graph test scores and income
twoway (scatter testscr avginc, mcolor(navy%55) msize(small))             ///
       (lfit testscr avginc, lcolor(maroon) lwidth(medthick)),           ///
       title("Average Test Scores and District Income")                 ///
       xtitle("Average district income (thousands of dollars)")         ///
       ytitle("Average test score")                                     ///
       legend(order(1 "Districts" 2 "Linear fitted line"))

graph export "ECON381_Stata_Answer_Key_Graph.pdf", as(pdf) replace

* Answer: The fitted line slopes upward. In this sample, districts with higher
* average income tend to have higher average test scores. This is a positive
* association and, by itself, does not establish a causal effect of income.

* Task 7: Finish the log
log close

*******************************************************************************
* End of do-file
*******************************************************************************
