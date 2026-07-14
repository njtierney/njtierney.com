---
title: Simple Guide to S3 Methods
date: "2016-08-26"
categories:
- rstats
- rbloggers
slug: simple-s3-submission
aliases:
  - /post/2016/08/26/simple-s3-submission/
---

So I've just submitted my first article to [the R Journal](https://journal.r-project.org/)!

<div style="width: auto">
<img src = "https://media.giphy.com/media/1PMVNNKVIL8Ig/giphy.gif" alt = "Woohooo!" style="margin: 0px auto;display:block; width: 60%;max-height: 60%; PADDING-BOTTOM: 15px"/>
</div>

The paper, "A Simple Guide to S3 Methods", is my attempt at a quick and simple guide to using S3 methods in R. Although not my [first publication](http://bmjopen.bmj.com/content/5/6/e007450.full), it is my first _solo_ publication, which is exciting.

You can [read the pre-print on arxiv here](https://arxiv.org/abs/1608.07161).

# Why write it?

Because I think S3 methods are underused. They are elegant, simple, and **really useful**. Hadley Wickham describes them nicely in [Advanced R](http://adv-r.had.co.nz/OO-essentials.html#s3).

> S3 is informal and ad hoc, but it has a certain elegance in its minimalism: you can’t take away any part of it and still have a useful [Object Oriented] system.

# How it started

Last year I ripped some functions from a monster `if-then-else` statement, and created individual S3 methods. I kept some notes as I did this, which eventually turned into a draft blog post. However, a colleague suggested I turn the blog post into a publication for the R Journal. Why not?

# The process

I got it about 95% of the way relatively quickly thanks to fine folks like [Miles McBain](https://github.com/MilesMcBain) providing valuable feedback, and to the R package [rticles](https://github.com/rstudio/rticles) which provides a pre-built R Journal template.

However, I ran into some [issues around special characters in rticles](https://github.com/rstudio/rticles/issues/70), which halted my progress. It looked unappealing to fix in LaTeX, so it sat on the backburner.

## Until...?

I started updating my CV last week. I was reminded that I still had not submitted the S3 methods paper. I had a brainwave that I could get around my problem by silently running the code chunk and then copying and pasting the code output manually in markdown. This worked rather marvelously. You can see the RMarkdown chunk [here on github](https://raw.githubusercontent.com/njtierney/A-Simple-Guide-to-S3-Methods/master/SimpleS3.Rmd).

# Further thoughts on the paper.

The paper might miss out on some of the finer features of S3 methods, but its main goal was to get people using S3 methods by providing motivation for __why__ they might want to use them, and why they __should__ use them as opposed to writing something like a series of if-then-else loops.

I'm excited to see feedback from the R Journal, hopefully I didn't miss something terribly important about S3 methods.
