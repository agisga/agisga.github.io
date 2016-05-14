---
layout: post
title: NMatrix with Intel MKL on my university's HPC
---

In order to use [NMatrix](https://github.com/SciRuby/nmatrix) for the statistical analysis of big genomic data, I decided to install it on my university's high performance computing system (HPC). It is called [Cypress](http://crsc.tulane.edu/) (like the [typical New Orleans tree](http://imgc.allpostersimages.com/images/P-473-488-90/64/6420/5OV9100Z/posters/paul-souders-cypress-reflected-in-bayou-along-highway-61-on-stormy-summer-afternoon-new-orleans-louisiana-usa.jpg)), and it's currently the 10th best among all American universities. 

At first, I tried to install the latest development version of `nmatrix` and `nmatrix-atlas` or `nmatrix-lapacke` in the same way as I do it on my laptop or desktop. However, this failed in the compilation stage because the BLAS and LAPACK libraries could not be found.

Therefore, I decided to put some more effort into it, and install NMatrix with support for Intel MKL. [Intel MKL (or Math Kernel Library)](https://software.intel.com/en-us/intel-mkl) promises BLAS and LAPACK functionality with much better performance on Intel hardware than the alternatives (such as ATLAS). Additionally, on Cypress, automatic offload of some LAPACK routines to the [Xeon Phi Coprocessors](http://www.intel.com/content/www/us/en/processors/xeon/xeon-phi-detail.html?gclid=CKrYx9LGtcgCFc2PHwodG9YLuw&gclsrc=aw.ds) can be enabled at run time, when Intel MKL is used.

I document the installation process in what follows (mainly for myself, in case I need to do it again).

# Installation

Cypress uses the `module` utility to manage multiple compilers, set environment variables, etc. In order to use Ruby as well as Intel MKL (which is contained in the Intel Parallel Studio XE suite), I need to load the corresponding modules:

```
$ module load ruby
$ module load intel-psxe
```

Now I can use Ruby in version 2.2.3 as well as the Intel compiler suite and Intel MKL in my current session on Cypress. However, before installing NMatrix, I need to install its dependencies such as `bundler`.

## Installing gems in the user's home directory 

As a student I of course don't have permission to install software system-wide on my university's HPC. The option `--user-install` can be used with `gem install` to install gems locally in the user's home directory. For more convenience one can add the line

```
gem: --user-install
``` 

to `.gemrc`. This way I can install `bundler`.

The remaining dependencies of `nmatrix` are installed with `bundle install`. In order for it to work, however, I need to add my local gem executable directory to path. In my case this is done with 

```
export PATH=$PATH:/home/agossman/.gem/ruby/2.2.0/bin/
```

Also, `bundle install` needs to be invoked with an option for installation in the home directory, which in my case is: 

```
bundle install --path /home/agossman/.gem/ruby/2.2.0/
```

## Installing NMatrix and NMatrix-lapacke with Intel MKL

I followed the advice given in a comment in [`nmatix/ext/nmatrix_lapacke/extconf.rb`](https://github.com/SciRuby/nmatrix/blob/b7d367f544a9d48af5f1b9dedb7ef6adcf488091/ext/nmatrix_lapacke/extconf.rb#L178):

```
#To use the Intel MKL, comment out the line above, and also comment out the bit above with have_library and dir_config for lapack.
#Then add something like the line below (for exactly what linker flags to use see https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor ):
#$libs += " -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_core -lmkl_sequential "
```

However, it took me a while to figure out the right linker flags. I used the [MKL link line advisor](https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor). Screen shots of inputs leading to working link lines can be found at the bottom of this page.

### The "right" link line

There are three types of linking &mdash; static, dynamic, and SDL (single dynamic library).

#### Stuff that didn't work

1. I couldn't get `nmatrix-lapacke` to compile with dynamic linking (it complained that some BLAS function cannot be found). However, static and SDL linking work (see below).
2. If the linked interface layer is [ILP64 (which uses 64-bit integer type as opposed to 32-bit in the LP64 libraries)](https://software.intel.com/en-us/node/528524), then `nmatrix-lapacke` crashes at runtime (always), even if it compiled and installed without complaints (using either static or SDL linking).
3. [Automatic offloading to Intel Xeon Phi coprocessors](https://wiki.hpc.tulane.edu/trac/wiki/cypress/XeonPhi) (see below).

#### Linking flags that worked:

0. The line given in the above NMatrix code comment does actually work. However, I don't think that it is the optimal choice for the given system, because it does not use the specific features of the Parallel Studio XE suite employed on Cypress (such as parallelism).

1. Using static linking with the MKL LP64 libraries, `nmatrix-lapacke` can be compiled with the support for automatic offload to the Intel Xeon Phi Coprocessor (there are two of those at every cluster node). It compiles, passes the tests, and installs. However, when I tried to [enable the automatic offload by setting `MKL_MIC_ENABLE` to 1](https://wiki.hpc.tulane.edu/trac/wiki/cypress/XeonPhi), I couldn't get my Cholesky factorization toy problem to work (see below). With automatic offload disabled (`unset MKL_MIC_ENABLE`), everything works fine.

   In this case, the following link line needs to be added to [`nmatix/ext/nmatrix_lapacke/extconf.rb`](https://github.com/SciRuby/nmatrix/blob/b7d367f544a9d48af5f1b9dedb7ef6adcf488091/ext/nmatrix_lapacke/extconf.rb#L178):
   
   ```
   $libs += " -Wl,--start-group ${MKLROOT}/lib/intel64/libmkl_intel_lp64.a ${MKLROOT}/lib/intel64/libmkl_core.a ${MKLROOT}/lib/intel64/libmkl_intel_thread.a -Wl,--end-group -liomp5 -ldl -lpthread "
   ```

2. Using linking via SDL, `nmatrix-lapacke` compiles, passes the tests, installs, and works great. However, usage of Intel Xeon Phi Coprocessors is not possible if SDL is used for linking.

   SDL offers further, rather convenient features of [selection of the threading and interface layer at run time](https://software.intel.com/en-us/node/528522):

   > To set the threading layer at run time, use the `mkl_set_threading_layer` function or set `MKL_THREADING_LAYER` variable to one of the following values: `INTEL`, `SEQUENTIAL`, `PGI`. To set interface layer at run time, use the `mkl_set_interface_layer` function or set the `MKL_INTERFACE_LAYER` variable to `LP64` or `ILP64`. 

   The necessary link line that should be used in [`nmatix/ext/nmatrix_lapacke/extconf.rb`](https://github.com/SciRuby/nmatrix/blob/b7d367f544a9d48af5f1b9dedb7ef6adcf488091/ext/nmatrix_lapacke/extconf.rb#L178) is:

   ```
   $libs += " -Wl,--no-as-needed -L${MKLROOT}/lib/intel64  -lmkl_rt -lpthread "
   ```

### Final steps

After the linking flags have been determined and added into the code, the development version of `nmatrix` and `nmatrix-lapacke` can be compiled, tested, and installed as described in the [NMatrix README](https://github.com/SciRuby/nmatrix) with the following lines of terminal input:

```
$ bundle exec rake compile nmatrix_plugins=lapacke
$ bundle exec rake spec nmatrix_plugins=lapacke
$ bundle exec rake install nmatrix_plugins=lapacke
```


## Simple performance tests

I performed some quick tests for different installations of `nmatrix` and `nmatrix-lapacke`.

### SVD test

Consider the SVD of a 100 &times; 100 matrix:

```ruby
10000.times do |i|
  a = NMatrix.random([100,100], dtype: :float64)
  u, s, vt = a.gesvd

  # check the result for correctness
  s = NMatrix.diagonal(s)
  svd = (u.dot s).dot vt
  unless (svd - a).all? { |entry| entry.abs < 1e-12 }
    puts "SVD does not work!"
  end 
end
```

The results are:

* Cypress, NMatrix compiled with static linking to MKL:  180817 milliseconds
* Cypress, NMatrix compiled with linking via SDL, with threading layer `INTEL`:  180839 milliseconds 
* Cypress, NMatrix compiled with linking via SDL, with threading layer `SEQUENTIAL`:  83401 milliseconds 
* My laptop (`nmatrix-lapacke` with Atlas):  122455 milliseconds

### Cholesky factorization test

Consider a Cholesky factorization of a 5000 &times; 5000 matrix:

```ruby
10.times do |i|
  a = NMatrix.random([5000,5000], dtype: :float64)
  b = a.dot a.transpose
  b.factorize_cholesky
end
```

The results are:

* Cypress, NMatrix compiled with static linking to MKL:  47016 milliseconds
* Cypress, NMatrix compiled with static linking to MKL, with Intel Xeon Phi Coprocessor automatic offload enabled: runtime error (says matrix not symmetric)
* Cypress, NMatrix compiled with linking via SDL, with threading layer `INTEL`:  46549 milliseconds 
* Cypress, NMatrix compiled with linking via SDL, with threading layer `SEQUENTIAL`:  148072 milliseconds
* My laptop (`nmatrix-lapacke` with Atlas): 327146 milliseconds

### Conclusion

In particular, we see that for bigger matrices, multi-threading improves performance, while sequential execution is better for smaller matrices.

Based on these results I decided to compile `nmatrix-lapacke` on Cypress with linking to MKL via SDL, as it offers the flexibility of [selecting the threading layer at runtime](https://software.intel.com/en-us/node/528522).

### Appendix: [MKL link line advisor](https://software.intel.com/en-us/articles/intel-mkl-link-line-advisor) screen shots

![SDL link line](/images/link-line-1.png?raw=true)
![Static linking link line](/images/link-line-2.png?raw=true)
