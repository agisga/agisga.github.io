My personal website.

It is based on the [Jekyll Now theme](http://www.jekyllnow.com/) ([github repository](https://github.com/barryclark/jekyll-now).

## Steps to publish changes

1. Make and commit changes in the `source` branch.
2. Delete branch `master`: `git branch -D master`.
2. Check out a new `master`: `git checkout -b master`.
2. Rewrite Git revision history but only look at the history which touches `_site`: `git filter-branch --subdirectory-filter _site/ -f`.
2. `git checkout source`.
2. Push all branches: `git push --all origin`.
