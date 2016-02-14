My personal website.

It is based on the [Jekyll Now theme](http://www.jekyllnow.com/) ([github repository](https://github.com/barryclark/jekyll-now)).

## Steps to publish changes

1. Make and commit changes in the `source` branch.
2. Delete branch `master`: `git branch -D master`.
3. Check out a new `master`: `git checkout -b master`.
4. Rewrite Git revision history but only look at the history which touches `_site`: `git filter-branch --subdirectory-filter _site/ -f`.
5. `git checkout source`.
6. Push all branches: `git push --all origin`.
