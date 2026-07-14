---
title: "Introducing 'R-Miss-Tastic'"
date: "2019-01-29"
slug: "intro-r-miss-tastic"
aliases:
  - /post/2019/01/29/intro-r-miss-tastic/
---

Missing data has been something I've been working on in my research since I started my PhD in 2013. This was largely because I was clued in to the whole _idea_ of missing data in my fourth year stats unit in Psychology where we had a few lectures on missing data. Data was always super clean for all of our pracs in SPSS. So, it was a pretty profound moment for me, missing data was the start of the whole idea that data could be _not clean_. 

When I started my PhD I had a pretty huge amount of missing data in the first dataset I looked at, which led me to write my first paper, ["Using Decision Trees to Understand Structure in Missing Data."](http://bmjopen.bmj.com/content/5/6/e007450.full) to help understand the missing data structure. Since then, I've written two R packages to help work with,and understand missing data, [`visdat`](visdat.njtierney.com), and [`naniar`](naniar.njtierney.com), along with accompanying papers for each - ["visdat: visualising whole dataframes"](http://joss.theoj.org/papers/10.21105/joss.00355), and ["Expanding tidy data principles to facilitate missing data exploration, visualization and assessment of imputations."](https://arxiv.org/abs/1809.02264). So missing data is something I have thought a fair bit about.

In early 2018, I was very fortunate to hear from [Julie Josse](http://juliejosse.com/) about an idea for an R Consortium grant about making a platform to share missing data. We submitted a grant, and were stoked to be funded! The project was called: ["A Unified platform for missing values methods and workflows"](https://www.r-consortium.org/announcement/2018/05/29/announcing-the-r-consortium-isc-funded-project-grant-recipients-for-spring-2018), and was comprised of four parts:

1. Curating available R packages for missing data in a CRAN task View
2. Curating articles and related work on missing data by theme
3. Collating Tutorials and workflows
4. Future extensions and beyond

Thanks to Julie, the group soon expanded to include [Nathalie Vialaneix](http://www.nathalievialaneix.eu/), who brought great strength to the team, having recently [written an article summarising the many R packages for missing data](http://journal-sfds.fr/article/view/681).

We met virtually many times throughout 2018 to discuss the plan for the year, and decided upon a name for the group, "R-Miss-Tastic". 

The name, "R-Miss-Tastic", was chosen because it evokes a feeling of the words "Little Miss Fantastic", "Armistice", as well as the "R" language, and the word "miss". Together, we see this name as symbolising that we are working with R, we want to do a fantastic job with missing data, and we want to bring peace (armistice), to the often frustrating task of working with missing data. 

We created a [GitHub organisation to house our ideas as repositories](https://github.com/R-miss-tastic), in an open and public way. We were also very fortunate to be able to meet in person at the 2018 UseR conference, held in Brisbane, Australia.

# Part One: Curating available R packages for missing data in a CRAN task View

So far, the majority of our work has focussed on our first milestone: "Curating available R packages for missing data in a CRAN task View". 

At the time, there was no task view specific to missing data, aside from sections social sciences (https://cran.r-project.org/web/views/SocialSciences.html) and Multivariate Statistics (https://cran.r-project.org/web/views/Multivariate.html). We curated a list of packages based on an initial search of all packages containing key words. The packages were then summarised and collated into a CRAN Task View (CTV). The CTV is now completed and has been published online: https://cran.r-project.org/web/views/MissingData.html. The development version of the CTV is available here at this github repository, https://github.com/R-miss-tastic/missing-data-taskview. The process for generating the CTV can be seen here: https://github.com/R-miss-tastic/missing-data-taskview/issues/5.

The missing data CTV has been received well in the community. It was retweeted and favourited many times on twitter

<blockquote class="twitter-tweet"><a href="https://twitter.com/i/web/status/1054655578700742657"></a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

<!-- (https://twitter.com/AchimZeileis/status/1054655578700742657) -->

We also had a separate blog post praising it on [RStudio's R Views blog](https://rviews.rstudio.com/2018/10/26/cran-s-new-missing-values-task-view/). 

We have since been contacted many times by packages authors enquiring about how they can add their own package to the CRAN task view. We know that those who work with and develop tools and analyses for missing data are spread far around the world. And we are happy to say that being a part of a group associated with the R Consortium provides a strong focal point for members to rally behind.

The second and third parts of our work are to **curate articles and related work on missing data by theme**, and **collate tutorials and workflows** on missing data. 

We have established a website to house these articles, tutorials, and workflows https://rmisstastic.netlify.com/ - and can be found at this repository. To help populate the website and curate the articles, Julie Josse has hired a talented student, Imke Mayer. Imke is currently organizing meetings with main actors of the missing values community, and collating these articles. To help make this project as robust as possible, **we encourage authors to submit their articles or works, and reviewers to review their placement on the platform/website.**

Future work for the website includes re-organising the tutorials on the website to group them by topic, and provide a blurb on each tutorial. R misstastic will also have a section on R packages, which will be linked with sections on datasets with missing data, and the tutorials that these datasets appear in. We will continue to provide more tutorials, R packages, and data sets as time goes on.

We have not yet reached the final step of our proposal, **future extensions and beyond**. But we believe that by providing a platform and community to discuss missing data in R, software, and approaches and workflows, we are providing a base from which we can grow. We hope that the website and the R-miss-tastic community could eventually tackle more ambitious ideas, such as collecting datasets to benchmark imputation methods, something currently not being done anywhere in the world. By having a community involved in this, we can then have useful discussion on the benchmarks and approaches to multiple imputation, even organize challenges to find the best imputation methods, perhaps in a similar fashion to the [M4 forecasting competition](https://robjhyndman.com/hyndsight/m4comp/).

Other exciting work we would like to discuss with the community discussion includes implementing other special types of missing value other than NA, such as STATAs special missing values; altering messages in base R to encourage other approaches than deleting missing observations by default, or at least indicate the risks.

On a personal note, it has been an absolute pleasure to work with Julie, Nathalie, and Imke, and I am looking forward to the future of R-Miss-Tastic!
