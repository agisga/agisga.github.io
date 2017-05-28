---
layout: post
title: Tired of doing real math 2 &mdash; grad school and coffee consumption
date: 2017-02-15 02:35:00 -06:00
tags:
- tired of doing real math
- visualization
- r
- productivity
- academia
---

Lately I notice a sharp increase in my coffee consumption (reading [Howard Schultz's Starbucks book](https://www.amazon.com/Pour-Your-Heart-Into-Starbucks/dp/0786883561/ref=sr_1_3?ie=UTF8&qid=1487141175&sr=8-3&keywords=howard+schultz), which is actually quite good by the way, does not help either :grimacing:). Having recently transitioned into a new PhD program I started wondering whether my increased coffee consumption has something to do with my higher stress levels in the last few weeks, and how that conjecture generalizes to the rest of my grad school experience. To answer that question I decided to take a look at how much money I have spent at coffee houses over the last few years. ...Also, I'm right now over-caffeinated at 1:40am and I have nothing better to do anyway. :smile:

Luckily, [chase.com](https://www.chase.com/) allows me to download the transaction history of my account as a CSV file (though it's limited to at most the past two years for some reason). Also luckily, light regex skills in R and the [tidyverse](https://blog.rstudio.org/2016/09/15/tidyverse-1-0-0) packages is all that's needed to make sense of these data!

### Number of transactions per month

First I take a look at the number of transactions performed with my debit card at New Orleans' coffee houses between 2/13/2015 and 2/13/2017. On the time axis I mark some major occurrences in my academic life.

![Number of transactions performed with my debit card at New Orleans' coffee houses per month](/images/grad_school_coffee/Coffees_per_month.png?raw=true "Coffees per month")

Indeed it seems that I frequent coffee places more often at times when I am more stressed, such as those preceding a paper submission or a qualifying exam (or when my wife is out of town for a month :grimacing:); and I appreciate some variety with respect to the places where I get coffee or tea.

### Yearly statistics

There seems to be a clear increasing trend in the above bar graph. The trend becomes especially clear when I look at how much money I left at coffee places last year compared to the year 2015. There might be a progressing addiction here :sweat_smile:... 

![Amount spent at coffee places per year](/images/grad_school_coffee/Yearly_total_spent.png?raw=true "Yearly $$$ spent at coffee places")

### Time series of daily spending

The preceding comparison of the yearly amounts does not reveal anything regarding the relationship of my coffee / tea consumption with my stress levels and events in my academic life. Therefore I generated a time series containing my daily coffee house spendings for the considered two-year period. Below is a visualization of this time series smoothed with a simple moving average of order seven (using the [R package TTR](https://cran.r-project.org/package=TTR)).

![Time series of daily amounts spent at coffee places](/images/grad_school_coffee/SMA.png?raw=true "Daily spending at coffee places")

The finer representation of the data allows some further conclusions:

* It shows a lower coffee consumption during parts of the summer and winter breaks.
* Once again there seems to be a clear association between stressful academic events and an increased coffee (or tea) consumption preceding them.

### That's it. Time to go to bed.

Because I know from [a phdcomics cartoon](http://www.phdcomics.com/comics/archive.php?comicid=1415) that caffeine combined with a lack of sleep will turn me into a robot rather than into somebody who might eventually finish graduate school...
