---
layout: post
title: dplyr basics
tags:
- r
---

![Pliers](/images/pliers.jpg?raw=true "Lots of pliers")

This blog post demonstrates the usage of the R package [dplyr](https://cran.r-project.org/web/packages/dplyr/index.html). It turns out that dplyr is intuitive to the point where I probably won't ever need to look back at this summary. A nice and very concise [dplyr and tidyr cheat sheet](http://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf) is available from RStudio. 

The following was compiled in [rmarkdown](http://rmarkdown.rstudio.com/) [[:page_facing_up: download .Rmd file]({{ site.baseurl }}/public_files/dplyr_basics.Rmd)].


{% highlight r %}
library(dplyr)
library(gapminder)
{% endhighlight %}

The [gapminder](http://www.gapminder.org/data/) data will be used for demonstration purposes.


{% highlight r %}
class(gapminder)
{% endhighlight %}



{% highlight text %}
## [1] "tbl_df"     "tbl"        "data.frame"
{% endhighlight %}

* `glimpse` -- a better `str`


{% highlight r %}
glimpse(gapminder)
{% endhighlight %}



{% highlight text %}
## Observations: 1,704
## Variables: 6
## $ country   <fctr> Afghanistan, Afghanistan, Afghanistan, Afghani...
## $ continent <fctr> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia...
## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987,...
## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438,...
## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460,...
## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.981...
{% endhighlight %}

## dplyr verbs

* `sample_frac` -- sample a given percentage of rows


{% highlight r %}
sample_frac(gapminder, 0.5)
{% endhighlight %}



{% highlight text %}
## # A tibble: 852 × 6
##        country continent  year lifeExp      pop gdpPercap
##         <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
## 1       Taiwan      Asia  1977  70.590 16785196  5596.520
## 2  Puerto Rico  Americas  1972  72.160  2847132  9123.042
## 3      Croatia    Europe  1957  64.770  3991242  4338.232
## 4       Panama  Americas  2002  74.712  2990875  7356.032
## 5       Canada  Americas  1992  77.950 28523502 26342.884
## 6       Poland    Europe  1982  71.320 36227381  8451.531
## 7  Puerto Rico  Americas  1957  68.540  2260000  3907.156
## 8        Chile  Americas  1982  70.565 11487112  5095.666
## 9      Belgium    Europe  1957  69.240  8989111  9714.961
## 10     Myanmar      Asia  1967  49.379 25870271   349.000
## # ... with 842 more rows
{% endhighlight %}

* `sample_n` -- sample n rows


{% highlight r %}
set.seed(2016)
tiny <- sample_n(gapminder, 3)
tiny
{% endhighlight %}



{% highlight text %}
## # A tibble: 3 × 6
##     country continent  year lifeExp      pop gdpPercap
##      <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
## 1  Colombia  Americas  1982  66.653 27764644  4397.576
## 2    Canada  Americas  1967  72.130 20819767 16076.588
## 3 Sri Lanka      Asia  1972  65.042 13016733  1213.396
{% endhighlight %}

* `rename` -- rename columns 


{% highlight r %}
rename(tiny, GDP = gdpPercap, population = pop)
{% endhighlight %}



{% highlight text %}
## # A tibble: 3 × 6
##     country continent  year lifeExp population       GDP
##      <fctr>    <fctr> <int>   <dbl>      <int>     <dbl>
## 1  Colombia  Americas  1982  66.653   27764644  4397.576
## 2    Canada  Americas  1967  72.130   20819767 16076.588
## 3 Sri Lanka      Asia  1972  65.042   13016733  1213.396
{% endhighlight %}

* `select` -- select columns from the data frame


{% highlight r %}
select(tiny, starts_with("y"), pop, matches("^co.*"))
{% endhighlight %}



{% highlight text %}
## # A tibble: 3 × 4
##    year      pop   country continent
##   <int>    <int>    <fctr>    <fctr>
## 1  1982 27764644  Colombia  Americas
## 2  1967 20819767    Canada  Americas
## 3  1972 13016733 Sri Lanka      Asia
{% endhighlight %}

* `filter` -- select rows from the data frame, producing a subset


{% highlight r %}
# filter(tiny, lifeExp > 60 & year < 1980)
# or equivalent:
filter(tiny, lifeExp > 60, year < 1980)
{% endhighlight %}



{% highlight text %}
## # A tibble: 2 × 6
##     country continent  year lifeExp      pop gdpPercap
##      <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>
## 1    Canada  Americas  1967  72.130 20819767 16076.588
## 2 Sri Lanka      Asia  1972  65.042 13016733  1213.396
{% endhighlight %}

* `slice` -- select rows from data frame by index, producing a subset


{% highlight r %}
slice(gapminder, 300:303)
{% endhighlight %}



{% highlight text %}
## # A tibble: 4 × 6
##    country continent  year lifeExp        pop gdpPercap
##     <fctr>    <fctr> <int>   <dbl>      <int>     <dbl>
## 1    China      Asia  2007  72.961 1318683096  4959.115
## 2 Colombia  Americas  1952  50.643   12350771  2144.115
## 3 Colombia  Americas  1957  55.118   14485993  2323.806
## 4 Colombia  Americas  1962  57.863   17009885  2492.351
{% endhighlight %}

* `mutate` -- add new columns that can be functions of existing columns


{% highlight r %}
mutate(tiny, newVar = (lifeExp / gdpPercap), newcol = 3:1)
{% endhighlight %}



{% highlight text %}
## # A tibble: 3 × 8
##     country continent  year lifeExp      pop gdpPercap      newVar
##      <fctr>    <fctr> <int>   <dbl>    <int>     <dbl>       <dbl>
## 1  Colombia  Americas  1982  66.653 27764644  4397.576 0.015156760
## 2    Canada  Americas  1967  72.130 20819767 16076.588 0.004486649
## 3 Sri Lanka      Asia  1972  65.042 13016733  1213.396 0.053603296
## # ... with 1 more variables: newcol <int>
{% endhighlight %}



{% highlight r %}
tiny <- mutate(tiny, newVar = (lifeExp / gdpPercap), newVar2 = newVar^2)
glimpse(tiny)
{% endhighlight %}



{% highlight text %}
## Observations: 3
## Variables: 8
## $ country   <fctr> Colombia, Canada, Sri Lanka
## $ continent <fctr> Americas, Americas, Asia
## $ year      <int> 1982, 1967, 1972
## $ lifeExp   <dbl> 66.653, 72.130, 65.042
## $ pop       <int> 27764644, 20819767, 13016733
## $ gdpPercap <dbl> 4397.576, 16076.588, 1213.396
## $ newVar    <dbl> 0.015156760, 0.004486649, 0.053603296
## $ newVar2   <dbl> 2.297274e-04, 2.013002e-05, 2.873313e-03
{% endhighlight %}

* `transmute` -- add new columns that can be functions of the existing columns, and drop the existing columns


{% highlight r %}
tiny <- transmute(tiny, id = 1:3, country, continent,
                  newVarSqrt = sqrt(newVar), pop)
tiny
{% endhighlight %}



{% highlight text %}
## # A tibble: 3 × 5
##      id   country continent newVarSqrt      pop
##   <int>    <fctr>    <fctr>      <dbl>    <int>
## 1     1  Colombia  Americas 0.12311279 27764644
## 2     2    Canada  Americas 0.06698245 20819767
## 3     3 Sri Lanka      Asia 0.23152386 13016733
{% endhighlight %}

* `arrange` -- reorder rows


{% highlight r %}
arrange(tiny, pop)
{% endhighlight %}



{% highlight text %}
## # A tibble: 3 × 5
##      id   country continent newVarSqrt      pop
##   <int>    <fctr>    <fctr>      <dbl>    <int>
## 1     3 Sri Lanka      Asia 0.23152386 13016733
## 2     2    Canada  Americas 0.06698245 20819767
## 3     1  Colombia  Americas 0.12311279 27764644
{% endhighlight %}



{% highlight r %}
arrange(gapminder, desc(year), lifeExp)
{% endhighlight %}



{% highlight text %}
## # A tibble: 1,704 × 6
##                     country continent  year lifeExp      pop
##                      <fctr>    <fctr> <int>   <dbl>    <int>
## 1                 Swaziland    Africa  2007  39.613  1133066
## 2                Mozambique    Africa  2007  42.082 19951656
## 3                    Zambia    Africa  2007  42.384 11746035
## 4              Sierra Leone    Africa  2007  42.568  6144562
## 5                   Lesotho    Africa  2007  42.592  2012649
## 6                    Angola    Africa  2007  42.731 12420476
## 7                  Zimbabwe    Africa  2007  43.487 12311143
## 8               Afghanistan      Asia  2007  43.828 31889923
## 9  Central African Republic    Africa  2007  44.741  4369038
## 10                  Liberia    Africa  2007  45.678  3193942
## # ... with 1,694 more rows, and 1 more variables: gdpPercap <dbl>
{% endhighlight %}

* `summarize` -- create collapsed summaries of a data frame by applying functions to columns 


{% highlight r %}
summarize(gapminder, aveLife = mean(lifeExp))
{% endhighlight %}



{% highlight text %}
## # A tibble: 1 × 1
##    aveLife
##      <dbl>
## 1 59.47444
{% endhighlight %}

* `distinct` -- find distinct rows, for repetitive data


{% highlight r %}
tiny2 <- tiny[c(1,1,2,2), ]
dim(tiny2)
{% endhighlight %}



{% highlight text %}
## [1] 4 5
{% endhighlight %}



{% highlight r %}
distinct(tiny2)
{% endhighlight %}



{% highlight text %}
## # A tibble: 2 × 5
##      id  country continent newVarSqrt      pop
##   <int>   <fctr>    <fctr>      <dbl>    <int>
## 1     1 Colombia  Americas 0.12311279 27764644
## 2     2   Canada  Americas 0.06698245 20819767
{% endhighlight %}



{% highlight r %}
n_distinct(tiny2)
{% endhighlight %}



{% highlight text %}
## [1] 2
{% endhighlight %}

### Chaining

#### Base-R-style


{% highlight r %}
set.seed(2016)
sample_n(filter(gapminder, continent == "Asia" & lifeExp < 65), 2)
{% endhighlight %}



{% highlight text %}
## # A tibble: 2 × 6
##    country continent  year  lifeExp       pop gdpPercap
##     <fctr>    <fctr> <int>    <dbl>     <int>     <dbl>
## 1    China      Asia  1957 50.54896 637408000   575.987
## 2 Cambodia      Asia  1972 40.31700   7450606   421.624
{% endhighlight %}

#### Using pipes


{% highlight r %}
set.seed(2016)
gapminder %>% filter(continent == "Asia") %>% filter(lifeExp < 65) %>% sample_n(2)
{% endhighlight %}



{% highlight text %}
## # A tibble: 2 × 6
##    country continent  year  lifeExp       pop gdpPercap
##     <fctr>    <fctr> <int>    <dbl>     <int>     <dbl>
## 1    China      Asia  1957 50.54896 637408000   575.987
## 2 Cambodia      Asia  1972 40.31700   7450606   421.624
{% endhighlight %}

### More verbs

* `group_by` -- convert the data frame into a grouped data frame, where the operations are performed by group 


{% highlight r %}
gapminder %>% group_by(continent) %>%
  summarize(aveLife = mean(lifeExp), count = n(),
            countries = n_distinct(country))
{% endhighlight %}



{% highlight text %}
## # A tibble: 5 × 4
##   continent  aveLife count countries
##      <fctr>    <dbl> <int>     <int>
## 1    Africa 48.86533   624        52
## 2  Americas 64.65874   300        25
## 3      Asia 60.06490   396        33
## 4    Europe 71.90369   360        30
## 5   Oceania 74.32621    24         2
{% endhighlight %}


{% highlight r %}
gapminder %>% group_by(continent) %>% tally
{% endhighlight %}



{% highlight text %}
## # A tibble: 5 × 2
##   continent     n
##      <fctr> <int>
## 1    Africa   624
## 2  Americas   300
## 3      Asia   396
## 4    Europe   360
## 5   Oceania    24
{% endhighlight %}

### Join multiple data frames

Example originally from <http://stat545.com/bit001_dplyr-cheatsheet.html>


{% highlight r %}
superheroes <- c("name, alignment, gender, publisher",
                 "Magneto, bad, male, Marvel",
                 "Storm, good, female, Marvel",
                 "Mystique, bad, female, Marvel",
                 "Batman, good, male, DC",
                 "Joker, bad, male, DC",
                 "Catwoman, bad, female, DC",
                 "Hellboy, good, male, Dark Horse Comics")
superheroes <- read.csv(text = superheroes, strip.white = TRUE, as.is=TRUE)
publishers <- c("publisher, yr_founded",
                "       DC, 1934",
                "   Marvel, 1939",
                "    Image, 1992")
publishers <- read.csv(text = publishers, strip.white = TRUE, as.is=TRUE)
{% endhighlight %}

#### Inner vs left vs full join

* `inner_join`


{% highlight r %}
inner_join(superheroes, publishers)
{% endhighlight %}



{% highlight text %}
## Joining, by = "publisher"
{% endhighlight %}



{% highlight text %}
##       name alignment gender publisher yr_founded
## 1  Magneto       bad   male    Marvel       1939
## 2    Storm      good female    Marvel       1939
## 3 Mystique       bad female    Marvel       1939
## 4   Batman      good   male        DC       1934
## 5    Joker       bad   male        DC       1934
## 6 Catwoman       bad female        DC       1934
{% endhighlight %}

* `left_join`


{% highlight r %}
left_join(superheroes, publishers)
{% endhighlight %}



{% highlight text %}
## Joining, by = "publisher"
{% endhighlight %}



{% highlight text %}
##       name alignment gender         publisher yr_founded
## 1  Magneto       bad   male            Marvel       1939
## 2    Storm      good female            Marvel       1939
## 3 Mystique       bad female            Marvel       1939
## 4   Batman      good   male                DC       1934
## 5    Joker       bad   male                DC       1934
## 6 Catwoman       bad female                DC       1934
## 7  Hellboy      good   male Dark Horse Comics         NA
{% endhighlight %}

* `full_join`


{% highlight r %}
full_join(superheroes, publishers)
{% endhighlight %}



{% highlight text %}
## Joining, by = "publisher"
{% endhighlight %}



{% highlight text %}
##       name alignment gender         publisher yr_founded
## 1  Magneto       bad   male            Marvel       1939
## 2    Storm      good female            Marvel       1939
## 3 Mystique       bad female            Marvel       1939
## 4   Batman      good   male                DC       1934
## 5    Joker       bad   male                DC       1934
## 6 Catwoman       bad female                DC       1934
## 7  Hellboy      good   male Dark Horse Comics         NA
## 8     <NA>      <NA>   <NA>             Image       1992
{% endhighlight %}
