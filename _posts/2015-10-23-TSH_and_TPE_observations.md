---
layout: post
title: '"Testing Statistical Hypotheses" and "Theory of Point Estimation" impressions'
date: 2015-10-29
---

<script type="text/javascript">
function toggleMe(a){
var e=document.getElementById(a);
if(!e)return true;
if(e.style.display=="none"){
e.style.display="block"
}
else{
e.style.display="none"
}
return true;
}
</script>

I am currently reading Lehmann & Romano "Testing Statistical Hypotheses" (3rd ed.) and Lehmann & Casella "Theory of Point Estimation" (2nd ed.), abbr. TSH and TPE. The following is a collection of ~~random facts~~ observations I made while reading TSH and TPE.

:construction_worker: *This post will be regularly updated.* :construction_worker:

__Clickable items:__


<!-- 
* some things that were not clear to me before, 
* some results I found interesting, 
* definitions that are better than their equivalents that I have seen before,
* and other observations I made while reading TSH and TPE.

Brainstorming:

* LME = posterior mode with a uniform prior; LASSO estimate = posterior mode with a Laplacian prior
* definition of unbiased
* two-sided hypotheses tests: exerises 3.54 and 3.2 (ii)
* fundamental Neyman-Pearson lemma and generalizations
* relationship tests x CI

-->

<br>
<input type="button" onclick="return toggleMe('unbiased')" value="+ Topic:"> <b>On the notion of unbiasedness of estimators, hypotheses tests, and confidence intervals</b><br>
<div id="unbiased" style="display:none">

## On the notion of unbiasedness of estimators, hypotheses tests, and confidence intervals

The following discusses various well-known definitions of unbiasedness, their generalizations and relationships with each other, as well as some of the underlying intuition (such as the relationship between hypotheses tests and confidence intervals).

### Unbiased estimators

The well-known and widely used definition of an unbiased estimator $\hat{\theta}$ of a parameter $\theta$ is

$$\mathrm{E}\subscript{\theta}(\hat{\theta}) = \theta.$$

However it can be generalized as follows. Assume that there is a loss function $L(\theta, \hat{\theta})$, which only depends on the correct parameter $\theta$ and the estimate $\hat{\theta}$ (i.e. it measures how far off the estimator is from the parameter that it aims to estimate).
Then $\hat{\theta}$ is said to be unbiased for $\theta$ with respect to $L$, if for all $\theta^\prime$ it holds that

$$\mathrm{E}\subscript{\theta}(L(\theta^\prime, \hat{\theta})) \geq \mathrm{E}\subscript{\theta}(L(\theta, \hat{\theta})).$$

That is, if $\hat{\theta}$ is on average closer to the correct parameter $\theta$ than to any wrong parameter $\theta^\prime$ in the parameter space.

When estimating a real valued $\theta$ with the square of the error as loss, the above condition becomes

$$\mathrm{E}\subscript{\theta}\left(\left| \theta^\prime - \hat{\theta} \right|^2\right) \geq \mathrm{E}\subscript{\theta}\left(\left| \theta - \hat{\theta}\right|^2\right).$$

If $\mathrm{E}\subscript{\theta}\hat{\theta}$ is one of the possible values of $\theta$, then by adding and subtracting $\mathrm{E}\subscript{\theta}\hat{\theta}$ inside the parentheses on both sides of the equation it follows that the above unbiasedness condition is satisfied if and only if

$$\mathrm{E}\subscript{\theta}(\hat{\theta}) = \theta.$$

This equivalence also holds under somewhat more general assumptions, see exercise 1.2 in TSH.

### Unbiased tests

Consider a level $\alpha$ test $\phi$ of the hypothesis $H : \theta \in \Omega\subscript{H}$ against an alternative $K : \theta \in \Omega\subscript{K}$.
Denote the power function of $\phi$ by $\beta\subscript{\phi}(\theta) = \mathrm{E}\subscript{\theta} \phi(X)$.
Then it is natural to define unbiasedness of $\phi$ by the criterion

