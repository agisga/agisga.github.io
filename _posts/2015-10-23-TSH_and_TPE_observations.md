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

__Clickable items__ (each could as well be a separate post)__:__


<!-- 
* some things that were not clear to me before, 
* some results I found interesting, 
* definitions that are better than their equivalents that I have seen before,
* and other observations I made while reading TSH and TPE.

Brainstorming:

* MLE = posterior mode with a uniform prior; LASSO estimate = posterior mode with a Laplacian prior
* (informal?) fundamental Neyman-Pearson lemma and generalizations?
* something on linear hypotheses as chapter 7, combined with treatment in McCulloch, Searle, Neuhaus

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
\nonumber
\beta\subscript{\phi}(\theta) &\leq& \alpha \quad \mathrm{if}\, H : \theta \in \Omega\subscript{H}, \\\\\\
\beta\subscript{\phi}(\theta) &\geq& \alpha \quad \mathrm{if}\,  K : \theta \in \Omega\subscript{K}. 
\nonumber
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
<input type="button" onclick="return toggleMe('neyman-pearson')" value="+ Topic:"> <b>An informal summary of Neyman-Pearson and generalizations</b><br>
<div id="neyman-pearson" style="display:none">

## An informal summary of Neyman-Pearson and generalizations

The following offers an informal view on the fundamental lemma of Neyman and Pearson and generalizations thereof.
For a mathematically rigorous presentation see the corresponding results in TSH, which are cited in this article.

*Notation*: MP = "most powerful", UMP = "uniformly most powerful", $H$ denotes the null hypothesis, $K$ denotes the alternative hypothesis, $\alpha$ denotes the level of the hypothesis test, lower case Roman letters denote realizations of random variables (upper case).

1. __[Simple hypotheses]__ What is actually called fundamental lemma of Neyman and Pearson in TSH (Theorem 3.2.1) is concerned with a test of two simple hypotheses. Under the null hypothesis the random variable $X$ is assumed to follow a probability distribution with density $p\subscript{0}$, while under the alternative hypothesis the density is $p\subscript{1}$. 

     Consider $H : p\subscript{0}$ vs. $K : p\subscript{1}$. MP test $\phi$ exists. It rejects the null if $\frac{p\subscript{1}}{p\subscript{0}} > k$, accepts the null if $\frac{p\subscript{1}}{p\subscript{0}} < k$, and rejects with probability $\gamma$ if $\frac{p\subscript{1}}{p\subscript{0}} = k$, where $\gamma$ and $k$ are chosen to satisfy $\mathrm{E}\subscript{p\subscript{0}} \phi(X) = \alpha$.

2. __[Monotone likelihood ratio, one-sided, one-param. exp. fam.]__ For one-parameter families of distributions and one-sided hypotheses, the Neyman-Pearson lemma can be generalized to construct a UMP test if the distributions in question have monotone likelihood ratios. This is Theorem 3.4.1 in TSH.

     Consider $H : \theta \leq \theta\subscript{0}$ vs. $K : \theta > \theta\subscript{0}$ ($\theta \in \mathbb{R}$). If $\frac{p\subscript{\theta^\prime}(x)}{p\subscript{\theta}(x)}$ is nondecreasing in $T(x)$ for any $\theta < \theta^\prime$, then a UMP test $\phi$ exists. It rejects if $T(x) > C$, accepts if $T(x) < C$, and rejects with probability $\gamma$ if $T(x) = C$, where $C$ and $\gamma$ are determined by $\mathrm{E}\subscript{\theta\subscript{0}} \phi(X) = \alpha$.

     By interchanging the inequalities one obtains a UMP test for the dual problem $H : \theta \geq \theta\subscript{0}$ vs. $K : \theta < \theta\subscript{0}$.

     Additionally, this test minimizes the Type I error subject to $\mathrm{E}\subscript{\theta\subscript{0}} \phi(X) = \alpha$.

