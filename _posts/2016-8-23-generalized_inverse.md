---
layout: post
title: Generalized inverse of a symmetric matrix
tags:
- math 
---

I have always found the common definition of the [generalized inverse](https://en.wikipedia.org/wiki/Generalized_inverse) of a matrix quite unsatisfactory, because it is usually defined by a mere property, $A A^{-} A = A$, which does not really give intuition on when such a matrix exists or on how it can be constructed, etc... 
But recently, I came across a much more satisfactory definition for the case of symmetric (or more general, [normal](https://en.wikipedia.org/wiki/Normal_matrix)) matrices. :smiley:

As is well known, any symmetric matrix $A$ is diagonalizable,

$$
A = QDQ^T,
$$

where $D$ is a diagonal matrix with the eigenvalues of $A$ on its diagonal, and $Q$ is an orthogonal matrix with eigenvectors of $A$ as its columns (which magically form an orthogonal set :astonished:, just kidding, [absolutely no magic involved](http://math.stackexchange.com/questions/82467/eigenvectors-of-real-symmetric-matrices-are-orthogonal)).

### The Definition :heart:

Assume that $A$ is of size $n\times n$ and has rank $k \leq n$. Denoting the $k$ *non-zero* eigenvalues of $A$ by $\lambda_1, \dots, \lambda_k$ and the corresponding $k$ columns of $Q$ by $q_1, \dots, q_k$, we have that

$$
A = QDQ^T = \sum_{i=1}^k \lambda_i q_i q_i^T.
$$

*We define the generalized inverse of* $A$ *by*

$$
\begin{equation}
\label{TheDefinition}
A^{-} :=  \sum_{i=1}^k \frac{1}{\lambda_i} q_i q_i^T.
\end{equation}
$$

### Why this definition makes sense :triumph:

1. The common definition/property of generalized inverse still holds:

    $$
    \begin{eqnarray}
    A A^{-} A &=& \sum_{i=1}^k \lambda_i q_i q_i^T \sum_{m=1}^k \frac{1}{\lambda_m} q_m q_m^T \sum_{j=1}^k \lambda_j q_j q_j^T \nonumber \\
    &=& \sum_{i,m=1,\dots,k} \lambda_i \frac{1}{\lambda_m} q_i q_i^T q_m q_m^T \sum_{j=1}^k \lambda_j q_j q_j^T \nonumber \\
    &=& \sum_{i=1}^k q_i q_i^T \sum_{j=1}^k \lambda_j q_j q_j^T \nonumber \\
    &=& \sum_{i,j=1,\dots,k} \lambda_j q_i q_i^T q_j q_j^T \nonumber \\
    &=& \sum_{i=1}^k \lambda_i q_i q_i^T = A, \nonumber
    \end{eqnarray}
    $$

    where we used the fact that $q_i^T q_j = 0$ unless $i = j$ (i.e., orthogonality of $Q$).

2. By a similar calculation, if $A$ is invertible, then $k = n$ and it holds that

    $$
    A A^{-} = \sum_{i=1}^n q_i q_i^T = QQ^T = I.
    $$

3. If $A$ is invertible, then $A^{-1}$ has eigenvalues $\frac{1}{\lambda_i}$ and eigenvectors $q_i$ (because $A^{-1}q_i = \frac{1}{\lambda_i} A^{-1} \lambda_i q_i = \frac{1}{\lambda_i} A^{-1} A q_i = \frac{1}{\lambda_i} q_i$ for all $i = 1,\dots,n$).

   Thus, Definition ($\ref{TheDefinition}$) is simply the diagonalization of $A^{-1}$ if $A$ is invertible.

4. Since $q_1, \dots, q_k$ form an orthonormal basis for the range of A, it follows that the matrix

    $$
    A A^{-} = \sum_{i=1}^k q_i q_i^T = Q_{1:k} Q_{1:k}^T
    $$

    is the projection operator onto the range of $A$.

### References

Definition $(\ref{TheDefinition})$ is mentioned in passing on page 87 in

* Morris L. Eaton, *Multivariate Statistics: A Vector Space Approach.* Beachwood,
Ohio, USA: Institute of Mathematical Statistics, 2007.
