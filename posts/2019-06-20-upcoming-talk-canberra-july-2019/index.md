---
title: 'Upcoming Talk: Canberra July 2019'
date: '2019-06-20'
slug: brolgar-csiro-2019
categories:
- rstats
aliases:
  - /post/2019/06/20/brolgar-csiro-2019/
---


While [visiting Canberra to present for the SSA R skills workshop with Damjan Vukcevic](https://www.njtierney.com/post/2019/06/19/rmd4sci-canberra/), I am going to stay in Canberra for a few days, visiting CSIRO. I will be presenting a talk there on Thursday 4th July on the [`brolgar`](https://github.com/njtierney/brolgar) package for exploring longitudinal data, which I have been working on with Di Cook. 

I am quite excited about presenting this work, longitudinal data feels like one of those things that is harder to work with than it should be, and I think some of the things we have created will be very helpful for those who work with this kind of data.

Fair warning: the `brolgar` package is about to go through a bunch of breaking changes in the next week, as I will be re-writing the API to make it consistent with [`tidyverts/feasts`](https://github.com/tidyverts/feasts). 

Details are below:

## Title: Making better spaghetti (plots): Exploring the individuals in longitudinal data with the brolgar package

## Abstract:

Longitudinal (panel) data provide the opportunity to examine temporal patterns of individuals, because measurements are collected on the same person at different, and often irregular, time points. The data is typically visualised using a "spaghetti plot", where a line plot is drawn for each individual. When overlaid in one plot, it can have the appearance of a bowl of spaghetti. With even a small number of subjects, these plots are too overloaded to be read easily. The interesting aspects of individual differences are lost in the noise.

Longitudinal data is often modeled with a hierarchical linear model to capture the overall trends, and variation among individuals, while accounting for various levels of dependence. However, these models can be difficult to fit, and can miss unusual individual patterns. Better visual tools can help to diagnose longitudinal models, and better capture the individual experiences. 

In this talk, I introduce the R package, [**brolgar** (BRowse over Longitudinal data Graphically and Analytically in R)](), which provides tools to identify and summarise interesting individual patterns in longitudinal data. 
