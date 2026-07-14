---
title: "Just Quickly: What I usually want from stringr"
slug: "quick-stringr"
date: "2019-06-19"
aliases:
  - /post/2019/06/19/quick-stringr/
---

> TL;DR `str_subset(string, pattern)` returns the strings that match a pattern.

I don't often need to work with string data, but when I do, I usually jump to two tools:

1. `grepl`, and
2. `stringr`.

What I usually want to do is return strings that match some pattern.

For example, say there are 5 items:


```r
items <- c("thing1",
           "thing2",
           "sacvy",
           "item.csv",
           "wat.csv")
```

Then I can return those items by writing something like this.


```r
items[grepl(".csv$", items)]
```

```
## [1] "item.csv" "wat.csv"
```

Let's break that down:

This reads as:

* Does this end with `csv` in the object `items`?


```r
grepl(".csv$", items)
```

```
## [1] FALSE FALSE FALSE  TRUE  TRUE
```

And we can then put this inside the square braces `[` of `items`, to return those that match this pattern:


```r
items[grepl(".csv$", items)]
```

```
## [1] "item.csv" "wat.csv"
```

`stringr` makes this somewhat more straightforward. First, you can use `str_detect` instead of `grepl`. This is nice because it takes the strings first, then the pattern. This makes it more consistent with other tidy tools, which have the data first, then the options of the function:


```r
library(stringr)

str_detect(items, ".csv$")
```

```
## [1] FALSE FALSE FALSE  TRUE  TRUE
```

But what if I just want things returned that match that?

You want `str_subset`. Think of it like this - `subset` is another word for `filter`, which you might be more familiar with:


```r
str_subset(items, ".csv$")
```

```
## [1] "item.csv" "wat.csv"
```

And that's it, that's all I have to say.
