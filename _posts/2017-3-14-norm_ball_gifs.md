---
layout: post
title: 2D "norm-balls" for commonly used penalty functions as GIF images
tags:
- r
- math
---

Many statistical modeling problems reduce to a minimization problem of the general form:

$$
\begin{equation}
\mathrm{minimize}\subscript{\boldsymbol{\beta}\in\mathbb{R}^m}\quad f(\mathbf{X}, \boldsymbol{\beta}) + \lambda g(\boldsymbol{\beta}),
\end{equation}
$$

or

$$
\begin{eqnarray}
&\mathrm{minimize}\subscript{\boldsymbol{\beta}\in\mathbb{R}^m}\quad f(\mathbf{X}, \boldsymbol{\beta}),\\
&\mathrm{subject\,to}\quad g(\boldsymbol{\beta}) \leq t,
\end{eqnarray}
$$

where $f$ is some type of *loss function*, $\mathbf{X}$ denotes the data, and $g$ is a *penalty* (also referred to by other names, such as "regularization term"; problems (1) and (2) are often equivalent by the way). Of course both, $f$ and $g$, may depend on further parameters.

There are multiple reasons why it can be helpful to check out the contours of such penalty functions $g$:

* When $\boldsymbol{\beta}$ is two-dimensional, the solution of problem (2) can be found by simply taking a look at the contours of $f$ and $g$.
* That builds intuition for what happens in more than two dimensions.
* From a Bayesian point of view, problem (1) can often be interpreted as an [MAP](https://en.wikipedia.org/wiki/Maximum_a_posteriori_estimation) estimator, in which case the contours of $g$ are also contours of the prior distribution of $\boldsymbol{\beta}$.

Therefore, it is meaningful to visualize the unit-"norm"-ball arising from $g$. Here I put "norm" in quotation marks, because such functions $g$ need not be proper norms (though they often are). Thus, by saying unit-"norm"-ball I simply refer to the set

$$\{ \mathbf{x}\in\mathbb{R}^2 : g(\mathbf{x}) \leq 1 \}.$$

Below you see GIF images of unit-"norm"-balls for various penalty functions $g$ in 2D, capturing the effect of parameter changes in $g$. The covered penalty functions include the family of $p$-norms, the elastic net penalty, the fused penalty, and the sorted $\ell_1$ norm. The GIFs capture the changes in the shape of the "norm"-balls as we vary certain parameters.

:white_check_mark: The R code to generate the GIFs is provided at the end of this write-up.

## p-norms in 2D

First we consider the $p$-norm,

$$
g\subscript{p}(\boldsymbol{\beta}) = \lVert\boldsymbol{\beta}\rVert\subscript{p}^{p} = \lvert\beta\subscript{1}\rvert^p + \lvert\beta\subscript{2}\rvert^p,
$$

with a varying parameter $p \in (0, \infty]$. Many statistical methods, such as LASSO and Ridge Regression, employ $p$-norm penalties. To find all $\boldsymbol{\beta}$ on the boundary of the 2D unit norm ball, given $\beta_1$ (the first entry of $\boldsymbol{\beta}$), $\beta_2$ is easily obtained as

$$\beta_2 = \pm (1-|\beta_1|^p)^{1/p}, \quad \forall\beta_1\in[-1, 1].$$

<img src="/images/norm_balls/p-norm_balls.gif" alt="Loading..." title="p-norm balls">

<!-- When the loss function $f$ is the mean squared error, its contours are ellipses centered at the least squares solution. The solution to the constrained minimization problem in this case lies at the point, at which the contours of $f$ and the $t$-"norm"-ball of $g$ meet for the first time, as shown in the following GIF image.

TODO: GIF

We observe that for $p \leq 1$ one of the $\beta\subscript{i}$s tends to be equal to zero, i.e., the solution is *sparse*. -->

## Elastic net penalty in 2D

The elastic net penalty can be written in the form

$$
g\subscript{\alpha}(\boldsymbol{\beta}) = \alpha \lVert \boldsymbol{\beta} \rVert\subscript{1} + (1 - \alpha) \lVert \boldsymbol{\beta} \rVert\subscript{2}^{2},
$$

for $\alpha\in(0,1)$. It is quite popular with a variety of regression-based methods (such as Elastic Net obviously). We obtain the corresponding 2D unit ball, by calculating $\beta\subscript{2}$ from a given $\beta\subscript{1}\in[-1,1]$ as

$$\beta\subscript{2} = \pm \frac{-\alpha + \sqrt{\alpha^2 - 4 (1 - \alpha) ((1 - \alpha) \beta\subscript{1}^2 + \alpha \beta\subscript{1} - 1)}}{2 - 2 \alpha}.$$

<img src="/images/norm_balls/elastic_net_balls.gif" alt="Loading..." title="elastic net balls">

## Fused penalty in 2D

The *fused* penalty can be written in the form

$$
g\subscript{\alpha}(\boldsymbol{\beta}) = \alpha \lVert \boldsymbol{\beta} \rVert\subscript{1} + (1 - \alpha) \sum\subscript{i = 2}^m \lvert \beta\subscript{i} - \beta\subscript{i-1} \rvert.
$$

It encourages neighboring coefficients $\beta\subscript{i}$ to have similar values, and is utilized in the fused LASSO and similar methods.

<img src="/images/norm_balls/fused_penalty_balls.gif" alt="Loading..." title="fused penalty">

(Here I have simply evaluated the fused penalty function on a grid of points in $[-2,2]^2$, because figuring out equations in parametric form for the above polygons was too painful for my taste... :stuck_out_tongue:)

## Sorted L1 penalty in 2D

The Sorted $\ell\subscript{1}$ penalty is used in a number of regression-based methods, such as SLOPE and OSCAR. It has the form

$$g\subscript{\boldsymbol{\lambda}}(\boldsymbol{\beta}) = \sum\subscript{i = 1}^m \lambda\subscript{i} \lvert \beta \rvert\subscript{(i)},$$

where $\lvert \beta \rvert\subscript{(1)} \geq \lvert \beta \rvert\subscript{(2)} \geq \ldots \geq \lvert \beta \rvert\subscript{(m)}$ are the absolute values of the entries of $\boldsymbol{\beta}$ arranged in a decreasing order. In 2D this reduces to

$$g\subscript{\boldsymbol{\lambda}}(\boldsymbol{\beta}) = \lambda\subscript{1} \max\{|\beta\subscript{1}|, |\beta\subscript{2}|\} + \lambda\subscript{2} \min\{|\beta\subscript{1}|, |\beta\subscript{2}|\}.$$

<img src="/images/norm_balls/sorted_L1_balls.gif" alt="Loading..." title="sorted L1 norm balls">

# Code

I use the libraries

```R
library(dplyr)
```

for data manipulation,

```R
library(ggplot2)
```

for generation of figures, and

```R
library(magick)
```

to combine the figures into a GIF.

## p-norms in 2D

```R
x1 <- seq(-1, 1, by = 0.01)
p <- c(seq(0.1, 1, by = 0.1), seq(1.5, 4, by = 0.5), Inf)
for(i in 1:length(p)) {
  x2 <- sapply(x1, function(x) abs((1-abs(x)^p[i])^(1/p[i])) )
  data_frame(x_1 = c(x1, rev(x1), x1[1]), x_2 = c(x2, -rev(x2), x2[1])) %>%
    ggplot(aes(x_1, x_2)) + geom_path() +
    annotate("text", x = 0, y = 0, parse = TRUE, size = 6,
             color = "blue", label = paste0("p == ", p[i])) +
    xlab(expression(beta[1])) + ylab(expression(beta[2])) +
    ggtitle(expression(group("|", beta[1], "|")^p+group("|", beta[2], "|")^p==1)) +
    theme_minimal()
  ggsave(paste0("./p-norm_img/", sprintf("%03.0f", i), ".jpeg"),
         width = 8, height = 8, units = "cm")
}

# make a GIF
images <- paste0("./p-norm_img/", list.files(path = "./p-norm_img/", pattern = "jpeg"))
frames <- c()
for (i in length(images):1) {
  x <- images[i] %>% image_read() %>% image_scale("400")
  frames <- c(x, frames)
}
animation <- image_animate(frames, fps = 2)
image_write(animation, "p-norm_balls.gif")
```

## Elastic net penalty in 2D

```R
x1 <- seq(-1, 1, by = 0.01)
a <- seq(0, 0.9, by = 0.1)
for(i in 1:length(a)) {
  x2 <- sapply(x1, function(x) {
                 x <- abs(x)
                 (-a[i] + sqrt(a[i]^2 - 4 * (1 - a[i]) * ((1 - a[i]) * x^2 + a[i] * x - 1))) / (2 - 2 * a[i])
})
  data_frame(x_1 = c(x1, rev(x1), x1[1]), x_2 = c(x2, -rev(x2), x2[1])) %>%
    ggplot(aes(x_1, x_2)) + geom_path() +
    annotate("text", x = 0, y = 0, parse = TRUE, size = 6,
             color = "blue", label = paste0("alpha == ", a[i])) +
    xlab(expression(beta[1])) + ylab(expression(beta[2])) +
    ggtitle(expression(alpha*(group("|", beta[1], "|")+group("|", beta[2], "|"))+(1-alpha)*(beta[1]^2+beta[2]^2)==1)) +
    theme_minimal()
  ggsave(paste0("./elastic_net_img/", sprintf("%03.0f", i), ".jpeg"),
         width = 9, height = 9, units = "cm")
}

# make a GIF
images <- paste0("./elastic_net_img/", list.files(path = "./elastic_net_img/", pattern = "jpeg"))
frames <- c()
for (i in length(images):1) {
  x <- images[i] %>% image_read() %>% image_scale("400")
  frames <- c(x, frames)
}
animation <- image_animate(frames, fps = 2)
image_write(animation, "elastic_net_balls.gif")
```

## Fused penalty in 2D

```R
# generate an equidistant grid in the X-Y-plane
u <- seq(-2, 2, by = 0.01)
m  <- length(u)
xy <- matrix(c(rep(u, each = m), rep(u, m)), ncol = 2)
colnames(xy) <- c("x", "y")
xy <- as_data_frame(xy)

# evaluate the fused penalty on the grid, draw points with value <=1 only, and save a figure for each value of `a`
a <- c(0, seq(0.3, 0.8, by = 0.1), 1)
for(i in 1:length(a)) {
  xy %>%
    mutate(Value = a[i] * (abs(x) + abs(y)) + (1 - a[i]) * abs(x - y)) %>%
    filter(abs(Value) <= 1) %>%
    ggplot(aes(x, y, color = Value)) + geom_point(pch = ".") +
    annotate("text", x = -1.5, y = 1.5, parse = TRUE, size = 6,
             color = "blue", label = paste0("alpha == ", a[i])) +
    xlab(expression(beta[1])) + ylab(expression(beta[2])) +
    ggtitle(expression(alpha*(group("|", beta[1], "|")+group("|", beta[2], "|"))+(1-alpha)*group("|", beta[1] - beta[2], "|")<=1)) +
    xlim(-2, 2) + ylim(-2, 2) +
    theme_minimal()
  ggsave(paste0("./fused_img/", sprintf("%03.0f", i), ".jpeg"),
         width = 10, height = 8, units = "cm")
}

# make a GIF
images <- paste0("./fused_img/", list.files(path = "./fused_img/", pattern = "jpeg"))
frames <- c()
for (i in length(images):1) {
  x <- images[i] %>% image_read() %>% image_scale("500")
  frames <- c(x, frames)
}
animation <- image_animate(frames, fps = 2)
image_write(animation, "fused_penalty_balls.gif")
```

## Sorted L1 penalty in 2D

```R
lambda1 <- 1
lambda2 <- c(seq(0, 1, by = 0.2), seq(1, 2, by = 0.2))
x1 <- seq(-1, 1, by = 0.01)

get_x2_of_sorted_L1 <- function(x, lambda1, lambda2) {
  if (abs(x) <= 1 / (lambda1 + lambda2)) {
    y <- (1 - lambda2 * abs(x)) / lambda1
  } else {
    y <- (1 - lambda1 * abs(x)) / lambda2
  }
  return(y)
}

for(i in 1:length(lambda2)) {
  x2 <- sapply(x1, function(x) get_x2_of_sorted_L1(x, lambda1, lambda2[i]))
  data_frame(x_1 = c(x1, rev(x1), x1[1]), x_2 = c(x2, -rev(x2), x2[1])) %>%
    ggplot(aes(x_1, x_2)) + geom_path() +
    annotate("text", x = 0, y = 0, parse = TRUE, size = 6, color = "blue",
             label = paste0("list(lambda[1] == ", lambda1,
                            ", lambda[2] == ", lambda2[i], ")")) +
    xlab(expression(beta[1])) + ylab(expression(beta[2])) +
    ggtitle(expression(list(lambda[1]*group("|", beta, "|")[(1)]+lambda[2]*group("|", beta, "|")[(2)]==1, group("|", beta, "|")[(1)] >= group("|", beta, "|")[(2)]))) +
    theme_minimal()
  ggsave(paste0("./sorted_L1_img/", sprintf("%03.0f", i), ".jpeg"),
         width = 8.5, height = 8.5, units = "cm")
}

# make a GIF
images <- paste0("./sorted_L1_img/", list.files(path = "./sorted_L1_img/", pattern = "jpeg"))
frames <- c()
for (i in length(images):1) {
  x <- images[i] %>% image_read() %>% image_scale("400")
  frames <- c(x, frames)
}
animation <- image_animate(frames, fps = 2)
image_write(animation, "sorted_L1_balls.gif")
```
