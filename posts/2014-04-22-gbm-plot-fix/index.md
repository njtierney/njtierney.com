---
title: Fix for gbm.plot
date: "2014-04-22"
categories:
- rstats
slug: gbm-plot-fix
aliases:
  - /post/2014/04/22/gbm-plot-fix/
---

I'm currently in the process of writing a report using boosted regression trees. I'm currently using guidelines provided by Elith et al [here](http://avesbiodiv.mncn.csic.es/estadistica/bt1.pdf), and [here](http://cran.r-project.org/web/packages/dismo/vignettes/brt.pdf)

They provide the function `gbm.step`, which performs 10-fold cross validation on the boosted regression tree. It also has a nifty `gbm.plot` function, producing partial dependence plots. Unforunately, it kept giving me this error:

> `Error: could not find function "windows"`

This means that the function `windows()` is being called inside `gbm.plot()`. So I looked into what the heck `windows` is and it turns out it opens a graphics device, but is the command reserved for windows machines - I use a mac, and the equivalent command is `X11()`. I found this out thanks to [this website](http://doingbayesiandataanalysis.blogspot.com.au/2011/09/for-linux-macos-users-easy-fix-for.html).

So I simply found the source code for `gbm.plot`, and replaced `windows()` with `X11()`

Hopefully this will prove helpful to someone.