3. __[Two-sided null in one-param. exp. fam.]__ An analogous UMP test exists for a two-sided null hypothesis $H : \theta \leq \theta\subscript{1} \,\mathrm{or}\, \theta \geq \theta\subscript{2}$ in one-parameter exponential families. It rejects if $C\subscript{1} < T(x) < C\subscript{2}$, accepts if $T(x) < C\subscript{1}$ or $T(x) > C\subscript{2}$, rejects with probability $\gamma$ if $T(x) = C\subscript{i}$ (for $i=1$ or $i=2$), and satisfies $\mathrm{E}\subscript{\theta\subscript{1}} \phi(X) = \alpha = \mathrm{E}\subscript{\theta\subscript{2}} \phi(X)$. Subject to the last condition, this test minimizes the Type I error. See Theorem 3.7.1 in TSH.

     A UMP test for a two-sided alternative hypothesis $K : \theta \leq \theta\subscript{1} \,\mathrm{or}\, \theta \geq \theta\subscript{2}$ does not exist (e.g. see the corresponding section in this blog post). However, a UMP *unbiased* test analogous to the above exists (see Section 4.2 in TSH).

4. __[UMP unbiased tests, multi-param. exp. fam.]__ For multi-parameter exponential families the existence of a UMP test typically cannot be established. However, UMP *unbiased* tests can be constructed without great difficulties. Assume that $\theta\in\mathbb{R}$ is the parameter to be tested, and that $(U, T)$ is a sufficient statistic, where $U$ corresponds to $\theta$ and $T$ corresponds to all other parameters. Then UMP unbiased tests exist for most of the usual hypotheses, and can be written in the same way as in the one-parameter case, except that now all constants specifying the rejection region depend on $T$ (e.g. the rejection rule has the form $u > C(t)$, etc.). Also, the size of the test is measured conditional on $T$.

    See Theorem 4.4.1 in TSH.

5. __[UMP unbiased and independent of sufficient statistic]__ UMP unbiased tests for multi-parameter exponential families, as discussed in the last point, are independent of $T$ if a number of additional conditions are satisfied. For example, assume that $V = h(U, T)$ is independent of $T$ (with $\theta = \theta\subscript{1}$ and $\theta = \theta\subscript{2}$) and that $h$ is increasing in $u$. Then a UMP unbiased test for a two-sided null hypothesis rejects if $C\subscript{1} < v < C\subscript{2}$, accepts if $v < C\subscript{1}$ or $v > C\subscript{2}$, etc.

    See Theorem 5.1.1 in TSH for more.

6. __[UMP invariant tests]__ If the problem of testing $H : \Omega\subscript{0}$ vs. $K : \Omega\subscript{1}$ remains invariant under a finite group $G = \\{g\subscript{1}, g\subscript{2}, \dots, g\subscript{N} \\}$, then there exists a UMP invariant test that rejects when $\frac{\sum p\subscript{\overline{g}\subscript{i} \theta\subscript{1}} (x)}{\sum p\subscript{\overline{g}\subscript{i} \theta\subscript{0}} (x)} > C$ (for any $\theta\subscript{0} \in \Omega\subscript{0}$ and any $\theta\subscript{1}$ in $\Omega\subscript{1}$). See Theorem 6.3.1 in TSH.

7. __[Finite composite null]__ When the null hypothesis specifies that $X$ is distributed according to one of finitely many densities $p\subscript{1}, p\subscript{2}, \dots, p\subscript{m}$, and the alternative hypothesis is $p\subscript{m+1}$, then there exists a test $\phi$ that maximizes $\int \phi p\subscript{m+1} d\mu$. For suitable constants $k\subscript{1}, k\subscript{2}, \dots, k\subscript{m}$, this test rejects the null if $p\subscript{m+1}(x) > \sum\subscript{i=1}^m k\subscript{i} p\subscript{i}(x)$, it accepts the null if $p\subscript{m+1}(x) < \sum\subscript{i=1}^m k\subscript{i} p\subscript{i}(x)$, and it satisfies $\int \phi p\subscript{i} d\mu \leq \alpha$ for $i = 1,2,\dots,m$.

     See Theorem 3.6.1 and Corollary 3.6.1 in TSH for more detail.

8. __[Least favorable distributions]__  Assume a setting similar to the one in the last point, except that the number of distributions under the null hypothesis does not need to be finite. That is, $H : f\subscript{\theta}, \theta \in \omega$ vs. $K : g$.
One can define a *least favorable* distribution $\Lambda$ over $\omega$ and assume that $\theta \sim \Lambda$. As $\Lambda$ is least favorable, one can expect that it leads to a hypothesis test that works best in the worst case (i.e. at values $\theta$ closest to $K$). Thus, $\Lambda$ will typically be a distribution of $H$ that is closest to $K$. In particular, one would have $\Lambda(\omega^\prime) = 1$ for some "boundary region" $\omega^\prime$ of $\omega$. Then a MP test $\phi$ exists. It rejects if $g(x) > k \int f\subscript{\theta}(x) d\Lambda(\theta)$, accepts if $g(x) < k \int f\subscript{\theta}(x) d\Lambda(\theta)$, and satisfies $\sup\subscript{\theta\in\omega} \mathrm{E}\subscript{\theta} \phi(X) = \alpha$.

    See Theorem 3.8.1 and Corollary 3.8.1 in TSH for rigour and detail.

