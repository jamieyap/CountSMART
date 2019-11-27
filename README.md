# CountSMART

## 0. About CountSMART

This repository contains code to estimate sample size needed to compare dynamic treatment regimens using longitudinal count outcomes from a Sequential Multiple Assignment Randomized Trial (SMART) via simulation.

## 1. About This Repository

This repository contains code for performing sample size estimation via simulation. Files corresponding to particular stages of the project are placed under the relevant header.

## 2. Before Proceeding

Questions about the material in this repository can be directed at https://github.com/jamieyap/CountSMART/issues by submitting a `New issue`. Prior to running the code, ensure that steps described in [prep.pdf](https://github.com/jamieyap/CountSMART/blob/master/prep.pdf) have been performed.

## 3. Contents of `code` Folder

File | Description
------------------------ | -------------------------
[input-utils.R](https://github.com/jamieyap/CountSMART/tree/master/code/input-utils.R) | Contains a function for checking validity of time-specific means and proportion of zeros provided as inputs to the sample size estimation procedure. [input_means.csv](https://github.com/jamieyap/CountSMART/tree/master/run-examples/dat-example-01a/input_means.csv) and [input_prop_zeros.csv](https://github.com/jamieyap/CountSMART/tree/master/run-examples/dat-example-01a/input_prop_zeros.csv)  provide examples of valid inputs.
[datagen-utils.R](https://github.com/jamieyap/CountSMART/tree/master/code/datagen-utils.R) | Collection of functions to generate potential outcomes and observed outcomes.
[analysis-utils.R](https://github.com/jamieyap/CountSMART/tree/master/code/analysis-utils.R) | Collection of functions to 'analyze' data from a SMART.
[calibrate-params.R](https://github.com/jamieyap/CountSMART/tree/master/code/calibrate-params.R) | Implements calibration stage of the sample size estimation method.
[calc-delta.R](https://github.com/jamieyap/CountSMART/tree/master/code/calc-delta.R) |  Implements calculation of standardized effect size of the sample size estimation method.
[calc-power.R](https://github.com/jamieyap/CountSMART/tree/master/code/calc-power.R) |  Implements power calculation stage of the sample size estimation method.
[estimate-sample-size.R](https://github.com/jamieyap/CountSMART/tree/master/code/estimate-sample-size.R) | Calls [calc-power.R](https://github.com/jamieyap/CountSMART/tree/master/code/calc-power.R) to estimate sample size for various candidate sample sizes.
[calc-bias.R](https://github.com/jamieyap/CountSMART/tree/master/code/calc-bias.R) |  Calculates bias of estimates when called by [run-calc.R](https://github.com/jamieyap/CountSMART/blob/master/run-sanity-checks/run-calc.R)
[calc-coverage.R](https://github.com/jamieyap/CountSMART/tree/master/code/calc-coverage.R) |  Calculates coverage of estimates when called by [run-calc.R](https://github.com/jamieyap/CountSMART/blob/master/run-sanity-checks/run-calc.R)

## 4. Contents of `run-examples` Folder

File/Folder | Description
------------------------ | -------------------------
[example-01a.R](https://github.com/jamieyap/CountSMART/tree/master/run-examples/example-01a.R) | Calls code in `code` folder to generate estimates presented in example 1 when tauMAX=0.75.
[example-01b.R](https://github.com/jamieyap/CountSMART/tree/master/run-examples/example-01b.R) | Calls code in `code` folder to generate estimates presented in example 1 when tauMAX=0.10.
[run-examples/dat-example-01a](https://github.com/jamieyap/CountSMART/tree/master/run-examples/dat-example-01a) | Folder containing inputs to [example-01a.R](https://github.com/jamieyap/CountSMART/tree/master/run-examples/example-01a.R)
[run-examples/dat-example-01b](https://github.com/jamieyap/CountSMART/tree/master/run-examples/dat-example-01b) | Folder containing inputs to [example-01b.R](https://github.com/jamieyap/CountSMART/tree/master/run-examples/example-01b.R)
[run-examples/output-example-01a](https://github.com/jamieyap/CountSMART/tree/master/run-examples/output-example-01a) | Folder containing outputs of [example-01a.R](https://github.com/jamieyap/CountSMART/tree/master/run-examples/output-example-01a.R)
[run-examples/output-example-01b](https://github.com/jamieyap/CountSMART/tree/master/run-examples/output-example-01b) | Folder containing outputs of [example-01b.R](https://github.com/jamieyap/CountSMART/tree/master/run-examples/output-example-01b.R)

## 4. Contents of `run-sanity-checks` Folder

File/Folder | Description
------------------------ | -------------------------
[run-calc.R](https://github.com/jamieyap/CountSMART/blob/master/run-sanity-checks/run-calc.R) | Produces tables in appendix A and B.
[run-sanity-checks/dat-checks](https://github.com/jamieyap/CountSMART/tree/master/run-sanity-checks/dat-checks) | Folder containing inputs to [run-calc.R](https://github.com/jamieyap/CountSMART/blob/master/run-sanity-checks/run-calc.R)
[run-sanity-checks/output-checks](https://github.com/jamieyap/CountSMART/tree/master/run-sanity-checks/output-checks) | Folder containing outputs of [run-calc.R](https://github.com/jamieyap/CountSMART/blob/master/run-sanity-checks/run-calc.R)