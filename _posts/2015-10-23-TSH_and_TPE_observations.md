---
layout: post
title: '"Testing Statistical Hypotheses" and "Theory of Point Estimation" impressions'
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

-->

<br>
<input type="button" onclick="return toggleMe('unbiased')" value="+ Topic:"> <b>Unbiasedness</b><br>
<div id="unbiased" style="display:none">

## Unbiasedness

The well-known and widely used definition of an unbiased estimator $\hat{\theta}$ of a parameter $\theta$ is

$$\mathrm{E}\subscript{\theta}(\hat{\theta}) = \theta.$$

However it can be generalized as follows. Assume that there is a loss function $L(\theta, \hat{\theta})$, which only depends on the correct parameter $\theta$ and the estimate $\hat{\theta}$ (i.e. it measures how far off the estimator is from the parameter that it aims to estimate).
Then $\hat{\theta}$ is said to be unbiased for $\theta$ with respect to $L$, if for all $\theta^\prime$ it holds that

$$\mathrm{E}\subscript{\theta}(L(\theta^\prime, \hat{\theta})) \geq \mathrm{E}\subscript{\theta}(L(\theta, \hat{\theta})).$$

That is, if $\hat{\theta}$ is on average closer to the correct parameter $\theta$ than to any wrong parameter $\theta^\prime$ in the parameter space.

When estimating a real valued $\theta$ with the square of the error as loss, the above condition becomes

$$\mathrm{E}\subscript{\theta}\left(\left| \theta^\prime - \hat{\theta} \right|^2\right) \geq \mathrm{E}\subscript{\theta}\left(\left| \theta - \hat{\theta}\right|^2\right).$$

If $\mathrm{E}\subscript{\theta}\hat{\theta}$ is one of the possible values of $\theta$, then by adding and substracting $\mathrm{E}\subscript{\theta}\hat{\theta}$ inside the parentheses on both sides of the equation it follows that the above unbiasedness condition is satisfied if and only if

$$\mathrm{E}\subscript{\theta}(\hat{\theta}) = \theta.$$

This equivalence also holds under somewhat more general assumptions, see exercise 1.2 in TSH.

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

