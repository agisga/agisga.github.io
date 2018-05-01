---
layout: post
title: Neural networks and deep learning &mdash; self-study and 2 presentations
tags:
- math
- python
---

Last month, after mentioning "deep learning" a few times to some professors, I suddenly found myself in a position where I had to prepare three talks about "deep learning" within just one month... :sweat_smile:
This is not to complain. I actually strongly enjoy studying the relevant theory, applying it to interesting datasets, and presenting what I have learned.
Besides, teaching may be the best way to learn.
However, it is quite funny. :laughing:
The deep learning hype is too real. :trollface:

In this post I want to share my presentation slides (see below), some other resources, and some thoughts, in case any of that can be helpful to other deep learning beginners.[^1]

Neural networks (NNs) and deep learning (DL, also deep NNs, or DNNs) are not my research area, but currently it is one of my main side-interests.
(D)NNs are truly fascinating to somebody with substantial experience in statistics or the more conventional machine learning (like myself). Initially it seems counterintuitive how these extremely overparametrized models are even supposed to work, but then you fit those models, and their performance is so good that it seems to border on magic. :crystal_ball:

## Slides

These `html` slides were created with the excellent [`reveal.js`](https://github.com/hakimel/reveal.js/).

* [__An introduction to neural networks and deep learning__](http://www.alexejgossmann.com/reveal.js/20180426-Math-Modeling-Guest-Lecture.html) &mdash; guest lecture for a mathematical modeling class in the department of biomedical engineering at Tulane (with live-demos using Google Cloud, see slides).
* [__A survey on Deep Learning in Medical Image Analysis__](http://www.alexejgossmann.com/reveal.js/20180411-Journal-Club.html) &mdash; journal club presentation based on a paper by Litjens, Kooi, Bejnordi, et al. This was presented as a 2-part talk.

## My favorite learning resources

I was able give the above presentations, because I did a good amount of self-study on NN and DL in my free time. Here are some of the resources that I have used, and that I highly recommend:

* I worked through the [fast.ai](http://www.fast.ai/) MOOC ["Practical Deep Learning For Coders, Part 1"](http://course.fast.ai/) by Jeremy Howard and Rachel Thomas. It is not spoon-feeding (if you want to actually understand what's going on), but highly recommended as a starting point. [Jeremy Howard](https://en.wikipedia.org/wiki/Jeremy_Howard_(entrepreneur)) is fantastic at giving clear and simple explanations to complex concepts, and the provided Jupyter Notebooks are excellent to get started with the practical application of DL.
* At the same time I swallowed [Michael Nielsen](https://en.wikipedia.org/wiki/Michael_Nielsen)'s ["Neural Networks and Deep Learning"](http://neuralnetworksanddeeplearning.com/) book, which was a pleasure to read.
* Then I participated in the IPAM/UCLA workshop ["New Deep Learning Techniques"](https://www.ipam.ucla.edu/programs/workshops/new-deep-learning-techniques/?tab=schedule) in February (videos and slides available on the linked site), which blew my mind by covering so many different perspectives which I was not aware of.
* Currently I am working through the [lectures](https://www.youtube.com/playlist?list=PL3FW7Lu3i5JvHM8ljYj-zLfQRF3EO8sYv) and [assignments](https://cs231n.github.io/) from Stanford's [CS231n](https://cs231n.github.io/) together with the [ods.ai](http://ods.ai/) community (see [passing cs231n together](https://github.com/Yorko/mlcourse_open/wiki/Passing-cs231n-together)). Feel free to contact me if you want to discuss the CS231n assignments in the near future.
* During the entire time, I was also (slowly) working on my Python skills, as well as figuring out how to set up AWS, and Google Cloud GPU instances. Unfortunately, figuring out and setting up the required drivers, libraries, etc. is still very non-trivial. For many people I meet in academia this may even be the greatest bottleneck towards deep learning. [This is the setup I am currently using](https://github.com/agisga/coding_notes/blob/master/google_cloud.md).

These resources have worked very well for me. My background is mostly academic, and includes experience in statistical modeling, (non-deep) machine learning, an all-but-dissertation status in a math PhD program, and some domain knowledge in medical imaging.
While it is helpful with some of the above, none of that is really that important or necessary.
Though some math is definitely needed, it does not need to be at a PhD level.
Medical or biological knowledge helps only if those are the applications of DL that you seek out (which I do).
Understanding some basic machine learning and data science practices certainly helps, but the relevant material is covered in all DL courses that I have tried.
However, what helps immensely in any case is proficiency with git, Github, Linux, as well as general programming and data processing skills.

--------------------------------

[^1]: I hope that still being close to the beginning of my DL journey makes me in some way more helpful to the absolute beginner (which I too was just a few months ago)... Maybe right now I have some perspective that may get lost should I become a DL expert...
