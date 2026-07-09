---
title: 'some CRAN Gotchas '
date: '2017-08-09'
slug: some-cran-gotchas
categories:
  - rstats
  - Blag
aliases:
  - /post/2017/08/09/some-cran-gotchas/
---

Recently I submitted `visdat` to CRAN, and have just submitted `naniar` to CRAN as well (fingers crossed!).

There were a couple of small things that I changed in order to get everything on CRAN OK, and I thought it might be helfpul to list them here, both for me, and for others, and also for others to comment on.


# `Package Version too large.`

I use pkgdown to make my website docs for visdat and naniar. It's really nifty, and looks super pro with minimal work from me. The files are a bit weird, so I thought that this error was to do with that.

Cue this [SO thread](https://stackoverflow.com/questions/36701433/r-package-building-with-devtoolsbuild-win-version-contains-large-components)

Nope, this is **literally** to do with the package version - once I changed it to 0.1.0 everything worked fine. 

# Figures in example code.

I was getting a strange error about things in the doc folder being too large, I can't find it now (re-writing this blog post in 2019!), but it was there.

This made me go through and compress all my PNG images in the pkgdown `docs` folder. I worked really hard on trying to fix this. What this the solution to the problem?

No. 

The answer? Don't have too many figures in your examples. Use `\dontrun{}` like so:

```
#' @examples
#' \dontrun{
#' library(ggplot)
#' # example plotting code here
#' }
```

# README figures

I decided to move the rmd figures inside the `man/` folder by setting the fig.path option in a code chunk of the `README.Rmd`:

<pre><code>---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->

&#96;&#96;&#96;{r, echo = FALSE}&#96;r''
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "man/figures/README-"
)
&#96;&#96;&#96;</code></pre>

Which I copied off of what I had seen in the [ggplot2 README](https://github.com/tidyverse/ggplot2/blob/master/README.Rmd#L11). That's a nice thing about github - want to know some kind of best practice? Check out what the rstudio tidyverse team does.

(Edit: this option is now part of `usethis::use_readme_rmd()`)

# It's on CRAN - what next?

- Add a cran status badge with `usethis::use_cran_badge()`, and copy and paste the text provided.
- Add a cran downloads badge by going to https://cranlogs.r-pkg.org/ and entering in your pkg name.

# Some reflections

In general, I have held off from submitting to CRAN because I was scared of getting something wrong. I wrote my first R package in 2013, thanks largely to [Hilary Parker's amazing blog post](https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/) and then following through with [Hadley's R Packages book](http://r-pkgs.had.co.nz/). But I have held off on putting things on CRAN for a long time.

In some ways, this has made things good, for example, `visdat` changed name 3 times (footprintr -> vizdat -> visdat), and `naniar` actually changed name 4 times (ggmissing -> naniar -> narnia -> naniar). Naming things is hard.

I've also spent a large amount of time making sure that the naming of my functions has been good, and made sense. This meant changing names from

`summary_missing_variables` to `miss_var_summary`, and then establishing a naming scheme where the missing summaries and friends start with `miss_` - this makes it easier for them to be tabbed through. Similarly, there is `gg_miss_var`, which was initially `gg_missing_variables` - which I decided was too long. Iteration here took time.

But, I think that I'll back myself in the future more now. Having github there as a way to test out ideas, and rapidly change things has been really nice, and in some ways has saved me time.

But it leaves me wondering - maybe had I put these packages out onto CRAN sooner then maybe I would have gotten more feedback from a wider audience?