$$
\begin{eqnarray}
\beta\subscript{\phi}(\theta) &\leq& \alpha \quad \mathrm{if}\, H : \theta \in \Omega\subscript{H}, \\\\\\
\beta\subscript{\phi}(\theta) &\geq& \alpha \quad \mathrm{if}\,  K : \theta \in \Omega\subscript{K}. 
\end{eqnarray}
$$

In particular, it follows that $\beta\subscript{\phi}(\theta) = \alpha$ on the common boundary of $\Omega\subscript{H}$ and $\Omega\subscript{K}$. In fact, a test that is the most powerful among all such tests, is UMP unbiased (Lemma 4.1.1 in TSH). 

However, the definition of an unbiased test can be generalized in the same way as that of an unbiased estimator shown above.
Assume that there is a loss function $L(\theta, \phi(x))$, which only depends on the true value of $\theta$ and the decision $\phi(x)$ takes by the test $\phi$. Then the hypothesis test is unbiased with respect to $L$, if for all $\theta^\prime$ it holds that

$$\mathrm{E}\subscript{\theta}(L(\theta^\prime, \phi(X))) \geq \mathrm{E}\subscript{\theta}(L(\theta, \phi(X))).$$

For the test $\phi$ of $H$ vs. $K$ let the loss function be equal to $\alpha$ if a Type II error is committed and equal $(1-\alpha)$ if a Type I error is committed. Then 

$$
\mathrm{E}\subscript{\theta}(L(\theta^\prime, \phi(X))) = 
\begin{cases}
\alpha (1 - \beta\subscript{\phi}(\theta)) \quad &\mathrm{if}&\, \theta^\prime \in \Omega\subscript{K}\\\\\\ 
(1-\alpha) \beta\subscript{\phi}(\theta) \quad &\mathrm{if}&\, \theta^\prime \in \Omega\subscript{H},
\end{cases}
$$

It follows that if $\theta \in \Omega\subscript{H}$ then $\alpha (1 - \beta\subscript{\phi}(\theta)) \geq (1-\alpha) \beta\subscript{\phi}(\theta)$, and consequently

$$\beta\subscript{\phi}(\theta) \leq \alpha.$$

Similarly, by considering $\theta\in\Omega\subscript{K}$, we get $\beta\subscript{\phi}(\theta) \geq \alpha$. Thus the usual definition is a special case of the more general loss-function-based definition.

### Unbiased confidence sets

As is well-known, the defining condition for a confidence interval $\left(\underline{\theta}, \overline{\theta}\right)$ is

$$P\subscript{\theta}\left(\underline{\theta}(X) \leq \theta \leq \overline{\theta}(X)\right) \geq 1-\alpha,$$

for all $\theta$.

#### Hypotheses tests vs. confidence intervals

It is well-known that hypotheses tests and confidence intervals generally do exactly the same thing.
However, to describe with mathematical rigour in what sense it is true requires a little thinking.

Consider a level $\alpha$ test of a two-sided hypothesis test $H : \theta = \theta\subscript{0}$ vs. $K : \theta \neq \theta\subscript{0}$, and denote its acceptance region by $A(\theta\subscript{0})$.
Define the inclusion region of the confidence set to be

$$S(x) := \\{ \theta : x\in A(\theta) \\},$$

that is, $\theta \in S(x)$ if and only if $x\in A(\theta)$. Then $S(x)$ defines a $(1-\alpha) \cdot 100\\%$ confidence set, because for all $\theta$ we have

$$P\subscript{\theta}(\theta \in S(x)) = P\subscript{\theta}(x\in A(\theta)) \geq 1 - \alpha.$$

Conversely, if we start out with a family of confidence sets $\\{S(x) : x\in\mathcal{X}\\}$, and define $A(\theta) := \\{x : \theta\in S(x)\\}$, then for any $\theta$ it holds that

$$P\subscript{\theta}(x\in A(\theta)) = P\subscript{\theta}(\theta \in S(x)) \geq 1 - \alpha.$$

