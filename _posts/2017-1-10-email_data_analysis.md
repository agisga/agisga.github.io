---
layout: post
title: Email data analysis&#58; responsiveness of academic advisors
tags:
- data
- visualization
- academia 
---

How to make a professor reply to email? That's a question I have asked myself (and my fellow graduate students) too many times since joining the math graduate program at Tulane University.[^1] The problem becomes especially severe, when the unresponsive professor is your PhD advisor.

What's even more frustrating is that the lack of communication is always regarded as the student's fault. The unresponsiveness of a professor, which leads to a general lack of communication, and a resulting absence of any meaningful conversation, is usually denied by the professor (and often even by other professors who are extraneous to the situation). In fact, regarding my latest experience with an unresponsive PhD co-advisor, other committee members suggested that it is me who is not communicating enough, implying that it is my unwillingness to communicate that lies at the root of all possible problems with my PhD progress or the student-advisor relationship. Of course, I disagree. And anyway, as scientists we should trust in data, not opinion. Luckily, my email correspondence is readily available for a quick analysis.

In the following I perform a quick data analysis of my email correspondence with three of my past and present academic advisors at Tulane University. To avoid using real names, in what follows I refer to the three individuals as *Advisor1*, *Advisor2*, and *Advisor3*.

For the case that somebody[^2] who comes across this write-up would like to perform a similar data analysis, I made my entire code available online. In the last sections of this write-up I include a few comments on the code, and give a link to it on github (real names, email addresses, and passwords were removed for privacy (obviously)).

### Number of emails exchanged

I started working with Advisor1 and Advisor2 as my co-advisors on 9/11/2014, and the current arrangement was ended on 12/19/2016.[^3] Thus, I only consider emails exchanged with them during that time interval. Prior to that, Advisor3 worked with me for about a year, until deciding to quit academia.

The following bar graph shows the number of emails exchanged with Advisor1.

![Bar graph: number of emails exchanged with Advisor1](/images/email_analysis/advisor1_received_sent.png?raw=true "Bar graph: number of emails exchanged with Advisor1")

Evidently, I have sent almost three times as many emails to Advisor1, as I have received. Even though this already shows a great level of unresponsiveness from Advisor1, let's see how it compares to the other two advisors.

![Bar graph: number of emails exchanged with Advisor2 and Advisor3](/images/email_analysis/advisors_2_and_3_received_sent.png?raw=true "Bar graph: number of emails exchanged with Advisor2 and Advisor3")

The exchange with Advisor3 is approximately even. However, Advisor2 has sent many more emails to me than I have sent back. This is explained by the fact that Advisor2 sends out current research papers to the entire research group almost weekly, which I highly appreciate.

### Estimated reply probability

In principle, the probability to receive a reply email can be easily estimated as a sample proportion from given email data. The problem is that people are not very organized about email; they don't use it in the way they are "supposed to". For example, instead of writing a *new* email, I often reply to an old email addressed to the same people. Another example would be a situation where in a chain of emails, somebody wants to reply to the initial email but instead they reply to somebody else's reply to the original message (or to a reply to a reply to a reply to the original message). Many such "improper" uses of email can be thought of especially when multiple people are included in the TO, CC, and BCC. Thus it becomes very difficult to distinguish when a reply email is a legitimate reply, or which message in a chain of emails it is actually replying to. Moreover, it is not clear, which emails warrant a response in the first place (without reading them). I would be deeply grateful for any pointers on how to properly address these problems. 

Due to the issues just mentioned, I use a rather crude estimate: If $R$ is the number of emails from Advisor$k$ ($k = 1,2,3$), which are marked as replies to *any* email (not even necessarily an email from me), and $N$ is the total number of emails that I sent to Advisor$k$, then I estimate

$$P(\mathrm{Advisor}k \,\mathrm{replies}) \approx \frac{R}{N}.$$

I think that this generally will give an overestimate.[^4]

After categorizing the emails in replies and new emails, I obtain the following sample proportions:

* P(Adviser1 replies) $\approx$ 0.3562.
* P(Adviser2 replies) $\approx$ 1.
* P(Adviser3 replies) $\approx$ 0.6786.

