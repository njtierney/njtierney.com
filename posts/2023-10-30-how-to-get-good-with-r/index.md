---
title: How to Get Good with R?
date: '2023-11-10'
slug: how-to-get-good-with-r
categories:
  - rstats
aliases:
  - /post/2023/11/10/how-to-get-good-with-r/
---

<div class="highlight">

<img src="imgs/never-stop-sign.jpg" width="700px" style="display: block; margin: auto;" />

</div>

*A Stop Sign in Melbourne, Film, Pentax K1000, Nick Tierney*

Someone recently asked me, "How do you get good with R?". It's a good question. I'm not sure I have a good answer. But I've been thinking about it, and I've got some ideas. Hopefully they are helpful for people, or can promote discussion on making better ideas. I think you can view "getting good" through two lenses: coding, and non coding. I'll write about the coding aspects in this blog post, and the non coding aspects in a future one.

This post assumes that you're somewhat familiar with R, you can open it, you do some analysis, etc. I should probably write a blog post first on "How to get started with R". But writing introductory materials takes a bit more time, and I'd rather put out some kind of blog post than continue to add to the pile of blog post drafts that have been sitting there since 2017.

How to get good, from the coding side:

-   Try to give things OK names
-   Consistent naming
-   Stick to a style guide
-   Clean up your code as you go (refactor)
-   Learn how to create a reproducible example (a reprex), and use it a lot
-   Write functions
-   Use the debugger

How to get good, from the non coding side:

-   Find a community of people who use R
-   Get better with the keyboard: Typing speed and keyboard shortcuts
-   Have a strong desire to improve
-   Learn how to, and practice getting unstuck
-   Read other peoples code
-   Read books and learning material
-   Practice reading the documentation
-   Ask yourself how much what you are doing now is relevant to the problem you were trying to solve. I get distracted often, this helps me redirect.
-   Offload ideas and tasks onto github issues (or another system)
-   Write about your work publicly - this forced me to clean up my code and keep a tidy ship

# Let's delve a bit deeper

Let's give examples of all of these things. I've realised now as I've been writing this that I won't have time to write the non-coding aspects, so that will be its own blog post. But I thought it might be useful to outline the points above.

# From the coding side

## Try to give things OK names

There is a quote by Phil Karlton: "There are only two hard things in Computer Science: cache invalidation and naming thing". We won't talk about cache invalidation (Although [Yihui has a good post about it if you are interested](https://yihui.org/en/2018/06/cache-invalidation/)), but naming things well...is hard. Giving things OK names is a bit easier. Getting in the habit of giving things an OK name will lead to you giving better and better names as you practice. Why should we are about this? Well, compare:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>weight_mean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span>
<span><span class='nv'>weight_sd</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span></code></pre>

</div>

to

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span>
<span><span class='nv'>y</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span></code></pre>

</div>

If I see `weight_mean` and `weight_sd` later, I've got a clue what they are - the mean and the standard deviation of a thing called weight. I don't know what `x` and `y` are when I see them. A small counter example to this is very small functions. But let's not get into the weeds.

## Consistent naming

Building on the previous point, I think it useful to pick a *way* to name something, and stick to it.

Compare:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>weight_mean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span>
<span><span class='nv'>sd_weight</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span></code></pre>

</div>

and

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>weight_mean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span>
<span><span class='nv'>weight_sd</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span></code></pre>

</div>

The first one changes the order of the naming, which is: `variable_operation` - the first word describes the variable we are measuring, weight, and the second tells us what operation we've done to it. It doesn't matter about the order, necessarily, but the *consistency*.

Why? Because if it is consistent we can get benefits in things like tab complete - I can type `weight_` and hit `tab` and it tells me all the things related to `weight` that I've done. Similarly, it could also be useful to know all the things I've done `sd` to, `sd_` could tell me the things with `sd`. E.g.,

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>sd_height</span> <span class='o'>&lt;-</span> <span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>weight</span></span>
<span><span class='nv'>sd_time</span> <span class='o'>&lt;-</span> <span class='nv'>ChickWeight</span><span class='o'>$</span><span class='nv'>Time</span></span></code></pre>

