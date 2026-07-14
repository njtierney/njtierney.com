---
title: 'Continuing to Improve R’s Ability to Visualise and Explore Missing Values: Milestone 1'
author: Nicholas Tierney
date: '2023-04-24'
slug: improving-missing-data-m1
categories:
  - Missing Data
  - data visualisation
  - ggplot2
  - rstats
tags:
  - data science
  - missing-data
  - tidyverse
  - rstats
draft: no
output: hugodown::md_document
rmd_hash: 016e21a680aad4d6

---

I am very pleased to say that I have received funding from the R consortium for improving R's capacity to explore and handle missing values! More accurately, this funding was initially awarded in 2022, but this has been bubbling along now and is now picking up steam, so I wanted to give an update. In this blog post I will discuss the first milestone for this project, and outline the plan for the next one.

Here is an excerpt from the first milestone:

> Part one: Evaluating additional missing data visualisations We will explore additional visualisations that have been implemented for exploring missing data, which are not yet implemented in the R packages {visdat} or {naniar}. This will include, for example, looking at other software languages, such as {missingno} in Python: <https://github.com/ResidentMario/missingno>. In addition to this, we will review the existing requests and ideas that are currently listed in the {naniar} and {visdat} repositories - there are many ideas here, and part of this initial work will be identifying the low hanging fruit for easy implementations. Throughout all of these parts, we will be engaging with the community, and other key contributors to these projects.

I'd like to now outline how I've addressed milestone one, and what the plans are from here!

## Milestone one: Outline feature set to implement in the first round (M1)

### Find a suitable developer for this project

Due to my current time constraints and capacity for supervision, it was simplest for myself to be the developer for this project.

### Identify key areas of maintenance required for software

Some of key areas of maintenance were outlined and addressed in releases that we have submitted to CRAN:

-   In February 2023 for visdat version o.6.0, which was discussed in a blog post [here](https://www.njtierney.com/post/2023/02/02/visdat-060/),
-   In February 2023, for naniar, version 1.0.0, which was discussed [here](https://www.njtierney.com/post/2023/02/07/naniar-version-1/)

In the next release, we will be implementing other maintenance areas alongside the new features for naniar and visdat.

### Identify feature set for round one

There are always more features to add, and I wanted to be conscious of scope creep stopping a version of software from getting released. So I have implemented two stages of releases: the first a maintenance release, the second a "feature release", in which I have also added "priority" labels, in which I have labelled the features that have the greatest impact/ease of implementation as priority 1 through to priority 3.

#### For {naniar}

This has been broken up into two parts, there is a maintenance set, and a feature set. These are outlined in the milestones for [version 1.1.0](https://github.com/njtierney/naniar/milestone/6), and [version 1.2.0](https://github.com/njtierney/naniar/milestone/7).

Some of these maintenance components include:

-   Implementing shapes in `geom_miss_point()` ([#290](https://github.com/njtierney/naniar/issues/290))
-   Allowing `impute_below()` to work for dates ([#158](https://github.com/njtierney/naniar/issues/158))
-   Using the `cli` package for warnings and error messages ([#326](https://github.com/njtierney/naniar/issues/326))
-   deprecating functions `shadow_shift()` ([#193](https://github.com/njtierney/naniar/issues/193)) and `miss_var_cumsum()` and `miss_case_cumsum()` ([#257](https://github.com/njtierney/naniar/issues/257))

And some of the features include:

-   More imputation helpers (imputing zero, median, mode, etc) ([#261](https://github.com/njtierney/naniar/issues/261) and [#213](https://github.com/njtierney/naniar/issues/213))
-   Helpers for dropping columns with set amounts of missingness ([#317](https://github.com/njtierney/naniar/issues/317))
-   Providing a nice print method for a summary of missing data ([#317](https://github.com/njtierney/naniar/issues/317))
-   More geoms for naniar, such as `geom_miss_rug()` ([#225](https://github.com/njtierney/naniar/issues/225))
-   Improving support for `across` in the package functions ([#262](https://github.com/njtierney/naniar/issues/262))

Again, for a full list of these, see the milestones for [version 1.1.0](https://github.com/njtierney/naniar/milestone/6), and [version 1.2.0](https://github.com/njtierney/naniar/milestone/7). The plan is to complete both of these sets and then submit them to CRAN.

#### For {visdat}

Similarly, for visdat, there are some further maintenance issues and then a feature set of issues, which you can see in milestones [version 0.7.0](https://github.com/ropensci/visdat/milestone/3) and [version 0.8.0](https://github.com/ropensci/visdat/milestone/5)

Some of the maintenance issues include:

-   Colour scale is incorrect when all data is missing ([#98](https://github.com/ropensci/visdat/issues/98))
-   Exposing data and summaries for plot methods ([#83](https://github.com/ropensci/visdat/issues/83))

Some of the feature issues include:

-   Implementing `vis_fct` for visualising factors ([#91](https://github.com/ropensci/visdat/issues/91))
-   Implement facetting for vis_value(), vis_binary(), vis_compare(), vis_expect(), and vis_guess(). ([#159](https://github.com/ropensci/visdat/issues/159))

## Summary

Thanks to the R Consortium for providing support for this project, I am very excited to be sharing these updates with the R community, and to be making new improvements to how we think about missing data in R.

## Your Turn

Are there things I've missed? Other features you'd like to see implemented? Please do drop a comment in this blog post, or [write an issue in naniar](https://github.com/njtierney/naniar/issues/new), or [write an issue in visdat](https://github.com/ropensci/visdat/issues/new).

