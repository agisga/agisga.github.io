---
layout: post
title: Dissecting lme4's lmer function. Part 1.
---

This blog posts marks the start of my GSoC project with the [Ruby Science Foundation](http://sciruby.com), where I will develop mixed linear models software for Ruby. As a preparation for my GSoC project, I will dedicate a couple of blog posts to a meticulous analysis of [`lme4`](https://github.com/lme4/lme4.git) code (so that I can steal all the ideas from it!).

The `R` package `lme4` is capable of fitting linear, generalized and nonlinear mixed effects models. Here, I am interested in linear mixed models exclusively. A linear mixed model fit is performed in `lme4` with an `lmer` function call. For example:

```R
library(lme4)
data(sleepstudy)
fm1 <- lmer(Reaction ~ Days + (Days | Subject), sleepstudy)
```

Thus, the first function to dissect is `lmer`.
The function definition of `lmer` is located in the file `lmer.R`.
The code is confusing. So, let's go through it step-by-step.

# General overview

The general steps taken in `lmer` are:

1. *Set some parameters in the local environment*. In particular, deal with the function argument `control`, which usually is a list inheriting from class `merControl` (but `control` can be defined in other ways too, and the code deals with all possibilities in a multitude of lines). It includes general parameters such as the optimizer to be used, model- and data-checking specifications, and all parameters to be passed to the optimizer.

2. *Parse data and formula*. At this step the fixed effects matrix $X$, the random effects matrix $Z$, the parameter vector $\theta$, the covariance factor $\Lambda\subscript{\theta}$, etc. are created from the input data. Moreover, the `REML` flag is set, formula is rewritten in the preferred form, and warnings from checks for the random effects (e.g. about the number of levels, dimension of $Z$, rank of $Z$) are generated. This all is performed by the function `lFormula`, which is located in `modular.R`.

3. *Create the deviance function to be minimized*. Call the function `mkLmerDevfun`, which returns a function `devfun` to calculate the profiled deviance. Implicitly `mkLmerDevfun` also returns an environment required to evaluate `devfun`. The function definition of `mkLmerDevfun` can be found in `modular.R`.

4. *Optimize the deviance function w.r.t.* $\theta$. Optimize the deviance `devfun` with respect to the covariance parameters $\theta$. This is performed by the function `optimizeLmer` (located in `modular.R`), which returns the result of the optimization.

5. *Check convergence criteria*. Convergence check according to the convergence check options specified in `control`, performed by the function `checkConv`, which is implemented in the file `checkConv.R`.

6. *Set up a useful output object*. Package the results into a `merMod` object to return. This is performed by the function `mkMerMod`, located in the file `utilities.R`.

Step 2-6 perform function calls to other sophisticated functions. We will dissect each of those separately in what follows.

# Processing the formula - `lFormula`

Defined as:

```R
lFormula <- function(formula, data=NULL, REML = TRUE,
                     subset, weights, na.action, offset, contrasts = NULL,
                     control=lmerControl(), ...)
```

It proceeds with the following steps:

* *Check the input arguments*. Call `checkArgs` on the given input arguments, in order to produces some warnings (about "family" and "method" being deprecated, and extra unused arguments) if necessary. Check that the input for `check.formula.LHS` is a valid value via the function `checkCtrlLevels`. The function `checkArgs` is defined in `utilities.R`, and `checkCtrlLevels` is defined in `modular.R`.

* *Check and adjust the given formula and data frame*. Check the provided formula and data with `checkFormulaData` from `utilities.R` (e.g. check missing data, check if formula has a left hand side, etc.). From the right hand side of a formula for a mixed-effects model, expand terms with `||` into separate, independent random effect terms written with `|` (`expandDoubleVerts` is defined in `utilities.R`, `RHSForm` is defined in `modular.R`). Generate a data frame with only the variables needed to use the given formula.

* *Create the random effects model matrix* $Z$, *its covariance factor* $\Lambda\subscript{\theta}$, *as well as the parametrization* $\theta$, *etc*. This is performed by the function `mkReTrms`, which is defined in `utilities.R`. Additionally, check that all grouping structures have at least 2 levels, that for each random effect $Z$ has more columns than rows, that the rank of $Z$ is not greater than $n$, etc. with the functions `checkNlevels`, `checkZdims`, `checkZrank` (all defined in `modular.R`). 

* *Create the fixed effects design matrix* $X$. Only basic `R` functions like `model.matrix` used here.

* *Return a data frame with variables required to use the formula*. That is, fixed effects matrix $X$; `reTrms` containing the random effects matrix $Z$, covariance factor $\Lambda\subscript{\theta}$, etc.; `REML` flag; the formula; warnings from checks for the random effects (number of levels, dimension of $Z$, rank of $Z$, etc.). 