</div>

It depends what you are doing - do you care more about finding things related to `sd`, or related to `height` or `weight`? My point is that I think it's worthwhile to stick to a consistent approach. It means you can just remember the more important thing, whether that be things related to `weight`, or things related to `sd`.

## Stick to a style guide

Style guides are a thing - they help define a set of rules to keep your code easy to read. To quote Hadley Wickham:

> Good coding style is like correct punctuation: you can manage without it, butitsuremakesthingseasiertoread.

There is a comprehensive guide like the [Tidyverse Style Guide](https://style.tidyverse.org/). Or for a shorter guide, you can see the [style guide from "Advanced R", 1st edition](http://adv-r.had.co.nz/Style.html)

I think it is worth your time to read through a style guide once. You'll notice things that you didn't before in your code and you'll see things differently. It is similar to learning about [kerning](https://xkcd.com/1015/). Once you see it, you'll notice it everywhere.

So, pick something like `snake_case` or `camelCase` or `CamelCase`, and stick to it. I prefer `snake_case` because I find it easier to read. But you can do whatever you want! Just be consistent.

I find it confusing to go through code that mixes it up or combines different approaches. It means you need to spend time remembering which way something was named. Here's a "good" vs "bad"

``` r
# good
sdWeight
sdTime
weightSd
timeSd
```

``` r
# bad
sd_Weight
SD_weight
Long_variable_Name
```

If you want to have a quick way to help style your code, check out [Lorenz Walthert's](https://github.com/lorenzwalthert) [`styler`](https://github.com/r-lib/styler) package.

## Clean up your code as you go (refactor)

Get into the habit of quickly going back over your code to tidy it up. A kitchen analogy is useful here I think. Professional kitchens clean up as they go. Keeping a tidy workspace helps keep your mind clear. And I rarely write my best code on the first pass. It gets better with iteration. So, iterate on your code briefly as you go. Clean up those random comments that don't mean anything. Remove those bits of wilted lettuce, these are those commented out bits of code that you *might just come back to* - you probably won't, and if they are really important, write a comment explaining why they might be relevant. Clean up the style. Check the names. Consider tidying up the implementation, refactoring it. You might not have time to do all of these things, or do them thoroughly, but doing some of them will help you write better code, and you'll get better at doing these things the more you practice.

A word worth explaining - "refactor". It refers to changing the code but keeping it's behaviour the same. Kind of like giving a car a service, or replacing key parts in a vehicle that get worn out. For a great talk on a related topic, see [Jenny Bryan's "Code Smells and Feels"](https://www.youtube.com/watch?v=7oyiPBjLAWY)

## Learn how to create a reproducible example (a reprex), and use it a lot

When you run into a problem, or an error, if you can't work out the answer after some tinkering about, it can be worthwhile spending some time to construct a small example of the code that breaks. This takes a bit of time, and could be its own little blog post. It takes practice. But in the process of reducing the problem down to its core components, I often can solve the problem myself. It's kind of like that experience of when you talk to someone to try and describe a problem that you are working on, and in talking about it, you arrive at a solution.

There is a great R package that helps you create these reproducible examples, called [`reprex`](https://reprex.tidyverse.org/), by [Jenny Bryan](https://jennybryan.org/). I've written about the reprex package [here](https://www.njtierney.com/post/2017/01/11/magic-reprex/)

For the purposes of illustration, let's briefly tear down a small example using the somewhat large dataset of `diamonds`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching core tidyverse packages</span> ────────────── tidyverse 2.0.0 ──</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr    </span> 1.1.3     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr    </span> 2.1.4</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats  </span> 1.0.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr  </span> 1.5.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2  </span> 3.4.4     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble   </span> 3.2.1</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>lubridate</span> 1.9.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr    </span> 1.3.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr    </span> 1.0.2     </span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Use the conflicted package (<span style='color: #0000BB; font-style: italic;'>&lt;http://conflicted.r-lib.org/&gt;</span>) to force all conflicts to become errors</span></span>
<span></span><span><span class='nv'>diamonds</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 53,940 × 10</span></span></span>
<span><span class='c'>#&gt;    carat cut       color clarity depth table price     x     y     z</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  0.23 Ideal     E     SI2      61.5    55   326  3.95  3.98  2.43</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  0.21 Premium   E     SI1      59.8    61   326  3.89  3.84  2.31</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  0.23 Good      E     VS1      56.9    65   327  4.05  4.07  2.31</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  0.29 Premium   I     VS2      62.4    58   334  4.2   4.23  2.63</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  0.31 Good      J     SI2      63.3    58   335  4.34  4.35  2.75</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  0.24 Very Good J     VVS2     62.8    57   336  3.94  3.96  2.48</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  0.24 Very Good I     VVS1     62.3    57   336  3.95  3.98  2.47</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  0.26 Very Good H     SI1      61.9    55   337  4.07  4.11  2.53</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  0.22 Fair      E     VS2      65.1    61   337  3.87  3.78  2.49</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  0.23 Very Good H     VS1      59.4    61   338  4     4.05  2.39</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 53,930 more rows</span></span></span>
<span></span></code></pre>

</div>

Let's say we had a few steps involved in the data summary of diamonds data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    price_per_carat <span class='o'>=</span> <span class='nv'>price</span> <span class='o'>/</span> <span class='nv'>carat</span></span>
<span>  <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>cut</span></span>
<span>    <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/summarise.html'>summarise</a></span><span class='o'>(</span></span>
<span>    price_mean <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>price_per_carat</span><span class='o'>)</span>,</span>
<span>    price_sd <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>price_per_carat</span><span class='o'>)</span>,</span>
<span>    mean_color <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>color</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='c'>#&gt; Warning: There were 5 warnings in `summarise()`.</span></span>
<span><span class='c'>#&gt; The first warning was:</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> In argument: `mean_color = mean(color)`.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> In group 1: `cut = Fair`.</span></span>
<span><span class='c'>#&gt; Caused by warning in `mean.default()`:</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> argument is not numeric or logical: returning NA</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> Run `dplyr::last_dplyr_warnings()` to see the 4 remaining warnings.</span></span>
<span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 5 × 4</span></span></span>
<span><span class='c'>#&gt;   cut       price_mean price_sd mean_color</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>          <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Fair           <span style='text-decoration: underline;'>3</span>767.    <span style='text-decoration: underline;'>1</span>540.         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Good           <span style='text-decoration: underline;'>3</span>860.    <span style='text-decoration: underline;'>1</span>830.         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Very Good      <span style='text-decoration: underline;'>4</span>014.    <span style='text-decoration: underline;'>2</span>037.         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Premium        <span style='text-decoration: underline;'>4</span>223.    <span style='text-decoration: underline;'>2</span>035.         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Ideal          <span style='text-decoration: underline;'>3</span>920.    <span style='text-decoration: underline;'>2</span>043.         <span style='color: #BB0000;'>NA</span></span></span>
<span></span></code></pre>

</div>

We get a clue that the error is in the line `mean_color`, so let's just try and do that line:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>diamonds</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    mean_color <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>color</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='c'>#&gt; Warning: There was 1 warning in `mutate()`.</span></span>
<span><span class='c'>#&gt; <span style='color: #00BBBB;'>ℹ</span> In argument: `mean_color = mean(color)`.</span></span>
<span><span class='c'>#&gt; Caused by warning in `mean.default()`:</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> argument is not numeric or logical: returning NA</span></span>
<span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 53,940 × 11</span></span></span>
<span><span class='c'>#&gt;    carat cut       color clarity depth table price     x     y     z mean_color</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;ord&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  0.23 Ideal     E     SI2      61.5    55   326  3.95  3.98  2.43         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  0.21 Premium   E     SI1      59.8    61   326  3.89  3.84  2.31         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  0.23 Good      E     VS1      56.9    65   327  4.05  4.07  2.31         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  0.29 Premium   I     VS2      62.4    58   334  4.2   4.23  2.63         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  0.31 Good      J     SI2      63.3    58   335  4.34  4.35  2.75         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  0.24 Very Good J     VVS2     62.8    57   336  3.94  3.96  2.48         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  0.24 Very Good I     VVS1     62.3    57   336  3.95  3.98  2.47         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  0.26 Very Good H     SI1      61.9    55   337  4.07  4.11  2.53         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  0.22 Fair      E     VS2      65.1    61   337  3.87  3.78  2.49         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  0.23 Very Good H     VS1      59.4    61   338  4     4.05  2.39         <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 53,930 more rows</span></span></span>
<span></span></code></pre>

</div>

We still get that error, so what if we just do

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>diamonds</span><span class='o'>$</span><span class='nv'>color</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Warning in mean.default(diamonds$color): argument is not numeric or logical: returning NA</span></span>
<span></span><span><span class='c'>#&gt; [1] NA</span></span>
<span></span></code></pre>

</div>

OK same error. What is in color?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span><span class='o'>(</span><span class='nv'>diamonds</span><span class='o'>$</span><span class='nv'>color</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; [1] E E E I J J</span></span>
<span><span class='c'>#&gt; Levels: D &lt; E &lt; F &lt; G &lt; H &lt; I &lt; J</span></span>
<span></span></code></pre>

</div>

Does it really make sense to take the mean of some letters? Ah, of course not!

## Use other R packages

You don't need to write everything yourself from scratch. There are thousands of R packages that people have written to solve problems. Not all of them will suit, but if you find yourself trying to solve a problem, or write a statistical model from scratch, it it worth your time to search google to see if anyone has tried to solve this problem.

At worst, you'll see no one has thought about this - this is an opportunity for you to do something cool! Or you might see ways people have tried to solve this, which can help you get started, and you'll learn the other words people use to describe the problem you are facing, which can help you search this problem better in the future. At best you'll find an exact answer.

## Write functions

I don't think I can overstate this, but learning how to write functions changed how I think about code and how I think about solving problems. I think it is a skill that takes some time to develop, but the payoff is enormous. A function is an abstraction of a problem. Kind of like a shortcut. Save yourself writing many many lines of code and replace them with a function. But that's an oversimplification.

Here's a short primer on why functions are good, adapted from the [functions chapter of R4DS](https://r4ds.had.co.nz/functions.html#functions), which I recommend you read.

What does the following code do?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span><span class='nf'>::</span><span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span></span>
<span>  weight <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span>, mean <span class='o'>=</span> <span class='m'>80</span>, sd <span class='o'>=</span> <span class='m'>6</span><span class='o'>)</span>,</span>
<span>  height <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Normal.html'>rnorm</a></span><span class='o'>(</span><span class='m'>10</span>, mean <span class='o'>=</span> <span class='m'>165</span>, sd <span class='o'>=</span> <span class='m'>10</span><span class='o'>)</span>,</span>
<span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 2</span></span></span>
<span><span class='c'>#&gt;    weight height</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>   78.0   167.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>   76.0   152.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>   81.2   173.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>   71.9   156.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>   88.1   160.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>   80.2   180.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>   67.1   168.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>   82.7   180.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>   81.7   160.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>   81.6   157.</span></span>
<span></span><span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight_0</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height_0</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span></code></pre>

</div>

This is a kind of transformation called mean centering and scaling. It can be useful in some statistical models to have your data have a mean of 0 and a standard deviation of 1.

But read through that code it can be hard to understand that is what is happening, and it also leads to potential errors - you have to repeat `dat$weight` or `dat$height` many times. And if you copy and paste this code then you might end up with an error. Which there is. for `height_0`, I divide by the standard deviation of weight, not height.

A function helps clarify this by *abstracting away* the need to write the variable in each time. We can break this into two steps:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mean_center</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>variable</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>variable</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>variable</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span>
<span></span>
<span><span class='nv'>scale_sd</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>variable</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>variable</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>variable</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

Now we can express this as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'>mean_center</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'>scale_sd</span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;  [1]  0.1832022 -1.3362374  0.7525296 -0.9848021 -0.4937227  1.4924404</span></span>
<span><span class='c'>#&gt;  [7]  0.3021602  1.4477151 -0.5125610 -0.8507242</span></span>
<span></span></code></pre>

</div>

or, we can write a function that does both of these steps:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>center_scale</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>variable</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>centered</span> <span class='o'>&lt;-</span> <span class='nf'>mean_center</span><span class='o'>(</span><span class='nv'>variable</span><span class='o'>)</span></span>
<span>  <span class='nv'>centered_scaled</span> <span class='o'>&lt;-</span> <span class='nf'>scale_sd</span><span class='o'>(</span><span class='nv'>centered</span><span class='o'>)</span></span>
<span>  <span class='nv'>centered_scaled</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

What is nice about this is that each of the functions *describes what it does* in its name. So when we look at the code for `center_scale`, we can see that it does a thing called `mean_center` first, then `scale_sd` next. Another useful principle to follow with writing functions is to generally try to aim to get them to do one thing, and to return one thing. There are many exceptions to this rule, but it's a useful practice to stick to.

So compare:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight_0</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height_0</span> <span class='o'>&lt;-</span> <span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span></span>
<span><span class='c'>#&gt;    weight height weight_0 height_0</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>   78.0   167.   -<span style='color: #BB0000;'>0.138</span>    0.308</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>   76.0   152.   -<span style='color: #BB0000;'>0.476</span>   -<span style='color: #BB0000;'>2.25</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>   81.2   173.    0.394    1.27 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>   71.9   156.   -<span style='color: #BB0000;'>1.18</span>    -<span style='color: #BB0000;'>1.66</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>   88.1   160.    1.56    -<span style='color: #BB0000;'>0.831</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>   80.2   180.    0.224    2.51 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>   67.1   168.   -<span style='color: #BB0000;'>1.97</span>     0.508</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>   82.7   180.    0.644    2.44 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>   81.7   160.    0.482   -<span style='color: #BB0000;'>0.862</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>   81.6   157.    0.456   -<span style='color: #BB0000;'>1.43</span></span></span>
<span></span></code></pre>

</div>

to

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight_0</span> <span class='o'>&lt;-</span> <span class='nf'>center_scale</span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height_0</span> <span class='o'>&lt;-</span> <span class='nf'>center_scale</span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span></span>
<span><span class='c'>#&gt;    weight height weight_0 height_0</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>   78.0   167.   -<span style='color: #BB0000;'>0.138</span>    0.183</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>   76.0   152.   -<span style='color: #BB0000;'>0.476</span>   -<span style='color: #BB0000;'>1.34</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>   81.2   173.    0.394    0.753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>   71.9   156.   -<span style='color: #BB0000;'>1.18</span>    -<span style='color: #BB0000;'>0.985</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>   88.1   160.    1.56    -<span style='color: #BB0000;'>0.494</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>   80.2   180.    0.224    1.49 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>   67.1   168.   -<span style='color: #BB0000;'>1.97</span>     0.302</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>   82.7   180.    0.644    1.45 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>   81.7   160.    0.482   -<span style='color: #BB0000;'>0.513</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>   81.6   157.    0.456   -<span style='color: #BB0000;'>0.851</span></span></span>
<span></span></code></pre>

</div>

It is worth noting that there is a function called `scale` in base R that does this, however it returns a matrix, so you'll need to wrap it in `as.numeric`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight_0</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/scale.html'>scale</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>weight</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height_0</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/scale.html'>scale</a></span><span class='o'>(</span><span class='nv'>dat</span><span class='o'>$</span><span class='nv'>height</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='nv'>dat</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 4</span></span></span>
<span><span class='c'>#&gt;    weight height weight_0 height_0</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>   78.0   167.   -<span style='color: #BB0000;'>0.138</span>    0.183</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>   76.0   152.   -<span style='color: #BB0000;'>0.476</span>   -<span style='color: #BB0000;'>1.34</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>   81.2   173.    0.394    0.753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>   71.9   156.   -<span style='color: #BB0000;'>1.18</span>    -<span style='color: #BB0000;'>0.985</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>   88.1   160.    1.56    -<span style='color: #BB0000;'>0.494</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>   80.2   180.    0.224    1.49 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>   67.1   168.   -<span style='color: #BB0000;'>1.97</span>     0.302</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>   82.7   180.    0.644    1.45 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>   81.7   160.    0.482   -<span style='color: #BB0000;'>0.513</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>   81.6   157.    0.456   -<span style='color: #BB0000;'>0.851</span></span></span>
<span></span></code></pre>

</div>

Which is why it is worthwhile looking to see if a solution to a problem exists :)

To summarise writing functions:

1.  Functions help us reason with our code by abstracting away details we don't need to care about
2.  Give Functions good names, they should describe what they do
3.  Functions should do one task
4.  Functions should return one thing

## Learn how to use debugging tools

R is interactive, you can run some code and see the output immediately. It's a really nice way to code for data analysis. It means that when you encounter a bug or an error, you can poke around and see what the error is. But if you write a function and want to see how it behaves or what goes on inside, you'll need to use a special tool called a debugger.

If you've found yourself copying the internals of a function over to another script and hard coding the arguments at the top of the script and running the code line by line, then this is especially for you. I say this as someone who did that for years. Ahem.

Three debugging tools to know about:

1.  [`browser()`](https://rdrr.io/r/base/browser.html)
2.  [`debug()`](https://rdrr.io/r/base/debug.html) and [`undebug()`](https://rdrr.io/r/base/debug.html)
3.  [`debugonce()`](https://rdrr.io/r/base/debug.html)

[`browser()`](https://rdrr.io/r/base/browser.html) gets placed inside a function, and then when you run the function, you land at that point in the code. For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mean_center</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>variable</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/browser.html'>browser</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span>  <span class='nv'>variable</span> <span class='o'>-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>variable</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

If you run this function, and then try and use it later, you will be landed at where the [`browser()`](https://rdrr.io/r/base/browser.html) line is. Try running the code above and then doing `mean_center(1:10)` afterwards. An important thing to remember with [`browser()`](https://rdrr.io/r/base/browser.html) is that you need to remove [`browser()`](https://rdrr.io/r/base/browser.html) after the fact.

[`debug()`](https://rdrr.io/r/base/debug.html) and [`undebug()`](https://rdrr.io/r/base/debug.html) are like [`browser()`](https://rdrr.io/r/base/browser.html), but you run them on a function and that turns on debugging mode. Just like putting [`browser()`](https://rdrr.io/r/base/browser.html) at the top line of a function.

``` r
debug(mean_center)
mean_center(1:10)
## enter debug mode here, tinker around with the outputs
## then turn off the debugger
undebug(mean_center)
```

[`debugonce()`](https://rdrr.io/r/base/debug.html) does the [`debug()`](https://rdrr.io/r/base/debug.html) step, but just one time. It's handy because it means you don't need to run [`undebug()`](https://rdrr.io/r/base/debug.html) - sometimes I've forgotten I needed to do [`undebug()`](https://rdrr.io/r/base/debug.html) and i've felt like a madness has descended upon me.

So what to remember about this? If you want to see where a function is erroring, then you probably want to use [`debugonce()`](https://rdrr.io/r/base/debug.html) on it.

# (Not) The End

There's more to this. I don't have all the answers. I'm a decent R programmer. But I'm still learning all the time, and I make mistakes a lot. I'm not perfect, far from it! But maybe these things can help you on your journey in improving in R programming.

I didn't go into as much detail as I would have liked - there are a lot of topics here, what did I miss? What do you think are the ways to get good with R? Write a comment below :)

