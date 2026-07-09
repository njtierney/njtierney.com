---
title: "A note on ggplot code style"
date: '2018-07-06'
slug: style-ggplot
categories:
  - rstats
  - Teaching
  - blag
aliases:
  - /post/2018/07/06/style-ggplot/
---



I've got some opinions about how to write ggplot code. 

<img src="https://gifs.njtierney.com/strong-opinion.gif" style="display: block; margin: auto;" />


They are based off of the [official style guide](http://style.tidyverse.org/), with a few of my own additions specific to ggplot2.

## Starting with argument names / newlines

So, if there are more than two sections in a function, these should be separated on a newline. Ideally, all functions should have their argument names listed:


```r
# good
my_fun(data = "bibbity",
       arg2 = "bobbity",
       arg3 = "boo")

# bad
my_fun(data = "bibbity", arg2 = "bobbity", arg3 = "boo")
```

with the exception of `tidyverse` and other code, that usually has the data as the first argument.


```r
# good
my_fun(data,
       arg2 = "bobbity",
       arg3 = "boo")

# bad
my_fun(data, arg2 = "bobbity", arg3 = "boo")
```

## ggplot2

Applying this same principle to ggplot2 code, we have the following, with the additional rule:

> Continue indenting (e.g., the `geom_`, `theme`, and other subsequent calls after the `+`).


```r
# good
ggplot(data = economics,
       mapping = aes(x = pop,
                     y = unemploy)) + 
  geom_line()
```

You can use the `mapping` argument if you like, but it certainly isn't necessary:


```r
# also good
ggplot(economics, 
       aes(x = pop, 
           y = unemploy)) + 
  geom_line()
```

But putting it onto one line, this is where I think it is not a good idea


```r
# bad
ggplot(economics, aes(x = pop, y = unemploy)) + geom_line()
```

It is certainly great to be able to express the code so elegantly, but I'm 
just not that sold on the benefits.

Here are some other examples of `ggplot2` code that doesn't fit the style:


```r
# bad
ggplot(economics, 
       aes(x = pop, 
           y = unemploy)) + geom_line() + theme_bw()

# bad
ggplot(economics, aes(pop, unemploy)) + 
  geom_line() + theme_bw()

# also bad
ggplot(economics, 
       aes(pop, unemploy)) + 
  geom_line() + theme_bw()
```


I prefer this type of code:


```r
# good!
ggplot(economics, 
       aes(x = pop, 
           y = unemploy)) + 
  geom_line() + 
  theme_bw()
```

because I feel that it reads quicker - your eyes don't have to scan as far along the width of the page. 

It is also easier to edit and change your code to comment, like so:


```r
library(lubridate)
ggplot(economics, 
       aes(x = pop, 
           y = unemploy
           # colour = ,
           )) + 
  geom_line() + 
  facet_wrap(~month(date)) + 
  # facet_wrap(~year(date)) + 
  theme_bw()
```

# Fin

That's it, that's my opinion on ggplot2 code style:

<img src="https://gifs.njtierney.com/opinion-man.gif" style="display: block; margin: auto;" />