It follows that $P\subscript{\theta}(\mathrm{Type\,I\,error}) \leq \alpha$, that is, $A(\theta)$ is the acceptance region of a level $\alpha$ test.

#### Unbiased and uniformly most accurate unbiased confidence sets

Now it suggests itself to define an unbiased confidence set as one that stems from an unbiased hypothesis test by the above procedure. 
In the two-sided case discussed above this condition reduces to

$$P\subscript{\theta}\left(\underline{\theta}(X) \leq \theta^\prime \leq \overline{\theta}(X)\right) \leq 1 - \alpha$$

for all $\theta^\prime$ and $\theta$ such that $\theta \neq \theta^\prime$. That is, the inclusion probability of the null hypothesis parameter $\theta^\prime$ in the confidence interval, when the alternative $\theta$ is true, is less than the confidence level. Lemma 5.5.1 in TSH shows that the confidence set derived from an unbiased level $\alpha$ hypothesis test has indeed the form of an interval.

Similarly, uniformly most accurate confidence intervals correspond to uniformly most powerful tests (see section 3.5 in TSH for more detail).
However, UMP tests usually do not exist, which is a reason to concentrate on unbiasedness instead. In particular, UMP unbiased tests correspond to uniformly most accurate unbiased confidence sets, i.e.  $S(x)$ such that for all $\theta^\prime$ and $\theta$ with $\theta\in K(\theta^\prime)$ the probability $P\subscript{\theta}(\theta^\prime\in S(x))$ is minimized.
</div>

<br>
<input type="button" onclick="return toggleMe('para2')" value="+ Topic:"> <b>Conditional expectation, conditional distribution, sufficiency, decision procedures</b><br>
<div id="para2" style="display:none">

## Conditional expectation, conditional distribution, sufficiency, decision procedures

Consider a random variable $X$ with sample space $(\mathcal{X}, \mathcal{A})$ and probability distribution $P^X$, and a statistic $T(X)$ with range space $(\mathcal{T}, \mathcal{B})$.

#### Definition [$\mathrm{E}(f(X)|t)$]

*Let $f(x)$ be a non-negative, $\mathcal{A}$-measurable and $P^X$-integrable function.
A $\mathcal{B}$-measurable function $g(t)$ is the conditional expectation of $X$ for given $t$, i.e. $\mathrm{E}(f(X)|t) = \mathrm{E}(f(X)|T=t) = g(t)$, if for all sets $B\in\mathcal{B}$ it holds that*

$$\int\subscript{T^{-1}(B)} f(x) dP^X(x) = \int\subscript{B} g(t) dP^T(t).$$

Some observations regarding this definition:

* In fact, if we define $f\subscript{0}(x) = g(T(x))$, then by Lemma 2.3.2 in TSH the above formula becomes

    $$\int\subscript{A} f(x) dP^X(x) = \int\subscript{A} f\subscript{0}(x) dP^X(x), \forall A \in \mathcal{A}\subscript{0},$$

    where $\mathcal{A}\subscript{0}$ is the $\sigma$-algebra induced by $T$.

* The existence and uniqueness $(\mathcal{A}\subscript{0}, P^X)$ of such a function $f\subscript{0}$ follows from Radon-Nikodym Theorem.

* If $f$ is not non-negative, then we can use the usual decomposition $f = f^+ - f^-$ and define

    $$\mathrm{E}(f(X)|t) = \mathrm{E}(f^+(X)|t) - \mathrm{E}(f^-(X)|t).$$

#### Definition [$P(A|t)$]

*Let $I\subscript{A}(X)$ be a random variable that is equal to one if and only if $X\in A$. The conditional probability of $A$ given $T=t$ can be defined as*

$$P(A|t) = E(I\subscript{A}(X) | t).$$

This definition seems natural, and in fact, if $T$ has Euclidean domain and range spaces or if $\mathrm{E}|f(X)| < \infty$, then the above defines the *conditional probability distribution* $P^{X|t}$ (see Theorems 2.5.2 and 2.5.3 in TSH).

