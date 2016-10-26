---
layout: post
title: Tired of doing real math 1 &mdash; some visualizations of Hillary Clinton and Donald Trump tweets
tags:
- tired of doing real math
- visualization
- r
---

![Word cloud from Trump and Clinton tweets](/images/clinton_trump_tweets/trump_clinton_tweets_word_cloud.png?raw=true "Word cloud from Trump and Clinton tweets")

As a grad student working primarily on statistical methodology, I regularly experience phases of total disillusionment with math/stats.  Recently I realized that when I don't feel like doing "real" math for prolonged periods of time, I instead can work on data analyses, which are mathematically unsophisticated (and possibly of low mathematical quality), but rather focus on simple techniques and/or visualizations of interesting data.
[Somebody at kaggle.com conveniently provides tweet data of this year's two major presidential candidates.](https://www.kaggle.com/benhamner/clinton-trump-tweets) Here, I very briefly visually investigate this dataset.

<!--The goal, I guess, is to understand what messages the candidates convey with their tweets. But I won't go deep into interpretation of the results or political discussion. I first take a look at the top ten most popular tweets of either candidate, where tweet popularity is defined as the sum of the number of retweets and the number of favorites that a tweet has received. After some minimal data preprocessing, I plot a bar graph of retweet and favorite count for the top ten tweets, and overlay the tweet text on top of the bars in the graph. This results in the following visualizations.-->

![Visualization of Trump's top ten tweets](/images/clinton_trump_tweets/trump_top_10.png?raw=true "Visualization of Trump's top ten tweets")
[(Larger image)]( {{ site.baseurl }}/images/clinton_trump_tweets/trump_top_10.png)

![Visualization of Clinton's top ten tweets](/images/clinton_trump_tweets/clinton_top_10.png?raw=true "Visualization of Clinton's top ten tweets")
[(Larger image)]( {{ site.baseurl }}/images/clinton_trump_tweets/clinton_top_10.png)

### Code

* [I have uploaded a script producing very similar word clouds as the above ones to kaggle.com.](https://www.kaggle.com/agisga/d/benhamner/clinton-trump-tweets/word-clouds) Arguably a word cloud is far from being a good statistical tool, but it's fun. Besides, it gave me an opportunity to improve my regex skills, and to learn about palettes and fonts in R (<http://colorbrewer2.org> is awesome!).
* [I have also written a script producing the above visualizations of the top ten tweets of either presidential candidate](https://www.kaggle.com/agisga/d/benhamner/clinton-trump-tweets/top-10-tweets), learning more about ggplot2 in the process.
