---
layout: post
title: Salaries by alma mater - an interactive visualization with R and plotly
date: 2017-04-27 23:08:00 -05:00
tags:
- r
- visualization
- academia
---

![Visualization of starting salaries by college](../images/salaries_by_college/starting_salary.png)

Based on [an interesting dataset from the Wall Street Journal](http://online.wsj.com/public/resources/documents/info-Salaries_for_Colleges_by_Region-sort.html) I made the above visualization of the median starting salary for US college graduates from different undergraduate institutions (I have also looked at the mid-career salaries, and the salary increase, but more on that later). However, I thought that it would be a lot more informative, if it were *interactive*. To the very least I wanted to be able to see the school names when hovering over or clicking on the points with the mouse.

Luckily, this kind of interactivity can be easily achieved in R with the library [`plotly`](https://cran.r-project.org/package=plotly), especially due to its excellent integration with [`ggplot2`](https://cran.r-project.org/package=ggplot2), which I used to produce the above figure. In the following I describe how exactly this can be done.

Before I show you the interactive visualizations, a few words on the data preprocessing, and on how the map and the points are plotted with `ggplot2`:
* I generally use functions from the [tidyverse](http://tidyverse.org/) R packages.
* I save the data in the data frame `salaries`, and transform the given amounts to proper floating point numbers, stripping the dollar signs and extra whitespaces.
* The data provide school names. However, I need to find out the exact geographical coordinates of each school to put it on the map. This can be done in a very convenient way, by using the `geocode` function from the [`ggmap`](https://cran.r-project.org/package=ggmap) R package:
```R
school_longlat <- geocode(salaries$school)
school_longlat$school <- salaries$school
salaries <- left_join(salaries, school_longlat)
```
* For the visualization I want to disregard the colleges in Alaska and Hawaii to avoid shrinking the rest of the map. The respective rows of `salaries` can be easily determined with a `grep` search:
```R
grep("alaska", salaries$school, ignore.case = 1)
# [1] 206
grep("hawaii", salaries$school, ignore.case = 1)
# [1] 226
```
* A data frame containing geographical data that can be used to plot the outline of all US states can be loaded using the function `map_data` from the `ggplot2` package:
```R
states <- map_data("state")
```
* And I load a yellow-orange-red palette with the function `brewer.pal` from the [`RColorBrewer` library](http://colorbrewer2.org), to use as a scale for the salary amounts:
```R
yor_col <- brewer.pal(6, "YlOrRd")
```
* Finally the (yet non-interactive) visualization is created with `ggplot2`:
```R
p <- ggplot(salaries[-c(206, 226), ]) +
      geom_polygon(aes(x = long, y = lat, group = group),
                   data = states, fill = "black",
                   color = "white") +
      geom_point(aes(x = lon, y = lat,
                     color = starting, text = school)) +
      coord_fixed(1.3) +
      scale_color_gradientn(name = "Starting\nSalary",
                            colors = rev(yor_col),
                            labels = comma) +
      guides(size = FALSE) +
      theme_bw() +
      theme(axis.text = element_blank(),
            axis.line = element_blank(),
            axis.ticks = element_blank(),
            panel.border = element_blank(),
            panel.grid = element_blank(),
            axis.title = element_blank())
```

Now, entering `p` into the R console will generate the figure shown at the top of this post.

However, we want to...

## ...make it interactive

The function `ggplotly` immediately generates a [plotly](https://plot.ly/) interactive visualization from a `ggplot` object. It's that simple! :smiley: (Though I must admit that, more often than I would be okay with, some elements of the ggplot visualization disappear or don't look as expected. :fearful:)

The function argument `tooltip` can be used to specify which aesthetic mappings from the `ggplot` call should be shown in the tooltip. So, the code
```R
ggplotly(p, tooltip = c("text", "starting"),
         width = 800, height = 500)
```
generates [the following interactive visualization](https://plot.ly/~agisga/13).
<iframe width="800" height="500" frameborder="0" scrolling="no" src="//plot.ly/~agisga/13.embed"></iframe>

Now, if you want to publish a plotly visualization to <https://plot.ly/>, you first need to communicate your account info to the plotly R package:
```R
Sys.setenv("plotly_username" = "??????")
Sys.setenv("plotly_api_key" = "????????????")
```
and after that, posting the visualization to your account at <https://plot.ly/> is as simple as:
```R
plotly_POST(filename = "Starting", sharing = "public")
```

## More visualizations

Finally, based on [the same dataset](http://online.wsj.com/public/resources/documents/info-Salaries_for_Colleges_by_Region-sort.html) I have generated an interactive visualization of the median mid-career salaries by undergraduate alma mater (the R script is almost identical to the one described above).
[The resulting interactive visualization](https://plot.ly/~agisga/15) is embedded below.
<iframe width="800" height="500" frameborder="0" scrolling="no" src="//plot.ly/~agisga/15.embed"></iframe>
Additionally, it is quite informative to look at a [visualization of the salary increase from starting to mid-career](https://plot.ly/~agisga/11).
<iframe width="800" height="500" frameborder="0" scrolling="no" src="//plot.ly/~agisga/11.embed"></iframe>
