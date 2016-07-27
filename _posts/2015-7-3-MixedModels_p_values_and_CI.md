---
layout: post
title: P-values and confidence intervals
tags:
- ruby
- mixed_models
- regression
- LMM
---

A few days ago I started working on hypotheses tests and confidence intervals for my project [`mixed_models`](https://github.com/agisga/mixed_models), and I got pretty surprised by certain things.

# Methods

There does not seem to be an agreement on a method to compute p-values (or whether to compute them at all) and confidence intervals for (generalized) linear mixed models in the scientific community. See for example the multitude of discussions on Cross Validated ([(1)](http://stats.stackexchange.com/questions/118416/getting-p-value-with-mixed-effect-with-lme4-package), [(2)](http://stats.stackexchange.com/questions/95054/how-to-get-the-overall-effect-for-linear-mixed-model-in-lme4-in-r), [(3)](http://stats.stackexchange.com/questions/65489/how-do-i-get-a-a-p-value-for-the-output-of-an-lme-model-with-lme4), [(4)](http://stats.stackexchange.com/questions/22988/significant-effect-in-lme4-mixed-model) among others), or the longish [statement](https://stat.ethz.ch/pipermail/r-help/2006-May/094765.html) on the topic by the creator of `lme4` and `nlme` Douglas Bates.

There are many ways to perform hypothesis tests and to compute confidence intervals for the fixed effects coefficients of a linear mixed model. For a list see for example [this entry from the wiki of the r-sig-mixed-models mailing list](http://glmm.wikidot.com/faq). Unfortunately, the more accurate and universally applicable among the methods are computationally expensive and difficult to implement within Ruby's current infrastructure of gems. 

The method that is most convenient to compute is the Wald Z-test. However, its validity is often questionable. [The wiki of the r-sig-mixed-models mailing list](http://glmm.wikidot.com/faq) names the following reasons:

>\[Wald Z-statistics\] are asymptotic approximations, assuming both that (1) the sampling distributions of the parameters are multivariate normal (or equivalently that the log-likelihood surface is quadratic) and that (2) the sampling distribution of the log-likelihood is (proportional to) $\chi^2$. The second approximation is discussed further under "Degrees of freedom". The first assumption usually requires an even greater leap of faith, and is known to cause problems in some contexts (for binomial models failures of this assumption are called the Hauck-Donner effect), especially with extreme-valued parameters.

Nevertheless, for now I decided to implement the Wald method only. It is still useful as a computationally light method for the initial data analysis, before falling back on the heavy weaponry. The `LMM` class provides methods to access all parameter estimates and information required in order to implement other methods to compute p-values or confidence intervals by the user, applicable to her specific situation.

For future extensibility I have included an argument `:method` in all of the methods.

# Implementation and usage

## Example data

For purposes of illustration, I use the same data as in my previous [blog post](http://agisga.github.io/MixedModels_from_formula/).
The simulated data set contains two numeric variables *Age* and *Aggression*, and two categorical variables *Location* and *Species*. These data are available for 100 individuals.

```ruby
> alien_species.head
=> 
#<Daru::DataFrame:70197332524760 @name = 1cd9d732-526b-49ae-8cb1-35cd69541c87 @size = 10>
                  Age Aggression   Location    Species 
         0     204.95 877.542420     Asylum      Dalek 
         1      39.88 852.528392  OodSphere WeepingAng 
         2     107.34 388.791416     Asylum      Human 
         3     210.01 170.010124  OodSphere        Ood 
         4     270.22 1078.31219  OodSphere      Dalek 
         5     157.65 164.924992  OodSphere        Ood 
         6     136.15 865.838374  OodSphere WeepingAng 
         7     241.31 1052.36035      Earth      Dalek 
         8      86.84 -8.5725199     Asylum        Ood 
         9      206.7 1070.71900  OodSphere      Dalek 
```


We model the *Aggression* level of an individual as a linear function of the *Age* (*Aggression* decreases with *Age*), with a different constant added for each *Species* (i.e. each species has a different base level of aggression). Moreover, we assume that there is a random fluctuation in *Aggression* due to the *Location* that an individual is at. Additionally, there is a random fluctuation in how *Age* affects *Aggression* at each different *Location*. 

We fit this model in Ruby using `mixed_models` with:

```ruby
require 'mixed_models'
alien_species = Daru::DataFrame.from_csv './data/alien_species.csv'
model_fit = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                             data: alien_species)
```

## Test statistics

The [Wald Z test statistics](https://en.wikipedia.org/wiki/Wald_test#Test_on_a_single_parameter) for the fixed effects coefficients can be computed with:

```ruby
model_fit.fix_ef_z

# => {:intercept=>16.882603431075875, :Age=>-0.7266646548258817, 
:Species_lvl_Human=>-1862.7747813759402, :Species_lvl_Ood=>-3196.2289922406044, 
:Species_lvl_WeepingAngel=>-723.7158917283754}
```

We see that the variable `Species` seems to have a huge influence on `Aggression`, while `Age` not so much.

## P-values

Based on the above test statistics, we can carry out hypotheses tests for each fixed effects term $\beta\subscript{i}$, testing the null

$$H\subscript{0} : \beta\subscript{i} = 0$$

against the alternative

$$H\subscript{a} : \beta\subscript{i} \neq 0.$$

The corresponding (approximate) p-values are obtained with:

```ruby
model_fit.fix_ef_p(method: :wald)

# => {:intercept=>0.0, :Age=>0.4674314106158888, 
:Species_lvl_Human=>0.0, :Species_lvl_Ood=>0.0, 
:Species_lvl_WeepingAngel=>0.0}
```

We see that indeed the aggression level of each species is highly significantly different from the base level (which is the species `Dalek` in this model), while statistically we don't have enough evidence to conclude that the age of an individual is a good predictor of his/her/its aggression level.

I have specified `method: :wald` above for illustration purposes only, because the Wald method is currently the default and the only available method. In the future I might implement other methods which are more reliable and more computationally difficult at the same time.

## Confidence intervals

We can use the Wald method for confidence intervals as well. For example 90% confidence intervals for each fixed effects coefficient estimate can be computed as follows.

```ruby
model_fit.fix_ef_conf_int(level: 0.9, method: :wald)

# => {:intercept=>[917.2710135369496, 1115.302428002405],
 :Age=>[-0.2131635992213468, 0.08253129235199347],
 :Species_lvl_Human=>[-500.13493113101106, -499.25245944940696],
 :Species_lvl_Ood=>[-900.0322606117458, -899.1063820954081],
 :Species_lvl_WeepingAngel=>[-200.04258166587766, -199.13533441813757]}
```

As for the p-values, the Wald method is currently the only option and the default.

<!-- # Predictions

Recently, I have also implemented method for predictions on new data by the fitted linear mixed model.
Data can be supplied to `LMM#predict` either in form of a `Daru::DataFrame`, or as model matrices for the fixed and random effects (which is far less convenient but might be necessary for unconventional models).

Assume, we have captured ten new individuals of different ages and species and at different locations, and we want to estimate their aggression levels.

We can put their data in a new Daru::DataFrame:

```Ruby
                  Age   Location    Species 
         0        209  OodSphere      Dalek 
         1         90      Earth        Ood 
         2        173     Asylum        Ood 
         3        153     Asylum      Human 
         4        255  OodSphere WeepingAng 
         5        256     Asylum WeepingAng 
         6         37      Earth      Dalek 
         7        146      Earth WeepingAng 
         8        127     Asylum WeepingAng 
         9         41     Asylum        Ood
```

Then we estimate the aggression level of each individual (conditional on the obtained parameter estimates) using our fitted model:

```Ruby
model_fit.predict(newdata: newdata)

# => [1070.9125752531213, 182.45206492790766, -17.064468754763425, 384.78815861991046, 876.1240725686444, 674.711339114886, 1092.6985606350875, 871.150885526236, 687.4629975728096, -4.0162601001437395]
```

We can also exclude the estimated random effects from the predictions. For our example that would make sense, if we had observed individuals in previously unobserved locations.

```Ruby
model_fit.predict(newdata: newdata, with_ran_ef: false)

# => [1002.6356447018298, 110.83894560697945, 105.41770487190126, 506.59965400396266, 800.0421436018271, 799.9768274483924, 1013.8700230925942, 807.1616043262068, 808.4026112414656, 114.0394371252786]
```

### Prediction intervals

Additionally, confidence intervals for the predictions (i.e. prediction intervals) can be computed. The methods are the same as used for the confidence intervals of fixed effects. The prediction intervals are implemented only for the population level predictions (i.e. without inclusion of the random effects estimates).
Continuing our example, we have:
-->

