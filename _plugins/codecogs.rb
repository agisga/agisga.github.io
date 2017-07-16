# The below is based on https://github.com/cboettig/labnotebook/blob/master/_plugins/jekyll-labnotebook-plugins/codecogs.rb
# Some modifications were made by Alexej Gossmann (July 2017).
#
# Title: codecogs plugin
# Author: Carl Boettiger, @cboettig
# License: MIT
#
# A simple filter to replace mathjax-latex syntax with images of the
# equations as rendered by codecogs.  This is useful to filter content
# entered into the atom feed, where javascript and css-based rendering
# of equations won't work.

# Credits to Noam Ross http://www.noamross.net/blog/2012/4/4/math-in-rss-feeds.html for inspiring this approach and to
# helpful folks on SO for the regexpr: http://stackoverflow.com/questions/13166112/ruby-regexp-to-replace-equations

# Example use:
#
# {{ post.content | codecogs }}
# or actually
# {{ post.content | codecogs | xml_escape }}
#

module Jekyll
  module ImageFilter
    def codecogs(input)
      # now this replaces MathJax code with codecogs url
      desired = input.gsub(%r{<script type="math/tex; mode=display">\s*(.*?)\s*</script>},
                           "<div style=\"text-align:center;\"><img src=\"http://latex.codecogs.com/png.latex?\\1\" alt=\"\\1\" /></div>")
      desired.gsub!(/\$\s*(.*?)\s*\$/, "<img src=\"http://latex.codecogs.com/png.latex?\\1\\inline\"/>")
      # this is a dirty hack to deal with my custom defined TeX Macros for MathJax:
      desired.gsub!(/\\subscript\{\s*(.*?)\s*\}/, "_{\\1}")
      desired.gsub(/\\superscript\{\s*(.*?)\s*\}/, "^{\\1}")
    end
  end
end
Liquid::Template.register_filter(Jekyll::ImageFilter)
