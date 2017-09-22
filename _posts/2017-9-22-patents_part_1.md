---
layout: post
title: Mining USPTO full text patent data - Analysis of machine learning and AI related patents granted in 2017 so far - Part 1
author: Alexej Gossmann
tags:
- r
- visualization
- data analysis
---

[The United States Patent and Trademark office (USPTO)](https://www.uspto.gov) provides *immense* amounts of data (the data I used are in the form of XML files). After coming across these datasets, I thought that it would be a good idea to explore where and how my areas of interest fall into the intellectual property space; my areas of interest being machine learning (ML), data science, and  artificial intelligence (AI).

I started this exploration by downloading the full text data (excluding images) for all patents that were assigned by the USPTO within the year 2017 up to the time of writing ([Patent Grant Full Text Data/XML for the year 2017 through the week of Sept 12 from the USPTO Bulk Data Storage System](https://bulkdata.uspto.gov/data/patent/grant/redbook/fulltext/2017/)).

In this blog post - "Part 1" - I address questions such as: How many ML and AI related patents were granted? Who are the most prolific inventors? The most frequent patent assignees? Where are inventions made? And when? Is the number of ML and AI related patents increasing over time? How long does it take to obtain a patent for a ML or AI related invention? Is the patent examination time shorter for big tech companies? etc.

"Part 2" will be an in depth analysis of the language used in patent titles, descriptions, and claims, and "Part 3" will be on experimentation with with deep neural nets applied to the patents' title, description, and claims text.

## Identifying patents related to machine learning and AI

First, I curated a patent full text dataset consisting of "machine learning and AI related" patents.
I am not just looking for instances where actual machine learning or AI algorithms were patented; I am looking for inventions which are *related to ML or AI in any/some capacity*. That is, I am interested in patents where machine learning, data mining, predictive modeling, or AI is *utilized as a part of the invention in any way whatsoever*. The subset of relevant patents was determined by a keyword search as specified by the following definition.

__Definition:__ For the purposes of this blog post, *a machine learning or AI related patent* is a patent that contains at least one of the keywords
*"machine learning", "deep learning", "neural network", "artificial intelligence", "statistical learning", "data mining", or "predictive model"*
in its invention title, description, or claims text (while of course accounting for capitalization, pluralization, etc.).[^keywords]

With this keyword matching approach a total of 6665 patents have been selected. The bar graph below shows how many times each keyword got matched.

![plot of keyword match frequencies](/images/2017-9-12-patents_part_1/keyword_match_freq.png)

Interestingly the term "neural network" is even more common than the more general terms "machine learning" and "artificial intelligence".

### Some example patents

Here are three (randomly chosen) patents from the resulting dataset. For each printed are the invention title, the patent assignee, as well as one instance of the keyword match within the patent text.

{% highlight text %}
## $`2867`
## [1] "Fuselage manufacturing system"
## [2] "THE BOEING COMPANY"
## [3] "... using various techniques. For example, at least
##      one of an artificial intelligence program, a
##      knowledgebase, an expert ..."
##
## $`1618`
## [1] "Systems and methods for validating wind farm
##      performance measurements"
## [2] "General Electric Company"
## [3] "... present disclosure leverages and fuses
##      accurate available sensor data using machine
##      learning algorithms. That is, the more ..."
##
## $`5441`
## [1] "Trigger repeat order notifications"
## [2] "Accenture Global Services Limited"
## [3] "... including user data obtained from a user
##      device; obtaining a predictive model that
##      estimates a likelihood of ..."
{% endhighlight %}

And here are three examples of (randomly picked) patents that contain the relevant keywords directly in their invention title.

{% highlight text %}
## $`5742`
## [1] "Adaptive demodulation method and apparatus using an
##      artificial neural network to improve data recovery
##      in high speed channels"
## [2] "Kelquan Holdings Ltd."
## [3] "... THE INVENTION\nh-0002\n1 The present invention
##      relates to a neural network based integrated
##      demodulator that mitigates ..."
##
## $`3488`
## [1] "Cluster-trained machine learning for image processing"
## [2] "Amazon Technologies, Inc."
## [3] "... BACKGROUND\nh-0001\n1 Artificial neural networks,
##      especially deep neural network ..."
##
## $`3103`
## [1] "Methods and apparatus for machine learning based
##      malware detection"
## [2] "Invincea, Inc."
## [3] "... a need exists for methods and apparatus that can
##      use machine learning techniques to reduce the amount ..."
{% endhighlight %}

## Who holds these patents (inventors and assignees)?

The first question I would like to address is who files most of the machine learning and AI related patents.

Each patent specifies one or several *inventors*, i.e., the individuals who made the patented invention, and a patent *assignee* which is typically the inventors' employer company that holds the rights to the patent. The following bar graph visualizes the top 20 most prolific inventors and the top 20 most frequent patent assignees among the analyzed ML and AI related patents.

![plot of chunk unnamed-chunk-5](/images/2017-9-12-patents_part_1/unnamed-chunk-5-1.png)

It isn't surprising to see this list of companies. The likes of IBM, Google, Amazon, Microsoft, Samsung, and AT&T rule the machine learning and AI patent space. I have to admit that I don't recognize any of the inventors' names (but it might just be me not being familiar enough with the ML and AI community).

There are a number of interesting follow-up questions which for now I leave unanswered (hard to answer without additional data):

* What is the count of ML and AI related patents by industry or type of company (e.g., big tech companies vs. startups vs. reserach universities vs. government)?
* Who is deriving the most financial benefit by holding ML or AI related patents (either through licensing or by driving out the competition)?

## Where do these inventions come from (geographically)?

Even though the examined patents were filed in the US, some of the inventions may have been made outside of the US.
In fact, the data includes specific geographic locations for each patent, so I can map in which cities within the US and the world inventors are most active.
The following figure is based on where the inventors are from, and shows the most active spots. Each point corresponds to the total number of inventions made at that location (though note that the color axis is a log10 scale, and so is the point size).

![plot of chunk unnamed-chunk-16](/images/2017-9-12-patents_part_1/locations.png)

The results aren't that surprising.
However, we see that most (ML and AI related) inventions patented with the USPTO were made in the US. I wonder if inventors in other countries prefer to file patents in their home countries' patent offices rather the in the US.

Alternatively, we can also map the number of patents per inventors' origin countries.

![plot of chunk unnamed-chunk-17](/images/2017-9-12-patents_part_1/countries.png)

Sadly, there seem to be entire groups of countries (e.g., almost the entire African continent) which seem to be excluded from the USPTO's patent game, at least with respect to machine learning and AI related inventions.
Whether it is a lack of access, infrastructure, education, political treaties or something else is an intriguing question.

## Patent application and publication dates, and duration of patent examination process

Each patent has a *date of filing* and an *assignment date* attached to it. Based on the provided dates one can try to address questions such as:
When were these patents filed? Is the number of ML and AI related patents increasing over time? How long did it usually take from patent filing to assignment? And so on.

For the set of ML and AI related patents *that were granted between Jan 3 and Sept 12 2017* the following figure depicts...

* ...in the top panel: number of patents (y-axis) per their original *month of filing* (x-axis),
* ...in the bottom panel: the number of patents (y-axis) that were *assigned* (approved) per week (x-axis) in 2017 so far.


![plot of chunk unnamed-chunk-7](/images/2017-9-12-patents_part_1/unnamed-chunk-7-1.png)



The patent publication dates plot suggests that the number of ML and AI related patents seems to be increasing slightly throughout the year 2017.
The patent application dates plot suggests that the patent examination phase for the considered patents takes about 2.5 years. In fact the average time from patent filing to approval is 2.83 years with a standard deviation of 1.72 years in this dataset (that is, among the considered ML and AI related patents in 2017). However, the range is quite extensive spanning 0.24-12.57 years.

The distribution of the duration from patent filing date to approval is depicted by following figure.

![plot of chunk unnamed-chunk-9](/images/2017-9-12-patents_part_1/unnamed-chunk-9-1.png)

So, what are some of the inventions that took longest to get approved? Here are the five patents with the longest examination periods:

* "Printing and dispensing system for an electronic gaming device that provides an undisplayed outcome" (~12.57 years to approval; assignee: Aim Management, Inc.)
* "Apparatus for biological sensing and alerting of pharmaco-genomic mutation" (~12.24 years to approval; assignee: NA)
* "System for tracking a player of gaming devices" (~12.06 years to approval; assignee: Aim Management, Inc.)
* "Device, method, and computer program product for customizing game functionality using images" (~11.72 years to approval; assignee: NOKIA TECHNOLOGIES OY)
* "Method for the spectral identification of microorganisms" (~11.57 years to approval; assignee: MCGILL UNIVERSITY, and HEALTH CANADA)

Each of these patents is related to either gaming or biotech. I wonder if that's a coincidence...

We can also look at the five patents with the shortest approval time:

* "Home device application programming interface" (~91 days to approval; assignee: ESSENTIAL PRODUCTS, INC.)
* "Avoiding dazzle from lights affixed to an intraoral mirror, and applications thereof" (~104 days to approval; assignee: DENTAL SMARTMIRROR, INC.)
* "Media processing methods and arrangements" (~106 days to approval; assignee: Digimarc Corporation)
* "Machine learning classifier that compares price risk score, supplier risk score, and item risk score to a threshold" (~111 days to approval; assignee: ACCENTURE GLOBAL SOLUTIONS LIMITED)
* "Generating accurate reason codes with complex non-linear modeling and neural networks" (~111 days to approval; assignee: SAS INSTITUTE INC.)

Interstingly the patent approved in the shortest amount of time among all 6665 analysed (ML and AI related) patents is some smart home thingy from [Andy Rubin's](https://en.wikipedia.org/wiki/Andy_Rubin) hyped up company Essential.

### Do big tech companies get their patents approved faster than other companies (e.g., startups)?

The following figure separates the patent approval times according to the respective assignee company, considering several of the most well known tech giants.

![plot of chunk unnamed-chunk-15](/images/2017-9-12-patents_part_1/unnamed-chunk-15-1.png)

Indeed some big tech companies, such as AT&T or Samsung, manage to push their patent application though the USPTO process much faster than most other companies. However, there are other tech giants, such as Microsoft, which on average take longer to get their patent applications approved than even the companies in category "Other". Also noteworthy is the fact that big tech companies tend to have fewer outliers regarding the patent examination process duration than companies in the category "Other".

Of course it would also be interesting to categorize all patent assignees into categories like "Startup", "Big Tech", "University", or "Government", and compare the typical duration of the patent examination process between such groups. However, it's not clear to me how to establish such categories without collecting additional data on each patent assignee, which at this point I don't have time for :stuck_out_tongue:.

## Conclusion

There is definitely a lot of promise in the USPTO full text patent data.
Here I have barely scratched the surface, and I hope that I will find the time to play around with these data some more.
The end goal is, of course, to replace the patent examiner with an AI trained on historical patent data. :stuck_out_tongue_closed_eyes:

--------------------

[^keywords]: There are two main aspects to my reasoning as to this particular choice of keywords. (1) I wanted to keep the list relatively short in order to have a more specific search, and (2) I tried to avoid keywords which may generate false positives (e.g., the term "AI" would match all sorts of codes present in the patent text, such as "123456789 AI N1"). In no way am I claiming that this is a perfect list of keywords to identify ML and AI related patents, but I think that it's definitely a good start.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work (blog post and included figures) is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.
