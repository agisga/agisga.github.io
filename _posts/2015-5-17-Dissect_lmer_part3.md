---
layout: post
title: Dissecting lme4's lmer function. Part 3.
---

This is the final part of my analysis of the function `lmer`, which is used to fit linear mixed models in the R package `lme4`.
In two previous blog posts, we have seen the general layout of the function `lmer`, the dealings with the R model formula, and the setting up of the objective function for the optimization (see [part 1](http://agisga.github.io/Dissect_lmer_part1/) and [part 2](http://agisga.github.io/Dissect_lmer_part2/)).

After the user-specified R model formula is evaluated to model matrices, vectors and parameters, and the objective function is generated, the function `optimizeLmer` is called from within `lmer` to carry out the optimization. We analyse `optimizeLmer` below.

# Minimizing the deviance - `optimizeLmer`

The function takes as input arguments the previously generated deviance function `devfun`, the provided (or previously computed by `mkLmerDevfun`) starting values `start` for the optimization, and other optimization parameters (such as the method to be used) bundled in the `merControl` object `control`.

Then an environment is defined as `rho <- environment(devfun)`. That is, `rho` contains all the parameters defined by `mkLmerDevfun` during the generation of `devfun`; and additionally, the parent environment of `rho` is the environment from which `mkLmerDevfun` was called (so, there is access to variables from there as well).

Eventually the function `optwrap` (which is defined in `lmer.R`) is called to carry out the actual optimization. We dissect `optwrap` below. The returned object is saved as `opt`.

## `optwrap`

* Use `getOptfun` in order to check that the user-specified optimizer is supported.

* Deal with the peculiarities regarding the input arguments of the supported optimizer functions (e.g. modify `control` so that the verbose argument will be passed on correctly), and set up other input arguments for the optimizer with `arglist <- list(fn = fn, par = par, lower = lower, upper = upper, control = control)`.

* Call the optimizer:

```R
opt <- withCallingHandlers(do.call(optfun, arglist),
                           warning = function(w) {
                               curWarnings <<- append(curWarnings,list(w$message))
                           })
```

* Do some post optimization tweaking: rename the parameters in `opt` in a consistent way and pass on all warnings.

* Compute the gradient for the objective function at the estimated minimal values using the function `deriv12`, which uses a central finite difference method.

* Store all auxiliary information and return `opt`:

```R
attr(opt,"optimizer") <- optimizer
attr(opt,"control") <- control
attr(opt,"warnings") <- curWarnings
attr(opt,"derivs") <- derivs
opt
```


# Extended convergence checking - `checkConv`

If the optimization yields a result, then it is checked against additional convergence criteria by the function `checkConv`.

* Compute a scaled gradient as the solution to the linear system with the Cholesky factor of the Hessian as the matrix on the left hand side, and the gradient on the right hand side:

```R    
scgrad <- tryCatch(with(derivs,solve(chol(Hessian),gradient)),
                        error=function(e)e)
``` 

* Find the parallel minimum of the gradient and the scaled gradient of the objective function as `mingrad <- pmin(abs(scgrad),abs(derivs$gradient))`. Check whether the maximal entry of `mingrad` is above a specified threshold (default is 2e-3).

* Similarly check the relative gradient against a specified relative tolerance (disabled by default).

* Check whether the variance of any random effect is below a specified tolerance (i.e. equal to 0), that is, whether we have a singular fit. The default tolerance level here is 1e-4.

* Check the Hessian of the objective function for convergence. This check is implemented in the function `checkHess`, which performs the following steps:

  - Check that the Hessian has no negative eigenvalues (less that `-tol`, where tol is 1e-6 by default).

  - Check that the Hessian does not have very large eigenvalues, determined by $\rho(H) \cdot \mathrm{tol} > 1$ (where $\rho(H)$ is the [spectral radius](http://en.wikipedia.org/wiki/Spectral_radius) of the Hessian, and tol is 1e-6 by default).

  - Check that the ratio of the minimal to the maximal eigenvalues is not below `tol`; which is equivalent to the [conditional number](http://en.wikipedia.org/wiki/Condition_number) of the Hessian being smaller than `1/tol`. 

* Return all messages and warnings.


# Prepare an output object - `mkMerMod`

This function takes as inputs the environment of the objective function, the parameter estimates obtained from the optimization, the fixed effects and random effects model matrices etc., the original function call, and the messages generated from the convergence check in `checkConv`. 
It checks, reorganizes and renames the parameters, and finally returns everything in an object of class `lmerMod`:

```R
new(switch(rcl, lmerResp="lmerMod", glmResp="glmerMod", nlsResp="nlmerMod"),
    call=mc, frame=fr, flist=reTrms$flist, cnms=reTrms$cnms,
    Gp=reTrms$Gp, theta=pp$theta, beta=beta,
    u=if (trivial.y) rep(NA_real_,nrow(pp$Zt)) else pp$u(fac),
    lower=reTrms$lower, devcomp=list(cmp=cmp, dims=dims),
    pp=pp, resp=resp,
    optinfo = list (optimizer= attr(opt,"optimizer"),
                    control	 = attr(opt,"control"),
                    derivs	 = attr(opt,"derivs"),
                    conv  = list(opt=opt$conv, lme4=lme4conv),
                    feval = if (is.null(opt$feval)) NA else opt$feval,
                    warnings = attr(opt,"warnings"), val = opt$par)
    )
```

