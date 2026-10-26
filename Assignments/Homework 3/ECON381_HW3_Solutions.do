clear all
set more off
set linesize 120

/*
ECON 381: Homework 3 solutions, Fall 2026
Instructor solution: empirical sections.
Exercises adapted from Stock and Watson, Introduction to Econometrics, 4th ed.

Run from the folder containing Earnings_and_Height.dta:
    do "ECON381_HW3_Solutions.do"

Regression standard errors use "robust", heteroskedasticity-robust standard errors
Reported confidence intervals and p-values below use the standard-normal
approximation. The default regression table may use t critical values;
use the explicitly labeled normal-approximation results for this key.
*/


capture log close
log using "ECON381_HW3_Solutions.log", text replace

use "Earnings_and_Height.dta", clear
describe

* E4.2(a): Median height.
summarize height, detail
display as text "Median height (inches): " as result r(p50)
* Answer: The median height is 67 inches.

* E4.2(b)(i): Mean annual earnings for workers at most 67 inches tall.
summarize earnings if height <= 67
scalar short_mean = r(mean)
scalar short_n = r(N)
display as text "Shorter group: N = " as result short_n as text "; mean = " as result %12.2f short_mean
* Answer: Mean annual earnings are $44,488.44 (10,114 workers).

* E4.2(b)(ii): Mean annual earnings for workers taller than 67 inches.
summarize earnings if height > 67 & !missing(height)
scalar tall_mean = r(mean)
scalar tall_n = r(N)
display as text "Taller group: N = " as result tall_n as text "; mean = " as result %12.2f tall_mean
* Answer: Mean annual earnings are $49,987.88 (7,756 workers).

* E4.2(b)(iii): Compare the two means; a CI is not requested in this version.
display as text "Difference (taller minus shorter): " as result %12.2f (tall_mean - short_mean)
* Answer: Taller workers earn $5,499.44 more per year on average.
* These are descriptive group differences, not an identified causal effect.

* E4.2(c): Scatterplot and the horizontal bands.
twoway (scatter earnings height) ///
       (lfit earnings height), ///
       title("Earnings and height") ///
       xtitle("Height (inches)") ytitle("Annual earnings (2012 dollars)") ///
       legend(order(1 "Workers" 2 "OLS fitted line")) 
graph export "ECON381_HW3_Solutions_Graph.pdf", replace
* Answer: Earnings were reported in 23 brackets. Case and Paxson assigned
* an estimated average earnings value to each bracket and converted the
* values to 2012 dollars. Workers in the same bracket share the same value,
* so the scatterplot has horizontal bands. These are grouped income data.

* E4.2(d)(i): Pooled regression and estimated slope.
regress earnings height, robust
display as text "Intercept: " as result %12.4f _b[_cons]
display as text "R-squared: " as result %10.6f e(r2)
display as text "SER: " as result %12.4f e(rmse)
* Answer: Fitted earnings = -512.7336 + 707.6716 * height (in inches).
* Each additional inch is associated with $707.67 higher annual earnings.

* E4.2(d)(ii): Predictions at the three specified heights.
foreach h in 67 70 65 {
    display as text "Predicted annual earnings at height `h': " as result %12.2f (_b[_cons] + _b[height] * `h')
}
* Answer: 67 inches: $46,901.26; 70 inches: $49,024.28;
* 65 inches: $45,485.92. Predictions use the unrounded coefficients.

* E4.2(e): Change height units using exactly 2.54 centimeters per inch.
generate double height_cm = 2.54 * height
regress earnings height_cm, robust
display as text "Intercept: " as result %12.4f _b[_cons]
display as text "R-squared: " as result %10.6f e(r2)
display as text "SER: " as result %12.4f e(rmse)
* Answer: Slope = 707.6716 / 2.54 = $278.6108 per centimeter.
* Intercept = -512.7336; R-squared = 0.0108753; SER = $26,777.24.
* Fitted earnings and residuals are unchanged by rescaling the regressor.

* E4.2(f): Female workers (sex = 0).
regress earnings height if sex == 0, robust
* Answer (i): The slope is $511.22 per inch.
* Answer (ii): A woman 1 inch taller than the female sample mean is predicted
* to earn $511.22 more than female sample-average annual earnings. OLS with
* an intercept passes through the group means of height and earnings.

* E4.2(g): Male workers (sex = 1).
regress earnings height if sex == 1, robust
* Answer (i): The slope is $1,306.86 per inch.
* Answer (ii): A man 1 inch taller than the male sample mean is predicted
* to earn $1,306.86 more than male sample-average annual earnings.

* E4.2(h): The zero conditional mean assumption is not established here.
* Answer: Height may be correlated with omitted determinants of earnings,
* such as family background, education, health, sex, or physical strength.
* There is no basis for assuming E(u_i | Height_i) = 0 solely from this
* regression. A positive slope need not measure a causal effect of height.


* E5.1(a): All workers.
regress earnings height, robust
* Answer: Slope = 707.67, robust SE = 50.40, statistic = 14.0425.
* Normal p-value = 8.56e-45; reject zero slope at 5%.
* The 95% normal CI is [$608.90, $806.45] per inch.

* E5.1(b): Women.
regress earnings height if sex == 0, robust
* Answer: Slope = 511.22, robust SE = 97.58, statistic = 5.2388.
* Normal p-value = 1.62e-7; reject zero slope at 5%.
* The 95% normal CI is [$319.96, $702.49] per inch.

* E5.1(c): Men.
regress earnings height if sex == 1, robust
* Answer: Slope = 1,306.86, robust SE = 98.86, statistic = 13.2197.
* Normal p-value = 6.75e-40; reject zero slope at 5%.
* The 95% normal CI is [$1,113.10, $1,500.62] per inch.

* E5.1(d) is not assigned; the original part (e) retains its textbook label.

* E5.1(e): Restrict to occupations in which physical strength is less likely
* to be important: executives/managers, professionals, technicians, sales,
* and administrative workers (occupation codes 1 through 5).
regress earnings height if (1<=occupation) & (occupation<=5), robust
* Answer: N = 11,020; slope = 829.78; robust SE = 65.11;
* statistic = 12.7436; normal p-value = 3.38e-37;
* 95% normal CI = [$702.16, $957.41] per inch.
* The positive association persists. Physical strength alone does not
* explain it. This restriction does not establish a causal height effect.

* Additional detail: report each of the five low-strength occupations.
forvalues k = 1/5 {
    regress earnings height if occupation == `k', robust
}
* Their slopes are about $469.46, $622.76, $649.72, $1,372.38, and $201.22.
* The first four are significant at 5%; administration is not (p about 0.13).
* Other reasonable occupation restrictions can also receive credit if
* their choice and interpretation are explained.

log close
