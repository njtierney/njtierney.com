---
title: 'New Paper Submission: Expanding Tidy Data For Missing Data'
date: '2018-09-10'
slug: tidy-missing-data
categories:
  - rstats
aliases:
  - /post/2018/09/10/tidy-missing-data/
---

I'm really happy to say that Di Cook and I recently submitted our paper: "Expanding tidy data principles to facilitate missing data exploration, visualization and assessment of imputations" to [JCGS](https://www.tandfonline.com/toc/ucgs20/current).

You can read the paper on arxiv [here](https://arxiv.org/abs/1809.02264).

This paper builds on the principles of tidy data to create a framework for handling, exploring, and imputing missing values. It represents the fundamental ideas that underpin the packages [`naniar`](http://naniar.njtierney.com/) and [`visdat`](http://visdat.njtierney.com/). Here is the abstract:

> Despite the large body of research on missing value distributions and imputation, there is comparatively little literature on how to make it easy to handle, explore, and impute missing values in data. This paper addresses this gap. The new methodology builds upon tidy data principles, with a goal to integrating missing value handling as an integral part of data analysis workflows. New data structures are defined along with new functions (verbs) to perform common operations. Together these provide a cohesive framework for handling, exploring, and imputing missing values. These methods have been made available in the R package [`naniar`](http://naniar.njtierney.com/).

This is the first full length paper I have written about software, and I am really grateful to have had the guidance of my co-author Di Cook - I'm really proud of this work.

I'd also like to share the acknowledgements section of the paper:

> 
The authors would like to thank [Miles McBain](http://milesmcbain.xyz/), for his key contributions and discussions on the `naniar` package, in particular for helping implement `geom_miss_point()`, and for his feedback on ideas, implementations, and names. We also thank [Colin Fay](https://colinfay.me/) for his contributions to the `naniar` package, in particular for his assistance with the `replace_with_na()` functions. We also thank [Earo Wang](https://earo.me/) and [Mitchell O'Hara-Wild](https://www.mitchelloharawild.com/) for the many useful discussions on missing data and package development, and for their assistance with creating elegant approaches that take advantage of the tidy syntax. We would also like to thank those who contributed pull requests and discussions on the `naniar` package, in particular [Jim Hester](https://www.jimhester.com/) and [Romain François](https://purrple.cat/blog/) for improving the speed of key functions, [Ross Gayler](https://sites.google.com/site/rgayler/) for discussion on special missing values, and [Luke Smith](https://seasmith.github.io/) for helping `naniar` be more compliant with `ggplot2`.