I never had any problems in communication with Advisor2 and Advisor3, which I also see confirmed in these numbers.
As I already knew, the reply rate of Advisor1 is pretty low, which discourages any conversation. Interestingly, after categorizing the emails into replies and new emails, it turns out that in the considered time interval there was only exactly one message from Advisor1, which was not a reply email. That email is the one in which Advisor1 informed me of their resignation from my graduate committee. All other conversations with Advisor1 were initiated by me.

### Some other exploratory visualizations for fun

Now, I consider data visualization a mildly entertaining pastime, so I will look at a couple additional exploratory plots. :stuck_out_tongue:

This figure shows the relative frequency of emails sent by each advisor to me on each day of the week.

![Emails from PhD advisors by weekday](/images/email_analysis/wday.png?raw=true "Emails from PhD advisors by weekday")

We can see that the (unresponsive) Advisor1 does not work on weekends (which is not a bad thing at all!), and that Advisor3 processes quite a bit of email on Sunday.

Next we investigate the number of emails sent by each advisor per time of day.

![Emails from PhD advisors by time of day](/images/email_analysis/time.png?raw=true "Emails from PhD advisors by time of day")

Here we see that Advisor1 is probably a morning person, Advisor3 regularly sends emails in the middle of the night, and Advisor2 does not seem to take a real lunch break.

## :computer: Code

### A note on email data extraction

The above data analysis was performed in R. However, I could not find a way to access my email from within R. Therefore the data extraction step was done in the Ruby language, which provides excellent libraries and resources for such a task:

* I use the [Really Ruby Mail Library *mail*](https://github.com/mikel/mail) to retrieve all emails from the Inbox and Sent folders of my Tulane Office 365 email account. 
* Subsequently, I retrieve the relevant emails (those from and to the three PhD advisors), and organize the relevant information (such as "to", "from", "cc", "subject", "date", etc.), into [Daru](https://github.com/SciRuby/daru) data frames, which I save as CSV files.
* The resulting CSV files are loaded into R for analysis.
* [:octocat: My Ruby code is available as a github gist.](https://gist.github.com/agisga/2e1a350beeb73e450a4fb1ccfadfc6b4)

### Data analysis in R

[The R code, which produces all of the figures presented above, is also available as a github gist :octocat:](https://gist.github.com/agisga/ef8ef9264c2b3114175eb1d419045036).

My libraries of choice are the usual suspects &mdash; the [tidyverse](https://blog.rstudio.org/2016/09/15/tidyverse-1-0-0/) packages dplyr, tidyr, and lubridate for data manipulation, and ggplot2 for visualization.

--------------------------------------------

  [^1]: Interestingly, I had never encountered an academic who does not reply to email at my undergraduate institution, Technische Universitaet Darmstadt, so I was quite surprised by what I consider a lack of professionalism.
  [^2]: For example, another frustrated PhD student.
  [^3]: During this winter break, I suddenly received an email from Advisor1, informing me of Advisor1's resignation from my PhD committee, which quite possibly puts an end to my academic career. Not only was the resignation never discussed (with me, or with the other co-advisor Advisor2), but it also came at a time (beginning of the winter holidays) when nobody is available to help me sort things out. Additionally, it came after the application deadline for most graduate programs was already over, so that transferring to a different university was out of the question.
  [^4]: An overestimate, because implicitly I count multiple replies to the same email as replies to different emails from me, and I count replies to emails from other people as replies to me if I'm in the CC. Of course, some emails don't need a reply, but filtering those out would require to read each individual email, which would be boring and also too much of a time commitment for a little blog post. It can be argued that this last observation makes the sample proportion an underestimate rather than an overestimate. But considering my communication style and the factors mentioned before, I still expect that the resulting sample proportions are overestimates of the true reply probabilities. I will try to find some time to do the calculation properly, which would require a programmatic representation of chains of emails, and decisions about when factors like "Reply-all", "CC"/"BCC", mailing lists, etc. signify that a reply email is still targeting me specifically (even when my email is, for example, far down in the chain).

