---
title: 'Find Out How many Times Faster your Code is'
author: Nicholas Tierney
date: '2024-05-17'
slug: summary-benchmark
categories:
  - benchmark
  - microbenchmark
  - rstats
  - functions
  - rse
  - research software engineer
tags:
  - benchmark
  - microbenchmark
  - rstats
  - research software engineer
  - rse
output: hugodown::md_document
rmd_hash: 8f428634899a634f

---

<div class="highlight">

<img src="blinds.jpg" width="700px" style="display: block; margin: auto;" />

</div>

*My venetian blinds, in black and white*

I recently watched [Josiah Parry's](https://josiahparry.com/) wonderful video, ["Making R 300x times faster!"](https://www.youtube.com/watch?v=-v9qaqaj4Ug) It's a great demonstration of how to rewrite code to be faster, and it's worth your time. He rewrites some R code to be faster, then improves the speed again by writing some Rust code, which is called from R. He gets a 300 times speedup, which is really awesome.

Then someone writes in with an example of some code that is even faster than that, just using R code. It ends up being about 6 times faster than his Rust code. So a (300x6) 2000 times speed up. The main thing that helped with that was ensuring to vectorise your R code. Essentially, not working on the rows, but instead working on the columns.

Throughout the video Josiah makes good use of the [`bench`](https://github.com/r-lib/bench) R package to evaluate how much faster your code is. This idea is called "microbenchmarking", and it involves running your code many times to evaluate how much faster it is than some other option. The reason you want to run your code many times is there is often variation around the runtimes in your code, so you don't just want to base your improvements around a single measurement. It's a general standard approach to attempt tp truly compare your approach to another.

All this being said, you should be wary of trying to make your code fast first without good reason. You want to make sure your code does the right thing first. Don't just start trying to write performant code. Or as [Donald Knuth](https://en.wikiquote.org/wiki/Donald_Knuth) says:

> "The real problem is that programmers have spent far too much time worrying about efficiency in the wrong places and at the wrong times; **premature optimization is the root of all evil (or at least most of it) in programming.**".

If you want to learn more about how to speed up your code, I think it's worthwhile reading up on the [measuring performance](https://adv-r.hadley.nz/perf-measure.html) chapter in Advanced R.

# An example microbenchmark

Let's take an example from the [`naniar`](https://naniar.njtierney.com/) package. I'll give more detail of this story of this optimisation at the end of this section. For the moment, let's say we want to get the number of missing values in a row of a data frame. We can do something like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://dplyr.tidyverse.org'>dplyr</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; Attaching package: 'dplyr'</span></span>
<span></span><span><span class='c'>#&gt; The following objects are masked from 'package:stats':</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt;     filter, lag</span></span>
<span></span><span><span class='c'>#&gt; The following objects are masked from 'package:base':</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt;     intersect, setdiff, setequal, union</span></span>
<span></span><span><span class='nv'>my_n_miss</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>data</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/rowwise.html'>rowwise</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    n_miss <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/c_across.html'>c_across</a></span><span class='o'>(</span><span class='nf'><a href='https://tidyselect.r-lib.org/reference/everything.html'>everything</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>ungroup</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span>
<span></span>
<span><span class='nf'>my_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 153 × 7</span></span></span>
<span><span class='c'>#&gt;    Ozone Solar.R  Wind  Temp Month   Day n_miss</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>    41     190   7.4    67     5     1      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>    36     118   8      72     5     2      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>    12     149  12.6    74     5     3      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>    18     313  11.5    62     5     4      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>    <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  14.3    56     5     5      2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>    28      <span style='color: #BB0000;'>NA</span>  14.9    66     5     6      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>    23     299   8.6    65     5     7      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>    19      99  13.8    59     5     8      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     8      19  20.1    61     5     9      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    <span style='color: #BB0000;'>NA</span>     194   8.6    69     5    10      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 143 more rows</span></span></span>
<span></span></code></pre>

</div>

But we can speed this up using [`rowSums()`](https://rdrr.io/r/base/colSums.html) instead:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>new_n_miss</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>n_misses</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/colSums.html'>rowSums</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span><span class='o'>)</span></span>
<span>  <span class='nv'>data</span> <span class='o'>|&gt;</span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    n_miss <span class='o'>=</span> <span class='nv'>n_misses</span></span>
<span>  <span class='o'>)</span> <span class='o'>|&gt;</span> </span>
<span>    <span class='nf'><a href='https://tibble.tidyverse.org/reference/as_tibble.html'>as_tibble</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span>
<span></span>
<span><span class='nf'>new_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 153 × 7</span></span></span>
<span><span class='c'>#&gt;    Ozone Solar.R  Wind  Temp Month   Day n_miss</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>    41     190   7.4    67     5     1      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>    36     118   8      72     5     2      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>    12     149  12.6    74     5     3      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>    18     313  11.5    62     5     4      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>    <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  14.3    56     5     5      2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>    28      <span style='color: #BB0000;'>NA</span>  14.9    66     5     6      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>    23     299   8.6    65     5     7      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>    19      99  13.8    59     5     8      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     8      19  20.1    61     5     9      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    <span style='color: #BB0000;'>NA</span>     194   8.6    69     5    10      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 143 more rows</span></span></span>
<span></span><span><span class='nf'>my_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 153 × 7</span></span></span>
<span><span class='c'>#&gt;    Ozone Solar.R  Wind  Temp Month   Day n_miss</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>    41     190   7.4    67     5     1      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>    36     118   8      72     5     2      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>    12     149  12.6    74     5     3      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>    18     313  11.5    62     5     4      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>    <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  14.3    56     5     5      2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>    28      <span style='color: #BB0000;'>NA</span>  14.9    66     5     6      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>    23     299   8.6    65     5     7      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>    19      99  13.8    59     5     8      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     8      19  20.1    61     5     9      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    <span style='color: #BB0000;'>NA</span>     194   8.6    69     5    10      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 143 more rows</span></span></span>
<span></span></code></pre>

</div>

We can measure the speed using [`bench::mark()`](http://bench.r-lib.org/reference/mark.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://bench.r-lib.org/'>bench</a></span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>bm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://bench.r-lib.org/reference/mark.html'>mark</a></span><span class='o'>(</span></span>
<span>  old <span class='o'>=</span> <span class='nf'>my_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span>,</span>
<span>  new <span class='o'>=</span> <span class='nf'>new_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>bm</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 × 6</span></span></span>
<span><span class='c'>#&gt;   expression      min   median `itr/sec` mem_alloc `gc/sec`</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;bch:expr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;bch:tm&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;bch:tm&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;bch:byt&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> old          23.9ms   23.9ms      41.8   355.5KB    334. </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> new         347.5µs  384.5µs    <span style='text-decoration: underline;'>2</span>385.     81.8KB     34.8</span></span>
<span></span></code></pre>

</div>

This runs the code at least twice, and prints out the amount of time it takes to run the code provided on the right hand side of "old" and "new". But you can name them whatever you want.

Now, it can be kind of hard to see just *how much* faster this is, if you just look at comparing the times, as the times are given here in...well, actually I'm not sure why our friend from the greek alphabet mu, µ, from the greek alphabet is here, actually? If, like me, you needed to [double check the standard measures of order of magnitude wiki page](https://simple.wikipedia.org/wiki/Order_of_magnitude), you might not know that "ms" means milli - or one thousandth, and µ means "micro", or one millionth. The point is that the new one is many times faster than the old one.

We can do a plot to help see this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/graphics/plot.default.html'>plot</a></span><span class='o'>(</span><span class='nv'>bm</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Loading required namespace: tidyr</span></span>
<span></span></code></pre>
<img src="figs/unnamed-chunk-5-1.png" width="700px" style="display: block; margin: auto;" />

</div>

So we can see that the new one really is *a lot* faster.

But if I just want to be able to say something like:

> It is XX times faster

then we can use the (somewhat unknown?) `relative = TRUE` option of [bench's S3 method for `summary` method](https://bench.r-lib.org/reference/summary.bench_mark.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/summary.html'>summary</a></span><span class='o'>(</span><span class='nv'>bm</span>, relative <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 2 × 6</span></span></span>
<span><span class='c'>#&gt;   expression   min median `itr/sec` mem_alloc `gc/sec`</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;bch:expr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> old         68.7   62.2       1        4.34     9.62</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> new          1      1        57.0      1        1</span></span>
<span></span></code></pre>

</div>

And this is great, from this we can see it is about 60 times faster. And that the old approach uses 15 times more memory.

## The story behind this speedup in naniar.

Now, I didn't just come up with a speedup for missing values on the fly. The story here is that there was going to be some (very generous) improvements to the naniar package from [Romain François](https://github.com/romainfrancois) [in the form of C++ code](https://github.com/njtierney/naniar/issues/113). However, [Jim Hester](https://www.jimhester.com/) suggested some changes, I think twitter (which I can't find anymore), and he then kindly submitted a [pull request showing that rowSums in R ends up being plenty fast](https://github.com/njtierney/naniar/pull/112/).

This is a similar story to Josiah's, where he used Rust code to get it faster, but then there was a faster way just staying within R.

Sometimes, you don't need extra C or Fortran or Rust. R is enough!

And if you want to be able to compare the speeds of things, don't forget the `relative = TRUE` argument in `summary` when using [`bench::mark`](http://bench.r-lib.org/reference/mark.html).

# Other packages for microbenchmarking

`bench` isn't the only way to measure things! Other ones I've enjoyed using in the past are [microbenchmark](https://cran.r-project.org/web/packages/microbenchmark/index.html) and [tictoc](https://cran.r-project.org/web/packages/tictoc/index.html). I've particularly enjoyed `tictoc` because you get to do this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/jabiru/tictoc'>tictoc</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/tictoc/man/tic.html'>tic</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='nf'>new_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 153 × 7</span></span></span>
<span><span class='c'>#&gt;    Ozone Solar.R  Wind  Temp Month   Day n_miss</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>    41     190   7.4    67     5     1      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>    36     118   8      72     5     2      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>    12     149  12.6    74     5     3      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>    18     313  11.5    62     5     4      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>    <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  14.3    56     5     5      2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>    28      <span style='color: #BB0000;'>NA</span>  14.9    66     5     6      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>    23     299   8.6    65     5     7      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>    19      99  13.8    59     5     8      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     8      19  20.1    61     5     9      0</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    <span style='color: #BB0000;'>NA</span>     194   8.6    69     5    10      1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># ℹ 143 more rows</span></span></span>
<span></span><span><span class='nf'><a href='https://rdrr.io/pkg/tictoc/man/tic.html'>toc</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; 0.01 sec elapsed</span></span>
<span></span></code></pre>

</div>

Which feels a bit nicer than using [`system.time()`](https://rdrr.io/r/base/system.time.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/system.time.html'>system.time</a></span><span class='o'>(</span><span class='o'>&#123;</span></span>
<span>  <span class='nf'>new_n_miss</span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;    user  system elapsed </span></span>
<span><span class='c'>#&gt;   0.001   0.000   0.002</span></span>
<span></span></code></pre>

</div>

Also, notice that those two times are different? This is why we use benchmarking, to run those checks many times!

# End

And that's it, that's the blog post. The `relative = TRUE` option in `mark` is super neat, and I don't think many people know about it. Thanks again to Jim Hester for originally creating the `bench` package.

