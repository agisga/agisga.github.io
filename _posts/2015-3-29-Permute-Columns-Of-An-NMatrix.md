---
layout: post
title: NMatrix column permutations
---

Recently I got surprised by the behaviour of `#permute_columns` in the *Ruby* gem *NMatrix*.

Assume we have a matrix *A* consisting of five columns *a0, a1, a2, a3, a4*, and assume that we want to reorder them as *a2, a0, a3, a4, a1*.
In *Matlab* or *R* we could easily supply the vector *(3, 1, 4, 5, 2)* as the column index in order to get the desired column permutation.
With the current version of *NMatrix* however, we have to supply the array `[2, 2, 3, 4, 4]` as input to the method `#permute_columns` (additionally, the permutation array is not unique, see below).

The reason for this behaviour of *NMatrix* is that `#permute_columns` is using the *laswp* LAPACK function under the hood, where the permutation array represents a sequence of pair-wise permutations which are performed successively. That is, the ith entry of the array is the index of the column to swap the ith column with, having already applied all earlier swaps. 

Thus, in our example with the permutation array `[2, 2, 3, 4, 4]` the following is happening:

  1. In the original matrix swap column 0 with column 2: *a2, a1, a0, a3, a4*
  2. In the result from previous step swap column 1 with column 2: *a2, a0, a1, a3, a4*
  3. In the result from previous step swap column 2 with column 3: *a2, a0, a3, a1, a4*
  4. In the result from previous step swap column 3 with column 4: *a2, a0, a3, a4, a1*
  5. In the result from previous step swap column 4 with column 4: *a2, a0, a3, a4, a1*

Notice, that under this convention the permutation array is also not unique. For example `[4, 3, 2, 1, 0]` or `[4, 1, 2, 3, 4]` or simply `[4]` all yield the reordering *a4, a1, a2, a3, a0*.

A lot of times in scientific computation, one needs to reorder the columns of a matrix in a specific order. It seems very inconvenient having to sit down with a pen and a piece of paper in order to translate the new column order into the sequence of successive pair-wise permutations that the `#permute_columns` method is currently requiring (I think that most people would have to do that if they needed a more complicated permutation than swapping of two columns).

I thought that it would be nice to have a more intuitive *Matlab*-like behaviour for `#permute_columns`, where the method argument would be the desired new order of columns of the matrix. In order to not break back compatibility however, the intuitive behaviour of `#permute_columns` should be an option, while the current permutation would be the default behaviour. This can be achieved by introducing an argument `:convention` which can either can be `:lapack` (the default) or `:intuitive`. That is, in the example from above we would use the permutation vector `[2, 0, 3, 4, 1]` and set `:convention` to `:intuitive` in order to get the desired reordering *a2, a0, a3, a4, a1*.

So, a translation function is required which is going to take as input the *Matlab*-style permutation array and output a corresponding *LAPACK*-style permutation. Then the *LAPACK*-style permutation can be plugged into the existing column permutation algorithm. 

I came up with a rather simple algorithm for such a translation.
Basically, in the step `i` of the algorithm, the column which should be in position `i` in the end is going to be swapped with whatever column is at position `i`.

Assume the desired order of columns is given in the array `final_order`. 
We construct an array `p` of pair-wise permutations. Since the pair-wise permutation are performed successively,
we need to keep track of the order of columns after every permutation. Therefore we initialize the array `order = [0,1,2,3,4,...,n-1]`.
We run the following iterative procedure:

  1. Swap `order[0]` with `order[k]` where `k = final_order[0]`. Save `p[0] = k`.
  2. Swap `order[1]` with `order[k]` where `k` is the index such that `order[k] = final_order[1]`. Save `p[1] = k`.
  3. Swap `order[2]` with `order[k]` where `k` is the index such that `order[k] = final_order[2]`. Save `p[2] = k`.
  4. etc.

It is apparent that the procedure is going to produce a sequence of permutations, such that the ith permutation, puts the column which should be in position `i` in the end into position `i`.

Here is my implementation of `#laswp!` (`#permute_columns` merely calls it), which allows the user to use the intuitive Matlab-style column permutation by setting the option `:convention` to `:intuitive`.

```Ruby
  #
  # call-seq:
  #     laswp!(ary) -> NMatrix
  #
  # In-place permute the columns of a dense matrix using LASWP according to the order given as an array +ary+.
  #
  # If +:convention+ is +:lapack+, then +ary+ represents a sequence of pair-wise permutations which are 
  # performed successively. That is, the i'th entry of +ary+ is the index of the column to swap 
  # the i'th column with, having already applied all earlier swaps. This is the default.
  #
  # If +:convention+ is +:intuitive+, then +ary+ represents the order of columns after the permutation. 
  # That is, the i'th entry of +ary+ is the index of the column that will be in position i after the 
  # reordering (Matlab-like behaviour). 
  #
  # Not yet implemented for yale or list. 
  #
  # == Arguments
  #
  # * +ary+ - An Array specifying the order of the columns. See above for details.
  # 
  # == Options
  # 
  # * +:covention+ - Possible values are +:lapack+ and +:intuitive+. Default is +:lapack+. See above for details.
  #
  def laswp!(ary, opts={})
    raise(StorageTypeError, "ATLAS functions only work on dense matrices") unless self.dense?
    opts = { convention: :lapack }.merge(opts)
    
    if opts[:convention] == :intuitive
      if ary.length != ary.uniq.length
        raise(ArgumentError, "No duplicated entries in the order array are allowed under convention :intuitive")
      end
      n = self.shape[1]
      p = []
      order = (0...n).to_a
      0.upto(n-2) do |i|
        p[i] = order.index(ary[i])
        order[i], order[p[i]] = order[p[i]], order[i]
      end
      p[n-1] = n-1
    else
      p = ary
    end

    NMatrix::LAPACK::laswp(self, p)
  end
```

