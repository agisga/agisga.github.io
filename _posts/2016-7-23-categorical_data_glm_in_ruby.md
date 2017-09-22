---
layout: post
title: Logistic regression with categorical data in Ruby
tags:
- ruby
- daru
- statsample-glm
- regression
- GLM
- kaggle
- data analysis
---

I had some fun analysing the [shelter animal data](https://www.kaggle.com/c/shelter-animal-outcomes) from [kaggle](https://www.kaggle.com/competitions) using the Ruby gems `daru` for data wrangling and `statsample-glm` for model fitting. In this blog post, I want to demonstrate that data wrangling and statistical modeling is not an area of absolute predominance of Python and R, but that it is possible in Ruby too (though, currently to a much lesser extent).

The presented data analysis steps are only possible thanks to [the Google Summer of Code 2016 work of Lokesh Sharma](https://summerofcode.withgoogle.com/projects/#6288543399804928) (github: [@lokeshh](https://github.com/lokeshh)), who is working on categorical data support for `daru` and `statsample-glm`. For the following code snippets I have used the [current development version of `daru`](https://github.com/v0dro/daru) and Lokesh's [`cat_data` branch of `statsample-glm`](https://github.com/lokeshh/statsample-glm/tree/cat_data).

## What is the model, what are we predicting, and what are the predictors?

The training dataset provides information including age, breed, color, sex, and outcome (such as adopted, euthanized, transferred, etc.)  for over 26000 shelter animals from the [Austin Animal Center](http://www.austintexas.gov/department/animal-services). The goal is to predict the outcome for each animal in the test data.

After reading in the training data with `daru`, we observe that there are five possible outcomes:

```ruby
require 'daru'
shelter_data = Daru::DataFrame.from_csv 'animal_shelter_train.csv'
shelter_data["OutcomeType"].to_a.uniq
# => ["Return_to_owner", "Euthanasia", "Adoption", "Transfer", "Died"]
```

and that most predictor variables (such as breed, color, animal type, etc.) are categorical.

Because multinomial logistic regression is not supported by statsample-glm, we fit five different one-vs-all logistic regression models instead. That is, one model has a 0-1-valued indicator vector of whether the animal got adopted as the response. The next model uses as the response variable a 0-1-valued indicator for whether the animal got euthanized. And likewise, for the remaining three models, the response variables signify whether the animal got reunited with its previous owner, or died of natural causes, or transferred. Obtaining a prediction from each of the five models, we will be able to assign each animal a "score" for each of the five possible outcomes.

For simplicity, and since this data analysis is just for demonstration purposes, we keep only the variables "AgeuponOutcome", "AnimalType", "Breed", "Color", and "SexuponOutcome" as predictors in the model.

## Preprocessing the training data

First, we get rid of observations (i.e., data frame rows) with missing values and of the variables (i.e., data frame columns), which won't be used in the subsequent analysis:

```ruby
shelter_data.delete_vectors *%W[AnimalID Name DateTime OutcomeSubtype]
shelter_data = shelter_data.filter_rows do
  |row| !row.has_missing_data?
end
```

Next, we transform "AgeuponOutcome", which is not given in a consistent unit, to a numeric variable:

```ruby
shelter_data['AgeuponOutcome'].map! do |age|
  num, unit = age.split
  num = num.to_f
  case unit
  when "year", "years"
    52.0 * num
  when "month", "months"
    4.5 * num
  when "week", "weeks"
    num
  when "day", "days"
    num / 7.0
  else
    raise "Unknown AgeuponOutcome unit!"
  end  
end
```

Then we tell the `Daru::DataFrame`, which variables should be treated as categorical:

```ruby
shelter_data.to_category 'OutcomeType', 'AnimalType', 'SexuponOutcome', 'Breed', 'Color'
```

Since the variable "Breed" has more than 1000 distinct values, which leads to model fitting problems, we recode it such that rare breeds are summarized into one category, "other" (arguably, there are much better, but much more complex, ways to summarize "Breed" into fewer categories, for example such as presented [here](https://www.kaggle.com/andraszsom/shelter-animal-outcomes/dog-breeds-dog-groups)):

```ruby
puts shelter_data['Breed'].to_a.uniq.length
# => 1380

other_breed = shelter_data['Breed'].categories.select { |i| shelter_data['Breed'].count(i) < 100 }
other_breed_hash = other_breed.zip(['other']*other_breed.size).to_h
shelter_data['Breed'].rename_categories other_breed_hash
shelter_data['Breed'].base_category = 'other'

puts shelter_data['Breed'].to_a.uniq.length
# => 28 
```

In the same way, we recode the variable "Color" into fewer categories (no potential dog owner can distinguish 366 colors anyway :stuck_out_tongue_closed_eyes:):

```ruby
puts shelter_data['Color'].to_a.uniq.length
# => 366

other_color = shelter_data['Color'].categories.select { |i| shelter_data['Color'].count(i) < 100 }
other_color_hash = other_color.zip(['other']*other_color.size).to_h
shelter_data['Color'].rename_categories other_color_hash
shelter_data['Color'].base_category = 'other'
shelter_data['Color'].frequencies

puts shelter_data['Color'].to_a.uniq.length
# => 43
```

Again, there are certainly more clever ways to summarize colors into a handful of meaningful categories, but this is for demonstration purposes only.

Finally, we save the preprocessed data frame as a CSV file:

```ruby
shelter_data.write_csv "animal_shelter_train_processed.csv"
```

## Generalized linear model fit and predictions

As described in the beginning, we fit a separate one-vs-all logistic regression model for each outcome type. Thus, to avoid repetition, the following shows the code for the model with outcome type adoption only. The four models for each of the other four outcome types are fit in exactly the same way.

We load the preprocessed training data, and define a dummy variable for outcome type adoption, to be used as the model response:

```ruby
require 'daru'
train_data = Daru::DataFrame.from_csv 'animal_shelter_train_processed.csv'
# define the 0-1-valued response variable
train_data.to_category 'OutcomeType'
train_data['Adoption'] = (train_data['OutcomeType'].contrast_code)['OutcomeType_Adoption']
```

Then we fit a GLM with `statsample-glm` using a formula language, familiar from R and Python, for model specification:

```ruby
require 'statsample-glm'
formula = 'Adoption~AnimalType+Breed+AgeuponOutcome+Color+SexuponOutcome'
glm_adoption = Statsample::GLM::Regression.new formula, train_data, :logistic, epsilon: 1e-2
```

Finally, we use the obtained GLM to compute predictions on test data (the test data didn't require much preprocessing, apart from the imputation of a couple missing age values)[^1]:

```ruby
test_data = Daru::DataFrame.from_csv 'animal_shelter_test_processed.csv'
adoption_pred = glm_adoption.predict test_data 
```

Unfortunately, `statsample-glm` is currently not optimized for computation on medium or big sized data. In the present case, where the design matrix is approximately of size $26000 \times 80$, the model fitting algorithm ran for a couple hours and used more memory than the 12 GB that my laptop has (so, I had to run the code on my university's computer cluster).

## That's it!

Out of curiosity I have actually submitted the obtained predictions to kaggle. The submission currently ranks 1090 out of 1451, as expected of such an unsophisticated GLM (see [the leaderboard](https://www.kaggle.com/c/shelter-animal-outcomes/leaderboard), submission is under name agisga).  At least I am not last (personal goal achieved :smiley:)! All scripts used for the presented data analysis can be found in [this github repository](https://github.com/agisga/animal_shelter_data). 

   [^1]: Update: After the kaggle competition has ended, I realized that I made the silly mistake of not transforming "Breed" and "Color" in the test data in the same way as I have done it in the training data. :confused:
