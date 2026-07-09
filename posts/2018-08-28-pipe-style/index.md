---
title: "A note on magrittr pipe (`%>%`) code style"
date: '2018-08-28'
slug: style-pipe
categories:
  - rstats
  - Teaching
  - blag
aliases:
  - /post/2018/08/28/style-pipe/
---



[I recently wrote about ggplot2 style](https://www.njtierney.com/post/2018/07/06/style-ggplot/), and in this one I'd like to discuss the pipe operator, `%>%`. These notes are drawn from the comments on the pipe section of the [tidyverse style guide](http://style.tidyverse.org/pipes.html).

## Newlines and the pipe

For the pipe operator, `%>%`, I recommend you can keep the pipe on the same line for 2 (occassionally 3) pipes, else there should always be a newline. You should also consider whether the pipe is adding any clarity to the steps, when there is only one pipe.


```r
library(tidyr)
library(dplyr)

# Acceptable
count(iris, Species)

# OK
iris %>% count(Species)

# good
iris %>% 
  count(Species) %>%
  ggplot(aes(x = n,
             y = Species))

# OK-ish
iris %>% group_by(Species) %>% tally()

# better
iris %>% 
  group_by(Species) %>% 
  tally()

# good!
iris %>% 
  select(Sepal.Width, 
         Sepal.Length, 
         Petal.Length) %>% 
  mutate(Sepal.Petal.Length = Sepal.Length + Petal.Length) %>%
  summarise()

# bad
iris %>% select(Sepal.Width, Sepal.Length, Petal.Length) %>% 
  mutate(Sepal.Petal.Length = Sepal.Length + Petal.Length) %>%
```

I have two reasons for this:

1. It's easier to edit and change code.


```r
iris %>% 
  select(Sepal.Width, 
         # Sepal.Length, 
         Petal.Length) %>% 
  mutate(Sepal.Petal.Length = Sepal.Length + Petal.Length) %>%
  summarise()
```

2. It reads quicker
3. You can use the pipe to input into ggplot


```r
iris %>% 
  select(Sepal.Width, 
         # Sepal.Length, 
         Petal.Length) %>% 
  mutate(Sepal.Petal.Length = Sepal.Length + Petal.Length) %>%
  # summarize() %>%
  ggplot(aes(x = Sepal.Petal.Length,
             y = Sepal.Width)) + 
  geom_point()
```