#### Definition [Sufficiency]

*Let $\mathcal{P} = \\{P\subscript{\theta} : \theta\in\Omega\\}$ be a family of distributions over a sample space $(\mathcal{X}, \mathcal{A})$.*
*$T$ is sufficient for $\mathcal{P}$ (or $\theta$) if $P\subscript{\theta}(A|t)$ is independent of $\theta$ for every $A\in\mathcal{A}$.*

In particular, the class of decision procedures depending on a sufficient statistic $T$ is *essentially complete*. To see this, assume that the sample space is Euclidean, then by Theorem 2.5.1 in TSH there exists the conditional probability distribution $P^{X|t}$. Let $\phi(x)$ be a decision procedure. Given only the value of the sufficient statistic $T(X)$ (but not $X$), define another decision procedure $\psi(t)$ as a random sample from the distribution $P^{X|t}$. Then $\phi(X)$ and $\psi(T)$ have identical distributions. Consequently, both decision procedures have the same risk,

$$R(\theta, \psi) = \mathrm{E}(L(\theta, \psi(T))) = \mathrm{E}(L(\theta, \phi(X))) = R(\theta, \phi).$$

Thus, for any decision procedure that is based on $X$, there is a decision procedure based on $T$ that is equally good or better.

For a proof in the general (non-Euclidean) case see exercise 2.13 in TSH.

### General conditional expectation

Let $X$ and $Y$ be two real-valued random variables, which can be written as mappings $X: \Omega \to \mathbb{R}$ and $Y: \Omega \to \mathbb{R}$ over a measurable space $(\Omega, \mathcal{A}, P)$. The above definition of $\mathrm{E}(X|T(X)=t)$ suggests a similar definition of $\mathrm{E}(X|Y=y)$. Namely, $\mathrm{E}(X|Y=y) = g(y)$ if for all Borel sets $A$ it holds that

$$\int\subscript{Y^{-1}(A)} X(\omega) dP(\omega) = \int\subscript{A} g(y) dP^Y(y).$$

In fact, a more general version of this definition is given in Feller's "An Introduction to Probability Theory and its Applications. Volume II" (10.6) as,

$$\mathrm{E}(X\cdot I\subscript{A}(Y)) = \int\subscript{A} \mathrm{E}(X | y) \mu\\{dy\\},$$

for any pair of random variables $X$ and $Y$.

If $X$ and $Y$ are real-valued one-dimensional, then the pair $(X,Y)$ can be viewed as a random vector in the plane. Each set $\\{Y \in A\\}$ consists of parallels to the $x$-axis, and we can define a $\sigma$-algebra induced by $Y$ as the collection of all sets $\\{Y \in A\\}$, where $A$ are Borel sets. Then $\mathrm{E}(X|Y)$ is a random variable, such that $\mathrm{E}(X\cdot I\subscript{B}) = \mathrm{E}(\mathrm{E}(X|Y) \cdot I\subscript{B})$ for all $B=\\{Y\in A\\}$ with $A$ being a Borel set. This leads to the following general definition.

#### Definition [Conditional expectation]

*Let $\mathcal{A}$ be the underlying $\sigma$-algebra of sets, and let $\mathcal{B}$ be a $\sigma$-algebra contained in $\mathcal{A}$. Let $X$ be a random variable.*

1. *A random variable $U$ is called a conditional expectation of $X$ relative to $\mathcal{B}$ (or $U=\mathrm{E}(X|\mathcal{B})$), if it is $\mathcal{B}$-measurable and for all $B\in\mathcal{B}$ it holds that*

    $$\mathrm{E}(X\cdot I\subscript{B}) = \mathrm{E}(U \cdot I\subscript{B}).$$

2. *If $\mathcal{B}$ is the $\sigma$-algebra generated by a random variable $Y$, then $\mathrm{E}(X|Y) = \mathrm{E}(X|\mathcal{B})$.*

</div>

<br>
<input type="button" onclick="return toggleMe('permutation')" value="+ Topic:"> <b>Permutation tests</b><br>
<div id="permutation" style="display:none">

