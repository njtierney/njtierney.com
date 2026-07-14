---
title: "Using table the dplyr way"
date: "2015-11-03"
categories:
  - rstats
slug: tally-dplyr-table
aliases:
  - /post/2015/11/03/tally-dplyr-table/
---

In this post I describe how to use `tally`, the `dplyr` equivalent of `table`.

`table` gives you the frequencies of something in a category. Let's use the `iris` dataset to illustrate. Let's say we want to know how many are in each species in `iris`.


```r
table(iris$Species)
```

```
## 
##     setosa versicolor  virginica 
##         50         50         50
```

So there happen to be 50 in each of the species. 

But if you want to present this in a tidy dataframe, where each column is a variable, and each row is an observation, you'd have to do some annoying reformating. But need not dispair, `dplyr` has us covered.



```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
iris.tally <- iris %>%
  group_by(Species) %>% 
  tally

iris.tally
```

```
## # A tibble: 3 x 2
##   Species        n
##   <fct>      <int>
## 1 setosa        50
## 2 versicolor    50
## 3 virginica     50
```

This gives us a neat dataframe, where we get Species as a column, and the number of observations in each Species.

One of the reasons I like this is because it means I can do something like create a table using `knitr::kable` if I need to for a report.

So I could now do this:


```r
library(knitr)

kable(iris.tally)
```



|Species    |  n|
|:----------|--:|
|setosa     | 50|
|versicolor | 50|
|virginica  | 50|

Thanks to [this SO post](http://stackoverflow.com/questions/24409376/dplyr-how-can-i-write-equivalent-to-table-base-function-and-preserve-column-n) for providing me with knowledge of `tally` and providing inspiration for this post.
