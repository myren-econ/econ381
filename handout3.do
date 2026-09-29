* This is a comment.

// This is also a comment.

/* This is how you do
block
comments!
:) */

// Typical header for do-files
******************************************************************
* ECON381 - Statistics Review
* Introduction to STATA
******************************************************************

// Let's learn some Stata commands:

display 3+3 // use the display command to compute mathematical expressions


*allocate memory to STATA*
set mem 10m

*!!!!Changing directory to your local path!!!!
cd "/Users/mren7/Library/CloudStorage/Dropbox/Teaching/Econ 381/Fall 2026/Handouts/Handout 3"
*cd "/Users/ling/Documents/Stata/Demo/Start_with_Stata"

*Create a log file to record this session (replace means that the prevous file with this name will be overwritten)*
log using "Demo1.smcl", replace	

* open a dataset:
clear
use "WAGE2.DTA" 

* 1. Browsing/Describing the dataset
*********************************************************************

*Describe the variables in the dataset*

des

br 
br wage educ exper

*Gives summary statistics of the variables wage education*
sum
sum wage educ
sum wage educ, detail // detail option

sum wage, detail
sum educ, detail

*list observations 1 throgh 15*
list wage educ in 1/15

*Tabulate Distribution of Education *
tab educ
tab exper

* Sorting the data:
sort wage

* Using "in" and "if"
browse in 10/100
browse if educ == 12
browse if educ <= 12 & exper >= 10
browse if educ <= 12 & ( exper <= 2 | exper >= 20 ) d

* Histogram
histogram wage

* Create histograms:
twoway (histogram wage)
twoway (histogram educ)
twoway (histogram exper)

* Create scatter plots:
** One way
scatter wage educ
twoway (scatter wage educ) (lfit wage educ)

** More interesting way
gen mean_wage_by_educ=.
forvalues i=0(1)18 {
sum wage if educ==`i'
replace mean_wage_by_educ=r(mean) if educ==`i'
}

scatter mean_wage_by_educ educ
twoway (scatter mean_wage_by_educ educ) (lfit mean_wage_by_educ educ)

* Create bar graph:
graph bar (mean) wage, over(educ)

* Create new variables:
gen educsq = educ^2
gen indicator = (educ>=12)
tab indicator

bysort indicator: sum wage

* Renaming variables:
rename indicator highschool

* Labeling variables:
label var highschool "1 if worker completed high school education"

* Bysort:
bysort highschool: tab wage
bysort highschool: sum wage

* Delete variable
drop highschool

* Compute mean:
mean wage
mean educ
mean exper

* Compute correlations:
corr wage educ
corr wage educ exper tenure
corr wage educ exper tenure if profserv==1

help summarize

* Close the log file
log close

// * 2. Running Regressions
// *********************************************************************
//
// * Run simple regression of wage on education*
// reg wage educ
//
// * predict Fitted values*
// predict wagehat
//
// * predict residuals*
// predict uhat, resid
//
// * show residuals and fitted values*
// list wage educ wagehat uhat in 1/15
//
//
// * Delete predicted variables
// drop wagehat uhat
//
//
// * Create fitted values and residuals manually 
// matrix define C=e(b)
// gen wagehatm=C[1,1]*educ+C[1,2]
// gen uhatm=wage-wagehatm
//
// *** Voting example
// clear
// use "VOTE.DTA" 
// reg voteA shareA
// scatter voteA shareA
// twoway (scatter voteA shareA) (lfit voteA shareA)
//
// clear
//
// * 3. Simulations
//
// *creates a variable x with values starting at 0 and ending at 16 (with fixed increases) and 250 observations*
// range x 0 16 250
//
// * Generate Normal(0,9) distribution for x*
// 
// replace x = 3*invnormal(uniform())
//
// * Generate Normal(0,36) distribution for u
// 
// gen u = 6*invnormal(uniform())
//
// *Generate y so that the true population follows y = 3 + 2*x + u*
// gen y = 3 + 2*x + u
//
// twoway (scatter y x) (lfit y x)
//
// *Estimate the intercept and slope using OLS in this sample*
//
// reg y x
//
// * Now repeat the process to obtain "new samples", but keep x the same for simplicity.*
// *Repetition 1* 
// replace u = 6*invnormal(uniform())
// replace y = 3 + 2*x + u
// reg y x
//
// *Repetition 2* 
// replace u = 6*invnormal(uniform())
// replace y = 3 + 2*x + u
// reg y x
//
// *Repetition 3* 
// replace u = 6*invnormal(uniform())
// replace y = 3 + 2*x + u
// reg y x
//
// * How does the estimate change with the sample size
// clear 
// set obs 1000
// gen x=2*rnormal()+1
// gen u=rnormal()
// gen y=1+2*x+u
// reg y x if _n<=10
// reg y x if _n<=20
// reg y x if _n<=50
// reg y x if _n<=100
// reg y x if _n<=500
// reg y x if _n<=1000
//
// * Close the log
// log close


* Other resources:
* http://data.princeton.edu/stata/
* http://www.ats.ucla.edu/stat/stata/
* http://www.youtube.com/user/statacorp/featured
