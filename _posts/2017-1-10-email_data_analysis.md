---
layout: post
title: Email data analysis: responsiveness of academic advisors
tags:
- visualization
- ruby
- r
---

How to make a professor reply to email? That's a question I have asked myself (and my fellow graduate students) too many times since joining the math graduate program at Tulane University.[^1] The problem becomes especially severe, when the unresponsive professor is your PhD advisor.

What's even more frustrating is that the lack of communication is always regarded as the student's fault. The unresponsiveness of a professor, which leads to a general lack of communication, and a resulting absence of any meaningful conversation, is usually denied by the professor (and often even by other professors who are extraneous to the situation). In fact, regarding my latest experience with an unresponsive PhD co-advisor (Advisor1 in the analysis below), other committee members suggested that it is *me* who is not communicating enough, implying that it is *my* unwillingness to communicate that lies at the root of all possible problems with my PhD progress or the student-advisor relationship. Of course, I disagree. And anyway, as scientists we should trust in data, not opinion. Luckily, my email correspondence is readily available for analysis.

In the following I perform a simple data analysis of my email correspondence with three of my past and present academic advisors at Tulane University. To avoid using real names, in what follows I refer to the three individuals as *Advisor1*, *Advisor2*, and *Advisor3*.

For the case that somebody[^2] who comes across this write-up would like to perform a similar data analysis, I made my entire code available online, and it is linked at each respective step of the analysis (real names, email addresses, and passwords were removed for privacy (obviously)).

### Number of emails exchanged

I started working with Advisor1 and Advisor2 as my co-advisors on 9/11/2014, and the current arrangement was ended on 12/19/2016 ().[^3] Thus, I only consider emails exchanged with them during that time interval. Prior to that, Advisor3 worked with me for about a year, until deciding to quit academia.

The following bar graph shows the number of emails exchanged with Advisor1

TODO:image

Evidently, I have sent almost three times as many emails to Advisor1, as I have received. Even though, this already shows a great level of unresponsiveness from Advisor1, let's see how it compares to the other two advisors.

TODO:image

The exchange with Advisor3 is approximately even. However, Advisor2 has sent many more emails to me than I have sent back. This is explained by the fact that Advisor2 sends out current research papers to the entire research group almost weekly, which I highly appreciate.

### Estimated reply probability

The probability to receive a reply email can be easily estimated by a sample proportion.
I use a very crude estimate: If $R$ is the number of emails from Advisor$k$ ($k = 1,2,3$), which are marked as replies to *any* email (not even necessarily an email from me), and $N$ is the total number of emails that I sent to Advisor$k$, then I estimate
$$P(\mathrm{Advisor}k \,\mathrm{replies}) = \frac{R}{N}.$$
So, we most likely obtain an overestimate.[^3]
After categorizing the emails in replies and new emails, I obtain the following sample proportions:

* P(Adviser1 replies) = 0.3562.
* P(Adviser2 replies) = 1.
* P(Adviser3 replies) = 0.6786.

As I already knew, the reply rate of Advisor1 is extremely low, which discourages any conversation. I never had any problems in communication with Advisor2 and Advisor3, which I also see confirmed in the numbers.

### Some other exploratory visualizations for fun

### A note on email data extraction

The above data analysis was performed in R. However, I could not find a way to access my email from within R. Therefore, the data extraction step was done in the Ruby language, which provides excellent libraries and resources for such a task:

* I use the [Really Ruby Mail Library *mail*](https://github.com/mikel/mail) to retrieve all emails from the Inbox and Sent folders of my Tulane Office 365 email account. 
* Subsequently, I retrieve the relevant emails (those from and to my three PhD advisors), and organize the relevant information (such as "to", "from", "cc", "subject", "date", etc.), into [Daru](https://github.com/SciRuby/daru) data frames, which I save as CSV files.
* The resulting CSV files are loaded into R for analysis.
* [The Ruby code is available as a github gist.]()

--------------------------------------------

  [^1] Interestingly, I had never encountered an academic who does not reply to email at my undergraduate institution, Technische Universitaet Darmstadt. So, I was quite surprised by what I consider a lack of professionalism.
  [^2] For example another frustrated PhD student.
  [^3] During this winter break, I suddenly have received an email from Advisor1, informing me of Advisor1's resignation from my PhD committee, which quite possibly puts an end to my academic career. Not only was the resignation never discussed (with me, or with the other co-advisor Advisor2), but it also came at a time (beginning of the winter holidays), when nobody is available to help me sort things out. Additionally, it came after the application deadline for most graduate programs was already over, so that transferring to a different university was out of the question.
  [^4] An overestimate, because implicitly I count multiple replies to the same email as replies to different emails from me, and I count replies to emails from other people as replies to me if I'm in the CC. Of course, some emails don't need a reply, but filtering those out would require to read each individual email, which would be boring and also too much of a time commitment for a little blog post. It can be argued that this last observation makes the sample proportion an underestimate rather than an overestimate. But considering my communication style and the factors mentioned before, I still expect that the resulting sample proportions are overestimates of the true reply probabilities. I will try to find some time to do the calculation properly, which would require a programmatic representation of chains of emails, and decisions about when factors like "Reply-all", "CC"/"BCC", mailing lists, etc. signify that a reply email is still targeting me specifically (even when my email is for example far down in the chain).

