---
title: 'Glue magic Part I'
date: '2019-07-07'
slug: glue-magic-p1
categories:
  - rstats
  - glue
  - strings
aliases:
  - /post/2019/07/07/glue-magic-p1/
---



Lately I've found myself using [Jim Hester's `glue` package](https://glue.tidyverse.org/) instead of `paste0` or `sprintf`. This post marks the start of an ongoing series of little magic spells using the `glue` package.

# The back story

I've been through a few stages of discovery for combining strings of text together.

First, it was just the very _idea_ that this was possible - was AMAZING. 

## `paste`

When I learnt about the `paste` function, it meant I could do things like this:


```r
paste("path/to/file_", 1:5, ".csv", sep = "")
```

```
## [1] "path/to/file_1.csv" "path/to/file_2.csv" "path/to/file_3.csv"
## [4] "path/to/file_4.csv" "path/to/file_5.csv"
```

Here, this reads as, roughly, "take this string, insert the numbers 1:5 in the middle of it, and **sep**arate those strings with no space `""`.

<img src="https://media.giphy.com/media/3o8dFn5CXJlCV9ZEsg/giphy.gif" width="50%" style="display: block; margin: auto;" />

## `paste0`

And then there was `paste0`, which meant that I didn't have to write `sep = ""` all the time.

So, now I could write:


```r
paste0("path/to/file_", 1:5, ".csv")
```

```
## [1] "path/to/file_1.csv" "path/to/file_2.csv" "path/to/file_3.csv"
## [4] "path/to/file_4.csv" "path/to/file_5.csv"
```

<img src="https://media.giphy.com/media/npCDi7hWyL52zReYSG/giphy.gif" width="50%" style="display: block; margin: auto;" />

## `sprintf`

And then the `sprintf` function, which means you can do this:


```r
sprintf("path/to/file_%s.csv", 1:5)
```

```
## [1] "path/to/file_1.csv" "path/to/file_2.csv" "path/to/file_3.csv"
## [4] "path/to/file_4.csv" "path/to/file_5.csv"
```

Here, `%s` is substituted in for the R code you write afterwards. This is nice because it also means you are able to drop the R code into the middle of the string without having to open and close it again. I feel like I can better express what I want to say, and don't have to spend time remembering other book keeping things.

## And now for glue magic

I am now always turning to glue, because it makes the intent of what I want to do clearer. For example, we can take our `sprintf` use earlier and instead do the following with `glue`.


```r
library(glue)
glue("path/to/file_{1:5}.csv")
```

```
## path/to/file_1.csv
## path/to/file_2.csv
## path/to/file_3.csv
## path/to/file_4.csv
## path/to/file_5.csv
```

What is going on here? You are now able to refer to R objects _inside the string_, which are captured in the `{}`.

<img src="https://media.giphy.com/media/8vGJv6FmhETjW/giphy.gif" width="50%" style="display: block; margin: auto;" />

I really like this, because it means that I don't need to worry about ending the string, inserting the R object, and handling the other bits and pieces. My intent here feels super clear: "Insert the R code in the bit with {}". 

Don't want to use `{}`? That's also fine, you can control that with `.open` and `.close`:


```r
glue("path/to/file_[1:5].csv", .open = "[", .close = "]")
```

```
## path/to/file_1.csv
## path/to/file_2.csv
## path/to/file_3.csv
## path/to/file_4.csv
## path/to/file_5.csv
```

## Combining many strings

Or if you want to collapse, or smush together many strings, you use `glue_collapse`, because you want to `collapse` together many pieces.

Say, for example, that you want to write out a sentence where you state all of the variables in a dataset, like the `french_fries` dataset from `reshape2`:


```r
# get the french fries data
library(reshape2)
knitr::kable(head(french_fries))
```



|   |time |treatment |subject | rep| potato| buttery| grassy| rancid| painty|
|:--|:----|:---------|:-------|---:|------:|-------:|------:|------:|------:|
|61 |1    |1         |3       |   1|    2.9|     0.0|    0.0|    0.0|    5.5|
|25 |1    |1         |3       |   2|   14.0|     0.0|    0.0|    1.1|    0.0|
|62 |1    |1         |10      |   1|   11.0|     6.4|    0.0|    0.0|    0.0|
|26 |1    |1         |10      |   2|    9.9|     5.9|    2.9|    2.2|    0.0|
|63 |1    |1         |15      |   1|    1.2|     0.1|    0.0|    1.1|    5.1|
|27 |1    |1         |15      |   2|    8.8|     3.0|    3.6|    1.5|    2.3|

Here, we tell it what we want our **sep**arations be - in this case, since we have a list, we want everything to be separate by a comma and a space.


```r
fries_names <- names(french_fries)

fries_inline <- glue::glue_collapse(fries_names, 
                                    sep = ", ")

fries_inline
```

```
## time, treatment, subject, rep, potato, buttery, grassy, rancid, painty
```

And now you can include this in your rmarkdown text, so now I can dynamically generate the sentence:

```
The variables in our dataset are `r fries_inline`
```

> The variables in our dataset are time, treatment, subject, rep, potato, buttery, grassy, rancid, painty.

(PS, You can include a verbatim inline expression with `knitr::inline_expr()`).

But, what if you want to add an "and" at the end of the sentence?

You can use the `last` argument:


```r
fries_inline <- glue::glue_collapse(fries_names, 
                                    sep = ", ",
                                    last = ", and ")
```

```
The variables in our dataset are `r fries_inline`
```


> The variables in our dataset are time, treatment, subject, rep, potato, buttery, grassy, rancid, and painty.

# End

`paste`, `paste0`, and `sprintf` are awesome, but I use `glue` because I find it means I can write code that more clearly captures my intent, and means I don't need to worry about other book keeping. I also get really nice features, like being able to construct sentences, and modify them to do things at the end.

Massive praise to [Jim Hester](https://www.jimhester.com/) for his work on glue - you should check out his great talk at UseR!2018 below. Jim has also been putting out some [really great videos on #rstats on youtube that are well worth yout time](https://www.youtube.com/channel/UC3mcThQVORlwCY4k1vB0FmQ)

<iframe src="https://www.youtube.com/embed/XQmBcpQl8K8" width="100%" height="400" frameborder="0" allowfullscreen></iframe>

