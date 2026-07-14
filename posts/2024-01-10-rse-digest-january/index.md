---
title: Rstats RSE January Digest
date: '2024-01-10'
slug: rse-digest-january
categories:
  - rstats
  - research software engineer
  - rse
  - digest
  - newsletter
aliases:
  - /post/2024/01/10/rse-digest-january/
---

<figure>
<img src="img/happy-log.jpg" alt="A Happy Log, near Echo Lake, California. Fuji X100V, Nicholas Tierney." />
<figcaption aria-hidden="true">A Happy Log, near Echo Lake, California. Fuji X100V, Nicholas Tierney.</figcaption>
</figure>

I've been trying to read a bit more widely about R programming and other features of programming lately. I've seen some great newsletters from people like Bob Rudis in his ["Daily Drop" series](https://dailydrop.hrbrmstr.dev/), and I think that has inspired me to collect my monthly reading notes into a blog post / digest / newsletter type thing.

I guess to articulate more clearly, want to do it for the following reasons:

1.  Help me share bulk links of interest to the Research Software Engineer, with a focus being on those who use R.
2.  Force me to read these links so I can provide a little summary of the content.
3.  Engage more broadly with the RSE rstats community.
4.  Somewhat catch up on the technology/rstats world since I hiked the [pacific crest trail from May - October 2023](https://njt.micro.blog/).

My intention is for these to be short lists. But this one is already getting bigger. This might be something regular, or something irregular. Who knows, maybe it's just a one off. Here we go.

# Blog / news posts

Some of these links are things I missed, and other ones are just things I thought were really good. They could be new, they could be a few years old!

[Hadley Wickham's Design Newsletter](https://tidydesign.substack.com/). I've followed Hadley's work quite closely since 2013, and I was a little alarmed to see I had somehow missed his starting a newsletter about: "designing and implementing quality R code". I'd seen his book, ["tidy design principles"](https://design.tidyverse.org/) a while back, but it's super exciting that they are working on it again. I highly recommend the newsletter. It's also nice to see people engaging with `#rstats` content in a place that isn't social media.

The rOpenSci newletter is worth subscribing to, one of my favourite sections is the [package development corner](https://ropensci.org/blog/2023/11/24/news-november-2023/#package-development-corner), which contains lots of useful links to other cool new R features, blog posts, and more.

[Mike Mahoney's post on classed errors](https://www.mm218.dev/posts/2023-11-07-classed-errors/) really helped solidify my understanding and the overall benefits to not only the user, but the developer.

[King's Day Speech](https://neopythonic.blogspot.com/2016/04/kings-day-speech.html) by [Guido van Rossum](https://en.wikipedia.org/wiki/Guido_van_Rossum), **the creator of the python language**. A nice essay / auto biography. I especially enjoyed this quote:

> In reality, programming languages are how programmers express and communicate ideas --- and the audience for those ideas is other programmers, not computers. The reason: the computer can take care of itself, but programmers are always working with other programmers, and poorly communicated ideas can cause expensive flops.

They say, "science isn't science until it's communicated", and building on that, I think that good science requires good communication. It doesn't matter if your idea is world changing, if no one can understand it.

Bob Rudis's ["Daily Driver" post](https://dailydrop.hrbrmstr.dev/2024/01/01/drop-395-2024-01-01-happy-new-year/#) contains an amazing list of things he uses daily from hardware to OS, VPN, RSS readers, browsers, browser extensions, and more.

["Bye, RStudio/Posit!"](https://yihui.org/en/2024/01/bye-rstudio/) by Yihui Xie. He's leaving Posit! It came as a surprise to me. I have a lot of positive feelings about his incredible contributions to R and my career and life, I can't condense them all here. But I know that his work on knitr, rmarkdown, xaringan, blogdown, and bookdown have all had incredibly positive impacts on how I communicate my work, and I simply don't think I'd have the career I've had without him. Thank you, Yihui.

# R Packages

It's hard to pick R packages to showcase, there are I think more than 20K on CRAN now. Rather than a laundry list of R packages I use, here are some of my favourite R packages that I use.

[tidyverse](https://tidyverse.tidyverse.org/), I'd be lost without it. It is simply an outstanding collection of software for doing data science and statistics in R.

[targets](https://docs.ropensci.org/targets/), one of my favourite R packages. [Will Landau](https://wlandau.github.io/), the developer behind targets is I think perhaps the most responsive and kindest maintainer I've ever encountered.

[tflow](https://github.com/milesmcbain/tflow) by [Miles McBain](https://milesmcbain.xyz/), an ergonomic package that goes alongside the targets package. Use along with Miles's other package, [fnmate](https://github.com/milesmcbain/fnmate). I think these tips are really useful:

> 1.  Put all your target code in separate functions in `R/`. Use `fnmate` to quickly generate function definitions in the right place. Let the plan in `_targets.R` define the structure of the workflow and use it as a map for your sources. Use 'jump to function' to quickly navigate to them.

> 1.  Use a call `tar_make()` to kick off building your plan in a new R session.

> 1.  Put all your [`library()`](https://rdrr.io/r/base/library.html) calls into `packages.R`. This way you'll have them in one place when you go to add sandboxing with `renv`, `packarat`, and `switchr` etc.

> 1.  Take advantage of automation for loading `targets` targets at the cursor with the 'load target at cursor' addin. Or the `tflow` addin: 'load editor targets' to load all targets referred to in the current editor.

[autotest](https://docs.ropensci.org/autotest/) by [Mark Padgham](https://mpadge.github.io/) with [rOpenSci](https://ropensci.org/). This package does rigorous, automated testing of your R package. Useful to help really kick the tyres of your work.

And not quite an R package, but something from within [usethis](https://github.com/r-lib/usethis)/[rlang](https://github.com/r-lib/rlang/) as advertised by [Garrick Aden Buie](https://www.garrickadenbuie.com/), when [commenting on](https://aus.social/@grrrck@fosstodon.org/111564560024473157) my blog post, ["Code Smell: Error Handling Eclipse"](https://www.njtierney.com/post/2023/12/06/long-errors-smell/):

> icymi and because it's not widely publicized, there are type checking functions in {rlang} that you can copy into your package code with usethis::use_standalone() <https://github.com/r-lib/rlang/blob/main/R/standalone-types-check.R>

This is super useful because it injects selected R functions into your R package. So you can select some standalone functions to import directly into your code with:

``` r
use_standalone("https://github.com/r-lib/rlang/blob/main/R/standalone-types-check.R")
```

Importing code directly is an interesting take on things because normally in R you would import an R package, not copy over code. One benefit of this I think is that it lets you potentially tinker with the imported functions to suit your R package.

# Talks / Videos

In part of writing a bit recently, I was reminded by a friend of [Jenny Bryan's](https://jennybryan.org/) UseR! keynote from 2018, [Code Smells and Feels](https://youtu.be/7oyiPBjLAWY?si=bpmCGCJaVCysmUN5) - [talk materials](https://github.com/jennybc/code-smells-and-feels#readme). It is one of my favourite talks. I was there a few rows from the front when she gave it, but taking time to watch it again has been really great. Jenny is a talented communicator, and I'm going to list a couple of my favourite takeaways from the talk, but I don't want to start just listing the content out from the talk. These tips will make the most sense alongside Jenny's talk.

-   Write simple condition. Use explaining variables.
-   Write functions. A few little functions \>\> than monster function. Small well-named helper function \>\> commented code.
-   Every if does not need an else, if you exit or return early. There is no **else** there is only **if**.
-   If your conditions deal with **class**, it's time to get object oriented (OO), and use **polymorphism**.
-   [`switch()`](https://rdrr.io/r/base/switch.html) is ideal if you need to dispatch different **logic**, based on a **string**.
-   [`dplyr::case_when()`](https://dplyr.tidyverse.org/reference/case_when.html) is ideal if you need to dispatch different **data** based on **data (+logic)**.

[Managing many models with R](https://www.youtube.com/watch?v=rz3_FDVt9eg) by [Hadley Wickham](). I couldn't find the original keynote that I saw of this, which was at the [WOMBAT 2016 conference](). The main takeaway from this for me was understanding one of the major benefits of using functions, and understanding how to use `map`.

[The Rise of the Research Software Engineer](https://www.youtube.com/live/8ZSaAM8hhJ4?si=o_tB4C8bsNezNyZ4), by [Mike Croucher](https://walkingrandomly.com/?page_id=2). A great talk covering a story of becoming a research software engineer, the importance of diversity of people, and technology in a team.

[Naming things in code](https://www.youtube.com/watch?v=-J3wNP6u5YU) by [code aesthetic](https://www.youtube.com/@CodeAesthetic). I care a lot about naming things, and I really liked these ideas:

-   Avoid single letter variables
-   Never abbreviate
-   Don't put types in your name (e.g., Icost for Integer Cost), aka "hungarian notation".
-   Put units in variable names. e.g., weight_kg
-   Don't name variables "utils". Refactor.

# Papers

[Statistical Modeling: The Two Cultures (with comments and a rejoinder by the author)](https://projecteuclid.org/journals/statistical-science/volume-16/issue-3/Statistical-Modeling--The-Two-Cultures-with-comments-and-a/10.1214/ss/1009213726.full). It's an absolute classic paper that I found really fundamental to understanding statistical modelling during my PhD. I like it because it introduces the ideas of prediction, and extracting information (inference), which are two really important concepts. It then kind of dunks on the statistics community, saying:

> The statistical community has been committed to the almost exclusive use of data models. This commitment has led to irrelevant theory, questionable conclusions, and has kept statisticians from working on a large range of interesting current problems...If our goal as a field is to use data to solve problems, then we need to move away from exclusive dependence on data models and adopt a more diverse set of tools.

# Newsletters

I get a lot of these links from trawling through various newsletters and things on twitter and mastodon. Here are some of my current favourites.

[Monday Morning Data Science](https://fhdata.substack.com/) by the Fred Hutch group is great. Once a week, just a couple of links.

[Heidi Seibold](https://heidiseibold.com/) has a nice newsletter that I enjoy reading: <https://heidiseibold.ck.page/>

rOpenSci's newsletter - which you can subscrive to at the bottom of this [recent newsletter blog post](https://ropensci.org/blog/2023/12/22/news-december-2023/).

Bob Rudis's ["Daily Drop"](https://dailydrop.hrbrmstr.dev/) newsletter.

# Book recommendations

I've been meaning to collect together a list of books for programming. Mostly through conversations with [Maëlle Salmon](https://masalmon.eu/), I've got a few books I'd like to read. I basically just sifted through Maëlle's list of book notes and have put a couple here.

-   The Pragmatic Programmer - see some reading notes by [Maëlle Salmon](https://masalmon.eu/2023/12/11/reading-notes-pragmatic-programmer/)
-   A Philosophy of Software Design - see more reading notes by [Maëlle Salmon](https://masalmon.eu/2023/10/19/reading-notes-philosophy-software-design/)

# End

That's it. Thanks for reading! What have I missed? Let me know in the comments!