9. __[Maximin tests]__ The same approach can also be generalized to test $H : f\subscript{\theta}, \theta \in \omega$ vs. $K : f\subscript{\theta}, \theta \in \omega^\prime$. However, one has to ditch the UMP condition in favor of the condition that $\inf\subscript{\theta\in\omega^\prime} \mathrm{E}\subscript{\theta} \phi(X)$ is maximized under the constraint $\sup\subscript{\theta\in\omega} \mathrm{E}\subscript{\theta} \phi(X) \leq \alpha$. Such a test is called a *maximin* test, and is established in Theorem 8.1.1 and Corollary 8.1.1 in TSH. It rejects if $\int\subscript{\omega^\prime} f\subscript{\theta}(x) d\Lambda^\prime(\theta)(x) > C \int\subscript{\omega} f\subscript{\theta}(x) d\Lambda(\theta)$, for suitably chosen distributions $\Lambda^\prime$ and $\Lambda$.

    Further, Theorem 8.5.1 (Hunt-Stein) and Lemma 8.4.1 in TSH establish the existence of almost invariant tests satisfying the maximin property.

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

<br>
<input type="button" onclick="return toggleMe('two-sided')" value="+ Topic:"> <b>UMP tests for two-sided hypotheses</b><br>
<div id="two-sided" style="display:none">

## UMP tests for two-sided hypotheses

The (non-) existence of uniformly most powerful (or UMP) tests for two-sided hypotheses is an interesting phenomenon. 

#### Example of existence

First let's look at an example when such a test does exist. This is Problem 3.2 in TSH.

For $i = 1,\dots, n$ let $X\subscript{i}$ be i.i.d. $\mathrm{Uniform}(0,\theta)$ random variables, denote their realizations by lower case $x\subscript{i}$s, and let $X$ denote the vector of the $X\subscript{i}$s. Consider the hypothesis $H : \theta = \theta\subscript{0}$ against the alternative $K : \theta \neq \theta\subscript{0}$.

Denote $x\subscript{(n)} := \max\\{x\subscript{1}, \dots, x\subscript{n}\\}$. Let $\phi$ be a hypothesis test which rejects $H : \theta = \theta\subscript{0}$ in favor of a two-sided alternative, if either $x\subscript{(n)} \geq \theta\subscript{0}$ or $x\subscript{(n)} < \theta\subscript{0} \sqrt[n]{\alpha}$.

##### Proof

Using the fundamental lemma of Neyman and Pearson, it is straightforward to prove that $\phi$ is UMP. Namely, $\phi$ is a UMP test at level $\alpha$ by Neyman-Pearson, if for any fixed $\theta\subscript{1} \neq \theta\subscript{0}$, the test $\phi$ can be written as 

$$\phi(x) = \begin{cases} 
1, \quad &\mathrm{if}\, p\subscript{\theta\subscript{1}}(x) > k p\subscript{\theta\subscript{0}}(x),\\\\\\
0, \quad &\mathrm{if}\, p\subscript{\theta\subscript{1}}(x) < k p\subscript{\theta\subscript{0}}(x), 
\end{cases}$$

with a suitable $k$, and if it satisfies

$$\mathrm{E}\subscript{\theta\subscript{0}} \phi(X) = \alpha.$$

We have that

$$\begin{eqnarray}
\nonumber
\mathrm{E}\subscript{\theta\subscript{0}} \phi(X) &=& P\subscript{\theta\subscript{0}}\left(X\subscript{(n)} > \theta\subscript{0}\right) + P\subscript{\theta\subscript{0}}\left(X\subscript{(n)} < \theta\subscript{0}\sqrt[n]{\alpha}\right)\\\\\\
&=& 0 + \left(\frac{\theta\subscript{0} \sqrt[n]{\alpha}}{\theta\subscript{0}}\right)^n = \alpha.
\nonumber
\end{eqnarray}$$

