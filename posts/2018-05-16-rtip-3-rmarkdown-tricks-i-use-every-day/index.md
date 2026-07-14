---
title: "r-tip: 3 rmarkdown tricks I use every day"
date: '2018-02-28'
slug: three-r-tips
categories: [rstats]
aliases:
  - /post/2018/02/28/three-r-tips/
---

I write in [rmarkdown](https://bookdown.org/yihui/rmarkdown/) (check out that link, it's to the new Rmarkdown book!) most days, and I've been using it for the past few years.

I've picked up a few tips along the way, and I wanted to share a couple of things I think give you a nice return on investment.

# Tip number 1: Save the images that you create

You want to make sure that you save images you create in your rmarkdown document. To do this automatically, and avoid writing things like `ggsave(plot)` or `dev.off()`, just create the plots in rmarkdown, and tell it you want to save the output.

In the funky looking code at the top, the YAML, specify `keep_md: yes`.

```
---
title: "Amazing document"
output:
  html_document:
    keep_md: yes
---
```

What happens now?

Well, when you run your rmarkdown document, you get a new folder WITH THE FIGURES


# Tip Number 2: Reduce clutter and increase sanity: Set options in a code chunk.

Want to change the width of your figure? Want to save to PNG, JPG, or more? 

In your rmarkdown code chunk, this thing

<pre><code>&#96;&#96;&#96;{r}
&#96;&#96;&#96;</code></pre>

You can specify these things!

Want to save a figure as JPG? 


<pre><code>&#96;&#96;&#96;{r dev = "jpg"}
ggplot(airquality,
       aes(x = Temp,
           y = Wind)) +
    geom_point()
&#96;&#96;&#96;</code></pre>

What about a PNG?

<pre><code>&#96;&#96;&#96;{r dev = "png"}
ggplot(airquality,
       aes(x = Temp,
           y = Wind)) +
    geom_point()
&#96;&#96;&#96;</code></pre>

Why not both?

<pre><code>&#96;&#96;&#96;{r dev = c("png", "jpg")}
ggplot(airquality,
       aes(x = Temp,
           y = Wind)) +
    geom_point()
&#96;&#96;&#96;</code></pre>

This is really handy, say, when a journal wants all your figures as TIFF or PS.

<pre><code>&#96;&#96;&#96;{r dev = c("png", "jpg", "tiff")}
ggplot(airquality,
       aes(x = Temp,
           y = Wind)) +
    geom_point()
&#96;&#96;&#96;</code></pre>

# Tip number 3: Specify some global options for all your code chunks

Writing that for each chunk can be pretty annoying, luckily there is a better way - you can specify all the options you want just once, using `knitr::set_opts(dev = "jpg")`.

Here is my setup chunk that I have for one of my papers at the moment:

<pre><code>&#96;&#96;&#96;{r setup-chunk, include=FALSE}
knitr::opts_chunk$set(dev = "png",
                      dpi = 300,
                      echo = FALSE,
                      cache = TRUE)
&#96;&#96;&#96;</code></pre>

This tells rmarkdown:

- Save all images as `png`
- Save the PNGs at a nice high quality please, at `300 dpi`
- Don't print my code `echo = FALSE`
- Save all my output the first time you run it, so I don't ahve to wait _forever_ for my rmarkdown document to run `cache =TRUE`

I don't want to get distracted with what `cache` is, but very quickly, using `cache TRUE` means that you don't have to create 

# Tip Number 4: Name your code chunks

You can actually give each chunk of code a name:

<pre><code>&#96;&#96;&#96;{r my-amazing-plot, dev = c("png", "jpg", "tiff", "ps")}
ggplot(airquality,
       aes(x = Temp,
           y = Wind)) +
    geom_point()
&#96;&#96;&#96;</code></pre>

It might seem trivial, but naming your code chunks has some nice side effects:

1. It now saves that plot with the chunk name (instead of untitled-1)


2. If all chunks are named, this means that when you cache, you won't get a slowdown, as it might need to re-reun untitled-1, when you change your code, as said by [Rob](https://twitter.com/robjhyndman/status/894886426885578752), and [Maëlle](https://masalmon.eu/2017/08/08/chunkpets/).

3. Helps give you context when you are running your code 6 months later.

4. You can use the name of your code chunk in `dependson`, if you have a specific reason

# Closing

Finally, if you haven't seen it yet, check out the new Rmarkdown book written by Yihui, JJ Allaire, and Garrett Grolemund ["R Markdown: The Definitive Guide"](https://bookdown.org/yihui/rmarkdown/)

