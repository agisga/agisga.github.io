---
layout: post
title: MixedModels Formula Interface and Categorical Variables
---

I made some more progress on my [Google Summer of Code project MixedModels](https://github.com/agisga/MixedModels). The linear mixed models fitting method is now capable of handling non-numeric (i.e., categorical) predictor variables, as well as interaction effects. Moreover, I gave the method a user friendly R-formula-like interface. I will present these new capabilities of the Ruby gem with an example. Then I will briefly describe their implementation.

# Example

## Data and mathematical model formulation

The data is supplied to the model fitting method `LMM#from_formula` as a `Daru::DataFrame` (from the excellent Ruby gem [daru](https://github.com/v0dro/daru.git)). In order to test `LMM#from_formula`, I have generated a data set of the following form:

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

As we can see, the data set contains two numeric variables *Age* and *Aggression*, and two categorical variables *Location* and *Species*. These data are available for 100 individuals.

We model the *Aggression* level of an individual as a linear function of the *Age* (*Aggression* decreases with *Age*), with a different constant added for each *Species* (i.e. each species has a different base level of aggression). Moreover, we assume that there is a random fluctuation in *Aggression* due to the *Location* that an individual is at. Additionally, there is a random fluctuation in how *Age* affects *Aggression* at each different *Location*. 

Thus, the *Aggression* level of an individual of *Species* $spcs$ who is at the *Location* $lctn$ can be expressed as:

$$Aggression = \beta\subscript{0} + \gamma\subscript{spcs} + Age \cdot \beta\subscript{1} + b\subscript{lctn,0} + Age \cdot b\subscript{lctn,1} + \epsilon,$$

where $\epsilon$ is a random residual, and the random vector $(b\subscript{lctn,0}, b\subscript{lctn,1})^T$ follows a multivariate normal distribution (the same distribution but different realizations of the random vector for each *Location*). That is, we have a linear mixed model with fixed effects $\beta\subscript{0}, \beta\subscript{1}, \gamma\subscript{Dalek}, \gamma\subscript{Ood}, \dots$ and random effects $b\subscript{Asylum,0}, b\subscript{Asylum,1}, b\subscript{Earth,0},\dots$.

## Model fit

We fit this model in Ruby using `MixedModels` with:

```ruby
model_fit = LMM.from_formula(formula: "Aggression ~ Age + Species + (Age | Location)", 
                             data: alien_species)
```

where the argument `formula` takes in a `String` that contains a formula written in the formula language that is used in the R-package `lme4` (`MixedModels` currently supports most of the formula language except some shortcuts). Since `lme4` is currently the most commonly used package for linear mixed models, a lot of documentation and tutorials to the formula interface can be found online. 

We print some of the results that we have obtained:

```ruby
puts "REML criterion: \t#{model_fit.dev_optimal}"
puts "Fixed effects:"
puts model_fit.fix_ef
puts "Standard deviation: \t#{Math::sqrt(model_fit.sigma2)}"
```

Which produces the output:

```
REML criterion: 	333.71553910151437
Fixed effects:
{"x0"=>1016.2867207023437, "x1"=>-0.06531615342788923, 
"x2"=>-499.69369529020815, "x3"=>-899.569321353576, 
"x4"=>-199.5889580420067}
Standard deviation: 	0.9745169802141329
```

### Comparison with R lme4

We fit the same model in R using the package `lme4`, and print out the estimates for the same quantities as previously:

```R
> mod <- lmer(Aggression ~ Age + Species + (Age | Location), data = alien.species)
> REMLcrit(mod)
[1] 333.7155
> fixef(mod)
        (Intercept)                 Age        SpeciesHuman          SpeciesOod 
      1016.28672021         -0.06531615       -499.69369521       -899.56932076 
SpeciesWeepingAngel 
      -199.58895813 
> sigma(mod)
[1] 0.9745324
```

We observe that the parameter estimates from Ruby and R agree up to at least four digits behind the floating point. 

# A brief comment on the implementation

## Categorical predictor variables

If a predictor variable is categorical and no intercept term or other categorical variables are included in the design matrix, then the design matrix must contain a column of zeros and ones for each different level of the categorical variable. If the design matrix includes an intercept term or already contains another set of 0-1-indicators for a categorical variable, then one of the levels of the categorical variable, that we want to add to the model, must be excluded (or other so-called contrasts can be used).

In the current implementation of `MixedModels` this is handled by the method `Daru::DataFrame::create_indicator_vectors_for_categorical_vectors!` (defined [here](https://github.com/agisga/MixedModels/blob/master/lib/MixedModels/daru_methods.rb#L90)). It adds a set of 0-1-valued vectors for each non-numeric vector in the `Daru::DataFrame`:

```ruby
> df = Daru::DataFrame.new([(1..7).to_a, ['a','b','b','a','c','d','c']],
                           order: ['int','char']) 
> df.create_indicator_vectors_for_categorical_vectors!
  # => <Daru::DataFrame:70212314363900 @name = 1a2a49d9-35d3-4adf-a993-5266d7d79442 @size = 7>
             int       char char_lvl_b char_lvl_c char_lvl_d 
    0          1          a        0.0        0.0        0.0 
    1          2          b        1.0        0.0        0.0 
    2          3          b        1.0        0.0        0.0 
    3          4          a        0.0        0.0        0.0 
    4          5          c        0.0        1.0        0.0 
    5          6          d        0.0        0.0        1.0 
    6          7          c        0.0        1.0        0.0
```

(where it didn't add a vector for level "a" of "char", because it assumes a model with intercept by default)

After the data frame is extended, `LMM#from_daru` checks which of the specified terms are non-numeric, and replaces them with the names of the 0-1-valued indicator columns (e.g. if a fixed effects term `char` were defined, `LMM#from_daru` would replace it with `char_lvl_b`, `char_lvl_c` and `char_lvl_d`).

I will probably end up restructuring the current implementation, in order to better accommodate interaction effects between categorical variables...

## Formula interface

`LMM#from_formula` takes in a `String` containing a formula specifying the model, for example 

```ruby
"z ~ x + y + x:y + (x | u)".
```

It transforms this formula into another `String`, for the above example:

```ruby
"lmm_formula(:intercept) + lmm_variable(:x) + lmm_variable(:y) + lmm_variable(:x) * lmm_variable(:y) + (lmm_variable(:intercept) + lmm_variable(:x) | lmm_variable(:u)))",
```

adding intercept terms and wrapping all variables in `lmm_variable()`.

The Ruby expression in the `String` is evaluated with `eval`. This evaluation uses a specially defined class `LMMFormula` (defined [here](https://github.com/agisga/MixedModels/blob/master/lib/MixedModels/LMMFormula.rb)), which overloads the `+`, `*` and `|` operators, in order to combine the variable names into arrays, which can be fed into `LMM#from_daru`. The class `LMMFormula` was an idea that I got from Will Levine ([wlevine](https://github.com/wlevine)). In particular, the method `LMMFormula#to_input_for_lmm_from_daru` transforms an `LMMFormula` object into a number of `Array`, which have the form required by `LMM#from_daru`.

Finally, `LMM#from_daru` constructs the model matrices, vectors and the covariance function `Proc`, which are passed on to `LMM#initialize` that performs the actual model fit.