As for the other Neyman-Pearson condition, we have to consider multiple cases:

* If $\theta\subscript{1} > \theta\subscript{0}$, then $k = \left(\frac{\theta\subscript{0}}{\theta\subscript{1}}\right)^n$ yields the desired result.
* If $\theta\subscript{0}\sqrt[n]{\alpha} < \theta\subscript{1} < \theta\subscript{0}$, then $k = \left(\frac{\theta\subscript{0}}{\theta\subscript{1}}\right)^n$ can be used as well.
* If $\theta\subscript{1} < \theta\subscript{0}\sqrt[n]{\alpha} < \theta\subscript{0}$, then $k = 0$.

<div align="right">
$\blacksquare$
</div>

#### Example of non-existence

Thus, we saw an example of a UMP test for a two-sided hypothesis. 

However, when the underlying distribution comes from an exponential family, then a UMP test does not exist for $H : \theta = \theta\subscript{0}$ vs. $K : \theta \neq \theta\subscript{0}$ (Problem 3.54 in TSH). This follows quite easily from the consideration of UMP tests for the one-sided hypotheses $H\subscript{1} : \theta \leq \theta\subscript{0}$ vs. $K\subscript{1} : \theta > \theta\subscript{0}$, and $H\subscript{2} : \theta \geq \theta\subscript{0}$ vs. $K\subscript{2} : \theta < \theta\subscript{0}$.
A detailed proof follows.

##### Proof

According to Theorem 3.4.1 in TSH, a UMP test of $H\subscript{1}$ exists and can be written as

$$\phi\subscript{1}(x) = \begin{cases} 
1, \quad &\mathrm{if}\, T(x) > C\subscript{1},\\\\\\
0, \quad &\mathrm{if}\, T(x) < C\subscript{1}.
\end{cases}$$

Similarly, a UMP test of $H\subscript{2}$ exists and can be written as

$$\phi\subscript{2}(x) = \begin{cases} 
1, \quad &\mathrm{if}\, T(x) < C\subscript{2},\\\\\\
0, \quad &\mathrm{if}\, T(x) > C\subscript{2}.
\end{cases}$$

Clearly, $\phi\subscript{1}$ and $\phi\subscript{2}$ are level-$\alpha$ tests for $H$ vs. $K$ as well.

Let $\phi\subscript{0}$ be a level-$\alpha$ test of $H$ vs. $K$. Fix a $\theta\subscript{1} > \theta\subscript{0}$ and a $\theta\subscript{2} < \theta\subscript{0}$. Assume that 

$$\mathrm{E}\subscript{\theta\subscript{i}} \phi\subscript{0}(X) \geq \mathrm{E}\subscript{\theta\subscript{i}} \phi\subscript{i}(X)$$

for $i = 1,2$. Then $\phi\subscript{0}$ is most powerful for testing $\theta\subscript{0}$ vs. $\theta\subscript{1}$ and for testing $\theta\subscript{0}$ vs. $\theta\subscript{2}$. Thus, by the fundamental lemma of Neyman and Pearson the UMP test can be rewritten as

$$
\begin{equation}
\phi\subscript{0}(x) = \begin{cases} 
1, \quad &\mathrm{if}\, p\subscript{\theta\subscript{1}}(x) > k\subscript{1} p\subscript{\theta\subscript{0}}(x),\\\\\\
0, \quad &\mathrm{if}\, p\subscript{\theta\subscript{1}}(x) < k\subscript{1} p\subscript{\theta\subscript{0}}(x), 
\end{cases}
\label{eq1}
\end{equation}
$$

$$
\begin{equation}
\phi\subscript{0}(x) = \begin{cases} 
1, \quad &\mathrm{if}\, p\subscript{\theta\subscript{2}}(x) > k\subscript{2} p\subscript{\theta\subscript{0}}(x),\\\\\\
0, \quad &\mathrm{if}\, p\subscript{\theta\subscript{2}}(x) < k\subscript{2} p\subscript{\theta\subscript{0}}(x).
\end{cases}
\label{eq2}
\end{equation}
$$

Let $x$ be such that $\phi\subscript{0}(x) = 1$. Now, from the monotonicity of the likelihood ratio, it follows that

* if $T(y) > T(x)$ then $\phi\subscript{0}(y) = 1$ (by equation $\eqref{eq1}$),
* if $T(y) < T(x)$ then $\phi\subscript{0}(y) = 1$ (by equation $\eqref{eq2}$).