## Permutation tests

When a parametric probabilistic model cannot be assumed, one can still construct exact level-$\alpha$ hypotheses tests as permutation tests. Here, based on sections 5.8 and 5.9 of TSH, I discuss the concept by considering as an example a permutation test for the difference of two means. 

Assume that each of the random variables $X\subscript{1}, \dots, X\subscript{m}$ has mean $\eta$ and that each of $Y\subscript{1}, ..., Y\subscript{n}$ has mean $\xi$. Additionally assume that the distributions of all those variables differ only with respect to the mean, for example, $X\subscript{i} \sim \mathrm{i.i.d.}\, f(x\subscript{i})$ and $Y\subscript{i} \sim \mathrm{i.i.d.}\, f(y\subscript{i} - \Delta)$ with $\Delta = \eta - \xi$. The density function $f$ is not known apart from the fact that it is continuous a.e. We want to test the hypothesis $H : \Delta = 0$.

Let $N:=n+m$, denote the random vector containing all $X$s and $Y$s as $Z := (X^T, Y^T)^T$, and let $S(z)$ be the set of all permutations of the entries of a realization $z$ of the random vector $Z$.
Then a level-$\alpha$ test $\phi$ has to satisfy

$$\int \phi(z) \prod\subscript{i=1}^N f(z\subscript{i}) dz = \alpha.$$

Interestingly, it turns out that this equality holds if and only if

$$\frac{1}{N!} \sum\subscript{w\in S(z)} \phi(w) = \alpha.$$

A more general result that accounts for population stratification is given by theorem 5.8.1 in TSH.

The power of $\phi$  against an alternative $h(z)$ is given by

$$\int \phi(z) h(z) dz = \int \mathrm{E}\left(\phi(Z) \middle| T=t\right) dP^T(t).$$

Let $T(Z)$ be the order statistic. It holds that $S(z) = S(T(z)) = S(t)$, and from the expression of the conditional expectation $\mathrm{E}\left(\phi(Z) \middle| T=t\right)$ (see Example 2.4.1 and Problem 2.6), it can be further derived that the most powerful test $\phi$ maximizes

$$\sum\subscript{z\in S(t)} \phi(z) \frac{h(z)}{\sum\subscript{w\in S(z)} h(w)}$$

subject to

$$\frac{1}{N!} \sum\subscript{z\in S(t)} \phi(z) = \alpha.$$

Now, the Neyman-Pearson fundamental lemma implies that the hypothesis should be rejected whenever $\frac{h(z)N!}{\sum\subscript{w\in S(z)} h(w)}$ is too large.
This leads to a most powerful test $\phi$ given by

$$\phi(z) = \begin{cases}
1, \quad\mathrm{if}\, h(z) > C(T(z)), \\\\\\
\gamma, \quad\mathrm{if}\, h(z) = C(T(z)), \\\\\\
0, \quad\mathrm{if}\, h(z) < C(T(z)).
\end{cases}$$

Thus the test is carried out by... 

1. ordering the points in $S(z)$ in a decreasing order according to $h$,
2. rejecting if $h(z)$ is one of the $k$ largest values and rejecting with probability $\gamma$ if $h(z)$ is $(k+1)$st largest, where $k$ and $\gamma$ are determined by

   $$k+\gamma = \alpha \cdot N!$$

More general versions of this approach, which incorporate population stratification and randomization, are given in section 5.8-5.13 in TSH.

The above test is not UMP because it depends on $h$. However, it can be shown that if under the null hypothesis each $Z\subscript{i}$ follows the same normal distribution $\mathcal{N}(\xi, \sigma^2)$, then the derived test is most powerful among all unbiased tests of level $\alpha$ against all normal alternatives under consideration (see Lemma 5.9.1 in TSH for an even more general result).
Such an approach is appropriate when the data is assumed to be approximately normal but the assumption is not considered reliable. The permutation test is maximizing the power against all normal alternatives, while still being unbiased against all other alternatives.

</div>
