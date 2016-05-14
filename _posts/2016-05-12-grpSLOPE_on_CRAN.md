---
layout: post
title: My first R package on CRAN!
---

A couple of weeks ago I have released my first R package on CRAN. For me it turned out to be a far less painful process than many people on the internet portray it to be (even though the package uses quite a lot of C++ code via Rcpp and RcppEigen, and even though R CMD check returns two NOTEs). Some of the most helpful resources for publishing the package were:

* Of course, the chapter ["Releasing a package" from Hadley Wickham's book](http://r-pkgs.had.co.nz/release.html)
* Julia Silge's post ["How I Learned to Stop Worrying and Love R CMD Check"](http://juliasilge.com/blog/How-I-Stopped/)
* Karl Broman's [post on getting an R package to CRAN](http://kbroman.org/pkg_primer/pages/cran.html)

### grpSLOPE

My package is called `grpSLOPE` ([github](https://github.com/agisga/grpSLOPE), [CRAN](https://cran.r-project.org/web/packages/grpSLOPE/index.html)), and I will very briefly introduce some of it's functionality. The purpose of the Group SLOPE method is to fit a sparse linear regression model, while controlling the _group false discovery rate_. I illustrate what it means with a very simple example below (for some more detail see the [vignette](https://cran.r-project.org/web/packages/grpSLOPE/vignettes/basic-usage.html)).

We generate a random model with a design matrix $X \in \mathbb{R}^{1000 \times 2000}$, whose entries are sampled from the standard normal distribution, and a coefficient vector $\beta$, whose entries are mostly zeros.

```R
set.seed(1)

X    <- matrix(rnorm(1000*2000), 1000, 2000)
beta <- rep(0, 2000)
beta[1:20]      <- runif(20)
beta[1901:1980] <- runif(80)
y <- X %*% beta + rnorm(1000)
```

We assume that the predictors (i.e., the columns of $X$) are divided into 200 blocks, each of size 10, and we want to determine which groups of predictors have an effect on the response variable $y$. That is, given the noisy observations of $y$, we want to find out, which blocks of the vector $\beta$ contain non-zero entries. As you can see above, $\beta$ has 10 non-zero blocks. Additionally, we want to make sure that we don't make too many false discoveries in the process (i.e., we want the method to keep the expected proportion of falsely selected groups below, say, 10%). That's exactly what the Group SLOPE method is for!

```R
#install.packages("grpSLOPE") # Install the package now easily from CRAN!
library(grpSLOPE)

group  <- rep(1:200, each=10)
grpSLOPE.result <- grpSLOPE(X=X, y=y, group=group, fdr=0.1)
```

We observe that the method has indeed selected the correct groups of predictors:

```R
grpSLOPE.result$selected
#  [1] "1"   "2"   "191" "192" "193" "194" "195" "196" "197" "198"
```

And the false discovery proportion is indeed below the target of 10% in this case, while the power is at 100%:

```R
truly.significant.groups <- unique(group[which(beta != 0)])
truly.significant.groups
#  [1]   1   2 191 192 193 194 195 196 197 198

false.discoveries <- setdiff(grpSLOPE.result$selected, truly.significant.groups)
fdp <- length(false.discoveries) / length(grpSLOPE.result$selected)
fdp
#  [1] 0

true.discoveries <- intersect(grpSLOPE.result$selected, truly.significant.groups)
power <- length(true.discoveries) / length(grpSLOPE.result$selected)
power
#  [1] 1
```

Of course, the method does not perform this good under all circumstances &mdash; the interested reader can learn more from the papers referred to in the [grpSLOPE README on github](https://github.com/agisga/grpSLOPE/blob/master/README.md) (unfortunately, the "real" journal publication is still under preparation, and another related journal publication is currently under review, so, not publicly available yet either).