That is, either $\phi\subscript{0}(y) = 1$ for all $y$ or $\phi\subscript{0}(x) \neq 1$ for all $x$. A contradiction. It follows that $\phi\subscript{0}$ can not be more powerful than $\phi\subscript{1}$ for testing $\theta\subscript{0}$ vs. $\theta\subscript{1}$ and than $\phi\subscript{2}$ for testing $\theta\subscript{0}$ vs. $\theta\subscript{2}$. Thus, a UMP test for $H$ vs. $K$ does not exist.

<div align="right">
$\blacksquare$
</div>

Even though a UMP test for the two-sided hypothesis considered above does not exist, there exist a UMP unbiased test (i.e. a test that is uniformly most powerful among all unbiased tests). For detail see Section 4.2 in TSH.

</div>

<br>
<input type="button" onclick="return toggleMe('equivariance')" value="+ Topic:"> <b>Least squares estimates are nice! (UMVU, MRE, BLUE)</b><br>
<div id="equivariance" style="display:none">

## Least squares estimates are nice! (UMVU, MRE, BLUE)

The well-known least squares estimator (LSE) for the coefficients of a linear model is the "best" possible estimator according to several different criteria. Three types of such optimality conditions under which the LSE is "best" are discussed below. In the process, we also briefly look at the "best" estimators of the variance in a linear model.

Let's fix the concepts first, and then explore how they apply to LSE.

### Some definitions and implications 

#### UMVU estimators

As one would expect, a *uniform minimum variance unbiased* (or UMVU) estimator $\delta(x)$ of $g(\theta)$ is an unbiased estimator such that
$\mathrm{Var}\subscript{\theta} \delta(X) \leq \mathrm{Var}\subscript{\theta} \delta^\prime(X)$ for any other unbiased estimator 
$\delta^\prime(x)$ of $g(\theta)$ and any $\theta\in\Omega$.

#### Invariance

Let $X \sim P\subscript{\theta}$ for some $\theta\in\Omega$. That is, $X$ is distributed according to one of the distributions in the family $\mathcal{P} = \\{ P\subscript{\theta}, \theta \in \Omega \\}$ of distributions. Let $G$ be the group generated by the set of all bijective transformations of the sample space of $X$ onto itself.

If for any $g\in G$ it holds that $gX \sim P\subscript{\theta^\prime}$ for some $\theta^\prime \in \Omega$, and if as $\theta$ traverses $\Omega$ so does $\theta^\prime$, then $\mathcal{P}$ is *invariant* under $G$ (Definition 2.1 in Chapter 3 TPE).

*The principle of invariance has some interesting implications:*

* If $G$ leaves $\mathcal{P}$ invariant, then there must be a bijective transformation $\bar{g}$ such that $\theta^\prime = \bar{g}\theta$. Such transformations $\bar{g}$ form a group $\overline{G}$, and we have that

    $$
    \begin{eqnarray}
    \nonumber
    P\subscript{\theta}(gX \in A) &=& P\subscript{\bar{g}\theta}(X \in A) \\\\\\
    E\subscript{\theta} \psi(gX) &=& E\subscript{\bar{g}\theta} \psi(X),
    \label{eq:invariant}
    \end{eqnarray}
    $$

    for any function $\psi$ whose expectation is defined.

* If $h(\bar{g}\theta)$ depends on $\theta$ only through $h$, then there is a transformation $g^\ast$ such that
$h(\bar{g}\theta) = g^\ast h(\theta)$ for all $\theta\in\Omega$.

* (Definition 2.4 in Chapter 3 TPE) A problem estimating $h(\theta)$ with the loss function $L$ is called *invariant* under $G$, if $L(\bar{g}\theta, g^\ast d) = L(\theta, d)$ and if $h(\bar{g}\theta)$ depends on $\theta$ only through $h$.

#### Equivariant estimators

In an invariant estimation problem, an estimator $\delta(x)$ is *equivariant* if
$$\delta(gx) = g^\ast \delta(x),$$
for all $g\in G$ (Definition 2.5 in Chapter 3 TPE).

