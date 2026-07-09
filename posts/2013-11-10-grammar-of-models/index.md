---
title: A Grammar of Models?
date: 2013-11-10
categories:
- rstats
- Statistics
slug: grammar-of-models
aliases:
  - /post/2013/11/10/grammar-of-models/
---


I came across [this interview](http://statr.me/2013/09/a-conversation-with-hadley-wickham/) with Hadley Wickham, the creator of one of the most widely used R packages, `ggplot 2`. I thought that this quote was interesting:

> I’m also really interested in statistical learning as a family of modeling techniques, a kind of fitting them together very well and forming a grammer of models. You can make a new model by joing things together, just like the grammer of graphics by which you can come up with a new graphic that is just a new arrangment of existing components. I think that’s something that makes it easier to learn modeling. For example, you can learn a linear model in this way, a random forest in that way, and you can learn them in a unified framework.

> Another thing I’d like to think is the Lasso-type method. In one of my classes, I want to show that now you should always try stablized regression, you should always try to do Lasso and the similar. I think there are 13 packages that would do Lasso, and I tried them all. But every single one of them broke for a different reason. For example, it didn’t support missing values, it didn’t support categorical variables, it didn’t do predictions and standard errors, or it didn’t automatically find the lambda parameter. Maybe that’s because the authors are more interested in the theoretical papers, not in providing a tool that you can use in data analysis. So I want to integrate them together to form a tool that is fast and works well.


And it got me thinking, would it be possible for statistical models to be written like ggplot, with a grammar of models? It seems impossible, and maybe I'm totally not reading the interview correctly, but it got me thinking. What would it look like? Something like this?

```r
ggmodel(data = my.data,
        fun = Y ~ V1 + V2 + V3) %>%
        model_nest(V1 ~ Y1 + Y2 + e,
                   e ~ norm(0,1)) %>%
        m.impute(m = 4) %>%
        time_period(type = unequal)
```

What do you think?
