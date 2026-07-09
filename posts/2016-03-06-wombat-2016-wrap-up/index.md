---
title: "WOMBAT 2016 Wrap Up"
date: "2016-03-06"
categories:
- Blag
- rbloggers
- rstats
slug: wombat-2016-wrapup
aliases:
  - /post/2016/03/06/wombat-2016-wrapup/
---

A few weeks ago I spoke at the [Workshop Organized by Monash Business Analytics Team (WOMBAT)](http://wombat2016.org/), held in the Melbourne Zoo (!) on Thursday and Friday the 18th and 19th February.

It was my first time at the Melbourne Zoo, and my first time having a conference in a Zoo. It was a pretty surreal experience briskly walking to the conference room while trying to navigate a zoo, passing monkeys, macaws, and tigers. And during the lunch breaks you could sit down and chat with other conference attendees...or go and see the Orangutan show, watch the elephants get a clean, or see some Gorillas.

Two other colleagues from QUT also attended, Amy Cook (as a contributed speaker), and Dr. Zoé van Havre (as an invited Speaker). Amy is currently completing a Masters by research in statistics, and Zoé has just finished her PhD in Statistics and is about to complete a Post-Doc at CSIRO.

The conference was organised by [Di Cook](dicook.github.io) and [Rob Hyndman](http://robjhyndman.com/), of the Monash Business School. Di Cook is well known for her work in [visualisation and software](https://dicook.github.io/research.html). Di  also supervised both Hadley Wickham and Yihui Xie. Hadley has improved the R experience drastically with packages ggplot2, dplyr, tidyr, and devtools. Yihui wrote the package `knitr`, making reproducible reporting easy and fun to do in R. Rob Hyndman is the creator and maintainer of the [`forecast`](https://cran.r-project.org/web/packages/forecast/index.html) package, and has written a [free online textbook on forecasting](https://www.otexts.org/fpp).

Hadley Wickham was they Keynote speaker for the conference. Hadley's talk discussed one way to go about summarizing large datasets by fitting many models using [`purrr`](https://github.com/hadley/purrr). `purrr` takes a functional programming approach so you emphasises the verbs in your data anyalsis. This approach means that you can avoid writing loops so that you emphasize actions rather than book keeping. I had always been told that you should avoid writing loops in R because they are slow. However, Hadley said the following about that when asked about performance differences between apply, purrr, and for loops:

> A lot of people tell you to not use for-loops because they are slow - __that is complete and utter garbage__. You should not use for loops because they are not very expressive. The speed is almost the same for any trivial operation. The overhead of a for-loop is not significant. The reason to avoid for loops is because they make your code harder to read and harder to write.

So why do we hear that loops are slow in R? Apparently it is an Historical Hangover from the S language, and the early days of R. Credit to [Thomas Lumley](http://www.statschat.org.nz/) for pointing this out.

The conference organisers filmed the keynote talk from Hadley, and you can watch the video [here](https://www.youtube.com/watch?v=hRNUgwAFZtQ) and see Hadley's slides [here](http://wombat2016.org/slides/hadley.pdf). I Highly recommend watching the talk.

Zoé delivered an awesome talk that was really appropriate for the audience and did a great job of condensing 4 years of her PhD on Bayesian Mixture Models into something that everyone could understand. It was also very satisfying to see Zoé answer the question at the end “How did you choose your prior?” in excellent style, clearly demonstrating the depth of her knowledge on Bayesian stats. It was clear that Zoe could communicate "bleeding edge” statistics in a technical and non-technical sense. Awesome job. You can see her slides [here](https://zoevanhavre.github.io/talks/Feb2016_WOMBAT/ZvH_WombatSlides.html#1) and read her paper on Mixture Models [here](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0131739).

Amy spoke excellently about how to extract and use data from timesheets. The first question out of people’s mouths at the end of the talk was “how much money have you made from this idea?” - she then had a lot of people describe to her how her idea is commercially viable. Very cool. You can see slides [here](http://wombat2016.org/slides/amy.pdf).

I delivered a talk on two packages I have developed alongside Miles McBain and Di Cook: [`visdat`](https://github.com/njtierney/visdat) and `ggmissing`, (which is now [`narnia`](https://github.com/njtierney/narnia)). The idea of `visdat` is to allow you do visualise an entire dataframe at once, and `ggmissing` extends ggplot to incorporate missingness, similar to ggobi.  I had some good questions at the end, with some cool suggestions like including natural language processing to highlight specific characters/patterns, and that `vis_miss` could run some missingness diagnostics and provide a warning message to the user along the lines of "you might have variables MAR, investigate further". I shall talk more about this in a future blog post. 


It looks like WOMBAT might be an annual occurence, I would highly encourage attending the next one if you have the opportunity. Thank you once more to the conference Organisers for putting together such an awesome conference. Looking forward to the next one!
