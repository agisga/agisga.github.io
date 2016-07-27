---
layout: post
title: Model specification for linear mixed model 
tags:
- ruby
- mixed_models
- lme4
- regression
- LMM
---

Last week I wrote about my implementation of an algorithm that fits a linear mixed model in Ruby using the gem [MixedModels](https://github.com/agisga/MixedModels), that I am working on right now. See, [first rudimentary LMM fit](http://agisga.github.io/First-linear-mixed-model-fit/).

The currently available interface to the method is rather unfriendly to the user. First, I was planning on reproducing the interface of the R mixed models library lme4, but that appears to be too complicated and too time consuming. I spend some time thinking about what to do instead. Below, I present an idea and it's comparison to the lme4 interface in R. In particular, I want to write a more user-friendly initialization method `LMM#from_daru` that will work on [daru](https://github.com/v0dro/daru) data sets.

### Random intercept model

Simplest model. The i'th observation of "yield" in the j'th batch is modeled as:

$$Yield\subscript{ij} = Intercept + BatchEffect\subscript{j} + RandomError\subscript{ij},$$

where "Intercept" is the overall mean, and "BatchEffect" denotes a random effect due to the batch that the i'th observation was in.

In lme4 (R):

```R
fm01 <- lmer(Yield ~ 1 + (1|Batch), Dyestuff)
```

In MixedModels (Ruby):

```ruby
fm01 = LMM.from_daru(response: :yield,
                     fixed_effects: :intercept,
                     random_effects: :intercept,
                     grouping: :batch,
                     data: dyestuff)
```

### Crossed random effects

Simple crossed random effects. The i'th observation of "diameter" in the j'th "sample" from the k'th "plate" is modeled as:

$$diameter\subscript{ijk} = Intercept + SampleIntercept\subscript{j} + PlateIntercept\subscript{k} + RandomError\subscript{ij},$$

where "Intercept" is the overall average, and "SampleIntercept" as well as "PlateIntercept" are random intercept terms, due to the sample and plate that a particular observation comes from.

In R, lme4:

```R
fm03 <- lmer(diameter ~ 1 + (1|plate) + (1|sample), Penicillin))
```

In Ruby, MixedModels:

```ruby
fm03 = LMM.from_daru(response: :diameter,
                     fixed_effects: :intercept,
                     random_effects: [:intercept, :intercept],
                     grouping: [:plate, :sample],
                     data: penicillin)
```

### Nested random effects

The i'th observation of "BoneGrowth" in the m'th "digit" of the k'th "foot" of the j'th "mouse" can be modelled as:

$$BoneGrowth\subscript{ijkm} = Intercept +  MouseIntercept\subscript{j} + FootIntercept\subscript{kj} + RandomError\subscript{ijkm},$$

i.e. the random effect "foot" only appears as nested within "mouse" (i.e. the intercept due to foot 1 in mouse 1 is different than the intercept due to foot 1 in mouse 2).

In R, lme4:

```R
bone.growth.lmer <- lmer(BoneGrowth ~ 1 + (1|mouse) + (1|mouse:foot), 
                         data = dat)
```

or more succinct:

```R
bone.growth.lmer <- lmer(BoneGrowth ~ (1|mouse/foot), data = dat)
```

In Ruby, MixedModels: Construct additional data frame columns, describing the interaction of foot and mouse, by hand. Then fit a model as shown above for crossed random effects...

### Random slopes.

The i'th observation of "politeness" in the j'th subject and the k'th scenario is modeled as:

$$\begin{eqnarray} 
Politeness\subscript{ijk} &=& Intercept + SubjectIntercept\subscript{j} + ScenarioIntercept\subscript{k} \nonumber \\
 &+& IsFemale\subscript{ijk} \cdot FixedEffect + IQ\subscript{ijk} \cdot AnotherFixedEffect \nonumber \\
&+& Attitude\subscript{ijk} \cdot SubjectSlope\subscript{j} + Attitude\subscript{ijk} \cdot ScenarioSlope\subscript{k} \nonumber \\
 &+& RandomError\subscript{ijk}, \nonumber 
\end{eqnarray}$$

where we assume a random intercept and slope due to "subject", and a random intercept and slope due to "scenario".

This can be expressed in R as:

```R
politeness.model = lmer(politeness ~ gender + IQ + (1+attitude|subject) + (1+attitude|scenario), data=politeness)
```

And the equivalent in Ruby would be:

```ruby
politeness_model = LMM.from_daru(response: :politeness,
                                 fixed_effects: [:gender, :IQ],
                                 random_efffects: [ [:intercept, :attitude], [:intercept, :attitude] ],
                                 grouping: [:subject, :scenario],
                                 data: politeness)
```

### Interaction effects, and transformations of the fixed effects

We model the i'th observation in the j'th batch as:

$$z\subscript{ij} = \beta\subscript{0} + x\subscript{ij} \cdot \beta\subscript{1} + x\subscript{ij}^2 \cdot \beta\subscript{2} + y\subscript{ij} \cdot \beta\subscript{3} + x\subscript{ij}y\subscript{ij} \cdot \beta\subscript{4} + u\subscript{j} + \epsilon\subscript{ij},$$

where $u\subscript{j}$ denotes the random intercept of the j'th batch and $\epsilon\subscript{ij}$ is the random error.

In R, lme4:

```R
modfit <- lmer(z ~ x*y + I(x^2) + (1|u))
```

In Ruby, MixedModels: By hand, generate new columns to the `daru` data frame. Namely, a column containing the squares of $x$ and a column containing the products $xy$. Then call `LMM#from_daru` as,

```ruby
modfit = LMM.from_daru(response: :z,
                       fixed_effects: [:intercept, :x, :x2, :y, :xy],
                       random_effects: :intercept,
                       grouping: :u,
                       data: your_xyzu_data)
```

### Summary

This list of examples is most likely far from exhaustive, but it presents some of the most common types of linear mixed model fits.

Disadvantages of my proposed model specification interface for Ruby compared to R:

- Lengthy
- No interaction effects
- No nested effects
- No transformations of predictors
- ...