In particular, equation ($\ref{eq:invariant}$) implies that the risk function of any equivariant estimator is constant on [orbits of the group of transformations $G$](https://en.wikipedia.org/wiki/Group_action#Orbits_and_stabilizers).

### The least squares estimator is UMVU and MRE

Consider a linear model $y = X\beta + \varepsilon$, where $y\in\mathbb{R}^n$, $X\in\mathbb{R}^{n\times p}$ with $p < n$, $\mathrm{rank}(X) = p$, $\beta\in\mathbb{R}^p$, and $\varepsilon\subscript{i} \sim \mathrm{i.i.d.}\, N(0,\sigma^2)$ for all $i\in\\{1,\dots,n\\}$.

For convenience, denote $\xi := X\beta$. It holds that $\xi\in\Pi$, where $\Pi$ denotes a $p$-dimensional subspace of $\mathbb{R}^n$ (spanned by the columns of $X$).

#### Orthogonal coordinate transformation

Consider the orthogonal transformation $z = Qy$, where $Q\in\mathbb{R}^{n\times n}$ is an orthogonal matrix such that its first $p$ rows span $\Pi$. Denote $\eta := Q\xi$, the expectation of $z$. It follows that $\eta\subscript{p+1} = \dots = \eta\subscript{n} = 0$. Thus we have that
$z\subscript{i} \sim N(\eta\subscript{i}, \sigma^2)$ for $i=1,\dots,p$ and $z\subscript{j} \sim N(0,\sigma^2)$ for $j=p+1,\dots,n$. Moreover, all entries of $z$ are independent.

By writing the multivariate normal density of $z$ it becomes apparent that $z\subscript{1}, \dots, z\subscript{p}$ and $s^2 = \sum\subscript{j = p+1}^n z\subscript{j}^2$ are the complete and sufficient statistics for $(\eta, \sigma^2)$.

It follows that $\sum\subscript{i=1}^n \lambda\subscript{i} z\subscript{i}$ is UMVU for $\sum\subscript{i=1}^n \lambda\subscript{i} \eta\subscript{i}$ and $s^2 / (n-p)$ is UMVU for $\sigma^2$, because both estimators are unbiased and functions of complete and sufficient statistics.

Clearly, $\sum\subscript{i=1}^n \lambda\subscript{i} z\subscript{i}$ is equivariant under the transformations

$$
\begin{eqnarray}
z\subscript{i}^\prime &=& z\subscript{i} + a\subscript{i}, i = 1,\dots,p, \quad z\subscript{j}^\prime = z\subscript{j}, j = p+1,\dots,n, \nonumber \\\\\\
\eta\subscript{i}^\prime &=& \eta\subscript{i} + a\subscript{i}, i = 1,\dots,p, \quad \eta\subscript{j}^\prime = \eta\subscript{j}, j = p+1,\dots,n, \nonumber \\\\\\
d^\prime &=& d + \sum\subscript{i = 1}^p a\subscript{i} \lambda\subscript{i}. \nonumber
\end{eqnarray}
$$

It follows that the estimator $\sum\subscript{i=1}^n \lambda\subscript{i} z\subscript{i}$ is also the *minimum risk equivariant* (MRE) estimator of $\sum\subscript{i=1}^n \lambda\subscript{i} \eta\subscript{i}$ (with the loss function $L(\eta, d) = \rho(d - \sum \lambda\subscript{i} \eta\subscript{i})$, where $\rho$ is convex and even). Moreover, it can be shown that $s^2 / (n-p+2)$ is MRE for $\sigma^2$ under the loss function $(d-\sigma^2)^2 / \sigma^4$ (see problem 4.3 in Chapter 3 TPE).

We refer to Theorem 4.3 in Chapter 3 TPE and anything referenced to from therein for more rigour and detail.

#### UMVU and MRE estimators in the original space

We have shown the UMVU and MRE estimators in terms of $z$, the orthogonally transformed version of $y$. However, it would be more useful to have UMVU and MRE estimators in terms of the original variables $y$.

As is well-known, the *least squares estimator* of $\mathrm{E}(y) = \xi$ is given by $\hat{y} = X (X^T X)^{-1} X^T y$, which is an orthogonal projection of $y$ on $\Pi$. It can be found by minimizing the least squares $\\|y - \xi\\|\subscript{2}^2 = \\|y - X\beta\\|\subscript{2}^2$. We have that

$$
\begin{equation}
\label{eq:least_squares}
\sum\subscript{i=1}^n (y\subscript{i} - \xi\subscript{i})^2 = \sum\subscript{i=1}^p (z\subscript{i} - \eta\subscript{i})^2 + \sum\subscript{i=p+1}^n z\subscript{i}^2.
\end{equation}
$$

Since the left hand side is minimized by $\hat{y}$ and the right hand side is minimized by $\hat{\eta}\subscript{i} = z\subscript{i}$ for $i = 1,\dots,p$ (and $=0$ for $i>p$), it holds that $\hat{y} = Q^T\hat{\eta}$. Thus, the LSE $\hat{y}$ is a linear function of $z$, and therefore the estimator $\sum\subscript{i=1}^n \lambda\subscript{i} \hat{y}\subscript{i}$ is UMVU for $\sum\subscript{i=1}^n \lambda\subscript{i} \xi\subscript{i}$ by the argumentation given above (namely because $\sum\subscript{i=1}^n \lambda\subscript{i} z\subscript{i}$ is UMVU for $\sum\subscript{i=1}^n \lambda\subscript{i} \eta\subscript{i}$).
For more detail see Chapter 3 Theorem 4.4 in TPE.

Likewise, it follows from the argumentation given above for the case of the orthogonal transform $z$ that the estimator $\sum\subscript{i=1}^n \lambda\subscript{i} \hat{y}\subscript{i}$ is MRE for $\sum\subscript{i=1}^n \lambda\subscript{i} \xi\subscript{i}$ under the transformation
$y^\prime = y + b$ with $b\in\Pi$ and with the loss function $L(\xi, d) = \rho(d - \sum \lambda\subscript{i} \xi\subscript{i})$ provided $\rho$ is convex and even.
See Chapter 3 Corollary 4.5 for detail.

Similarly, using the results given above for the orthogonal transform $z$, by reexpressing 
$s^2 = \sum\subscript{i=p+1}^n z\subscript{i}^2 = \sum\subscript{i=1}^n (y\subscript{i} - \hat{y}\subscript{i})^2$ (from equation ($\ref{eq:least_squares}$)) it follows that the UMVU and MRE estimators of $\sigma^2$ are given by
$\sum\subscript{i=1}^n (y\subscript{i} - \hat{y}\subscript{i})^2 / (n-p)$ and $\sum\subscript{i=1}^n (y\subscript{i} - \hat{y}\subscript{i})^2 / (n-p+2)$ respectively.

Finally, the LSE $\hat{\beta} = (X^T X)^{-1}X^T y$ is UMVU and MRE for $\beta$ by the above argumentation, because it can be written as a linear function of $\hat{y}$.

### The least squares estimator is BLUE

A *best linear unbiased estimator* (BLUE) is an unbiased estimator that is linear in $y$ and achieves uniformly the smallest variance among all other linear unbiased estimators (i.e., UMVU among all linear estimators).

In the context of linear models, an advantage of this optimality criterion over the notions of UMVU and MRE is that it does not rely on the normality assumptions. That is, we merely need to assume that $\mathrm{E}(y) = \xi = X\beta$ and $\mathrm{Cov}(y) = \sigma^2 I$, without any further assumptions on the distribution.

Assume we aim to estimate $\sum\subscript{i=1}^n \lambda\subscript{i} \xi\subscript{i} = \lambda^T X\beta$. By linearity the estimator should have the form $\delta(y) = a^T y$. Unbiasedness implies that $a^T X \beta = \lambda^T X \beta$, from which it follows that $X^T (a - \lambda) \perp \beta$ for any $\beta\in\mathbb{R}^p$, and consequently $X^T a = X^T \lambda$. Taking $m\in\mathbb{R}^n$ to be a vector of Lagrange multipliers, the minimization problem becomes,

$$
\begin{eqnarray}
a + Xm &=& 0 \nonumber \\\\\\
X^T a &=& X^T \lambda. \nonumber
\end{eqnarray}
$$

It is easily seen that this is solved by $a = X(X^T X)^{-1} X^T \lambda$ and $m = -(X^T X)^{-1} X^T \lambda$. In particular, $\hat{\beta} = (X^T X)^{-1} X^T y$ is BLUE for $\beta$.

TPE has a different approach of proving that LSE is BLUE (see Theorem 4.12 in Chapter 3, which TPE calls Gauss' Theorem on Least Squares). Moreover, it follows that LSE is also MRE among all linear estimators (see Corollary 4.13 in Chapter 3 TPE).


</div>
