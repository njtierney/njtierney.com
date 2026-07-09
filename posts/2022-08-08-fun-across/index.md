---
title: Using `across()` to create multiple columns
date: '2022-08-08'
slug: fun-across
categories:
  - rstats
  - functions
aliases:
  - /post/2022/08/08/fun-across/
---

<div class="highlight">

<img src="imgs/across-birds-small.jpg" width="700px" style="display: block; margin: auto;" />

</div>

*pigeons across the drain, Nick Tierney, film, olympus XA*

A colleague of mine the other day had a question along the lines of:

> How do I add multiple columns that give the ranks of values in corresponding columns

And I ended up cooking up a really fun example of using `across` from `dplyr`. I thought it would be fun to share!

Let's give a little more detail.

Load up the tidyverse.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span><span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ───────────────────────────── tidyverse 1.3.1 ──</span></span><span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.6     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.4</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.7     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.9</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.1</span></span><span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span></code></pre>

</div>

The data they had referred to concentrations of a quantity, that they wanted to rank. We can create these like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span></span>
<span>  x_1 <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Uniform.html'>runif</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,</span>
<span>  x_2 <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Uniform.html'>runif</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span>,</span>
<span>  x_3 <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/stats/Uniform.html'>runif</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span></span>
<span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 3</span></span></span>
<span><span class='c'>#&gt;       x_1   x_2   x_3</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0.071<span style='text-decoration: underline;'>2</span> 0.784 0.875</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.295  0.734 0.185</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.385  0.844 0.690</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.648  0.480 0.807</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.272  0.323 0.868</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.554  0.590 0.859</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 0.421  0.270 0.433</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 0.724  0.732 0.870</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.654  0.973 0.606</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.159  0.782 0.720</span></span></code></pre>

</div>

Or for fun, I did this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>vals</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/Uniform.html'>runif</a></span><span class='o'>(</span><span class='m'>30</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/as_tibble.html'>as_tibble</a></span><span class='o'>(</span></span>
<span>  x <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/matrix.html'>matrix</a></span><span class='o'>(</span><span class='nv'>vals</span>, nrow <span class='o'>=</span> <span class='m'>10</span><span class='o'>)</span>,</span>
<span>  .name_repair <span class='o'>=</span> <span class='nf'>janitor</span><span class='nf'>::</span><span class='nv'><a href='https://rdrr.io/pkg/janitor/man/make_clean_names.html'>make_clean_names</a></span></span>
<span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/rename.html'>rename</a></span><span class='o'>(</span></span>
<span>    x_1 <span class='o'>=</span> <span class='nv'>x</span></span>
<span>  <span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 3</span></span></span>
<span><span class='c'>#&gt;       x_1    x_2   x_3</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0.927  0.661  0.454</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.634  0.989  0.360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.373  0.729  0.581</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 0.819  0.277  0.436</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.242  0.308  0.452</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620</span></span></code></pre>

</div>

> An aside: prefer `dat` over `df`. I've been burned recently by using `df` as my go-to name for data frames, but it turns out that `df` is actually a function in R, for calculating the density of an F distribution. Which is awesome, but sometimes leads to funny errors that you might not expect.

OK, so what my friend wanted was something like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>  </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    x_1_rank <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='nv'>x_1</span><span class='o'>)</span>,</span>
<span>    x_2_rank <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='nv'>x_2</span><span class='o'>)</span>,</span>
<span>    x_3_rank <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='nv'>x_3</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 6</span></span></span>
<span><span class='c'>#&gt;       x_1    x_2   x_3 x_1_rank x_2_rank x_3_rank</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0.927  0.661  0.454       10        7        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970        8        2       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278        5        1        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.634  0.989  0.360        7       10        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675        2        9        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.373  0.729  0.581        6        8        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151        1        6        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 0.819  0.277  0.436        9        3        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.242  0.308  0.452        4        5        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620        3        4        8</span></span></code></pre>

</div>

Now, that's relatively easy. But they actually have a lot of these concentration columns - sometimes just 10, other times many times that number.

The reason you might want to avoid writing this out each time is because it will involve a lot of reptition, where you might accidentally copy something twice or not increment the numbers. E.g.,

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span>  </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    x_1_rank <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='nv'>x_1</span><span class='o'>)</span>,</span>
<span>    x_2_rank <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='nv'>x_2</span><span class='o'>)</span>,</span>
<span>    x_3_rank <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/rank.html'>rank</a></span><span class='o'>(</span><span class='nv'>x_2</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 6</span></span></span>
<span><span class='c'>#&gt;       x_1    x_2   x_3 x_1_rank x_2_rank x_3_rank</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0.927  0.661  0.454       10        7        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970        8        2        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278        5        1        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.634  0.989  0.360        7       10       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675        2        9        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.373  0.729  0.581        6        8        8</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151        1        6        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 0.819  0.277  0.436        9        3        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.242  0.308  0.452        4        5        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620        3        4        4</span></span></code></pre>

</div>

See the error? `x_3_rank` is actually from `rank(x_2)`

So the question is, can you generalise this type of column creation?

Yes! Yes we can. With `across`. It looks like this.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span></span>
<span>      .cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/everything.html'>everything</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      .fns <span class='o'>=</span> <span class='nv'>rank</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 3</span></span></span>
<span><span class='c'>#&gt;      x_1   x_2   x_3</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>    10     7     6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     8     2    10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     5     1     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     7    10     3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     2     9     9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6     8     7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     1     6     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     9     3     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     4     5     5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     3     4     8</span></span></code></pre>

</div>

This says:

> mutate across all columns, and use the function, `rank`, on each one.

Uh, but we want the other columns preserved...how do we do that?

With `.names` - we specify a special pattern on how we want to name the columns with `.names = "{.col}_rank"`, which says: "call it the name of the column, and then add"\_rank" to it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span></span>
<span>      .cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/everything.html'>everything</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      .fns <span class='o'>=</span> <span class='nv'>rank</span>,</span>
<span>      .names <span class='o'>=</span> <span class='s'>"&#123;.col&#125;_rank"</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 6</span></span></span>
<span><span class='c'>#&gt;       x_1    x_2   x_3 x_1_rank x_2_rank x_3_rank</span></span>
<span><span class='c'>#&gt;     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> 0.927  0.661  0.454       10        7        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> 0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970        8        2       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> 0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278        5        1        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> 0.634  0.989  0.360        7       10        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> 0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675        2        9        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> 0.373  0.729  0.581        6        8        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> 0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151        1        6        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> 0.819  0.277  0.436        9        3        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> 0.242  0.308  0.452        4        5        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> 0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620        3        4        8</span></span></code></pre>

</div>

OK, but what if we've got data that contains other columns we don't want to apply `rank` to - say, some data that looks like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat_more</span> <span class='o'>&lt;-</span> <span class='nv'>dat</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://tibble.tidyverse.org/reference/rownames.html'>rowid_to_column</a></span><span class='o'>(</span>var <span class='o'>=</span> <span class='s'>"id"</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>code <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span><span class='o'>(</span><span class='nv'>LETTERS</span>, <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>n</a></span><span class='o'>(</span><span class='o'>)</span><span class='o'>)</span>,</span>
<span>         .after <span class='o'>=</span> <span class='nv'>id</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat_more</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 5</span></span></span>
<span><span class='c'>#&gt;       id code     x_1    x_2   x_3</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927  0.661  0.454</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634  0.989  0.360</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373  0.729  0.581</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819  0.277  0.436</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242  0.308  0.452</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620</span></span></code></pre>

</div>

We can tell it which columns to pay attention to, or even avoid, like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># pay attention to "x_"</span></span>
<span><span class='nv'>dat_more_rank</span> <span class='o'>&lt;-</span> <span class='nv'>dat_more</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span></span>
<span>      .cols <span class='o'>=</span> <span class='nf'><a href='https://tidyselect.r-lib.org/reference/starts_with.html'>starts_with</a></span><span class='o'>(</span><span class='s'>"x_"</span><span class='o'>)</span>,</span>
<span>      .fns <span class='o'>=</span> <span class='nv'>rank</span>,</span>
<span>      .names <span class='o'>=</span> <span class='s'>"&#123;.col&#125;_rank"</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span></span>
<span><span class='nv'>dat_more_rank</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span></span>
<span><span class='c'>#&gt;       id code     x_1    x_2   x_3 x_1_rank x_2_rank x_3_rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927  0.661  0.454       10        7        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970        8        2       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278        5        1        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634  0.989  0.360        7       10        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675        2        9        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373  0.729  0.581        6        8        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151        1        6        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819  0.277  0.436        9        3        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242  0.308  0.452        4        5        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620        3        4        8</span></span><span></span>
<span><span class='c'># do it to everything EXCEPT</span></span>
<span><span class='nv'>dat_more</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span></span>
<span>      .cols <span class='o'>=</span> <span class='o'>-</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>id</span>, <span class='nv'>code</span><span class='o'>)</span>,</span>
<span>      .fns <span class='o'>=</span> <span class='nv'>rank</span>,</span>
<span>      .names <span class='o'>=</span> <span class='s'>"&#123;.col&#125;_rank"</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span></span>
<span><span class='c'>#&gt;       id code     x_1    x_2   x_3 x_1_rank x_2_rank x_3_rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927  0.661  0.454       10        7        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792  0.098<span style='text-decoration: underline;'>9</span> 0.970        8        2       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346  0.054<span style='text-decoration: underline;'>4</span> 0.278        5        1        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634  0.989  0.360        7       10        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span> 0.741  0.675        2        9        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373  0.729  0.581        6        8        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span> 0.429  0.151        1        6        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819  0.277  0.436        9        3        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242  0.308  0.452        4        5        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span> 0.292  0.620        3        4        8</span></span></code></pre>

</div>

OK, but can we make this look a little bit nicer by having the columns be like `x_1`, then `x_1_rank` and so on?

Sure! We can take advantage of the fact that we've got a pretty systematic naming scheme in this case.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>new_col_order</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/sort.html'>sort</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>dat_more_rank</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>new_col_order</span></span><span><span class='c'>#&gt; [1] "code"     "id"       "x_1"      "x_1_rank" "x_2"      "x_2_rank" "x_3"     </span></span>
<span><span class='c'>#&gt; [8] "x_3_rank"</span></span></code></pre>

</div>

We can use `relocate` to specify a new column order:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat_more_rank</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/relocate.html'>relocate</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>id</span>,</span>
<span>    <span class='nv'>code</span>,</span>
<span>    <span class='nv'>new_col_order</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; Note: Using an external vector in selections is ambiguous.</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB;'>ℹ</span> Use `all_of(new_col_order)` instead of `new_col_order` to silence this message.</span></span>
<span><span class='c'>#&gt; <span style='color: #0000BB;'>ℹ</span> See &lt;https://tidyselect.r-lib.org/reference/faq-external-vector.html&gt;.</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>This message is displayed once per session.</span></span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span></span>
<span><span class='c'>#&gt;       id code     x_1 x_1_rank    x_2 x_2_rank   x_3 x_3_rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927        10 0.661         7 0.454        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792         8 0.098<span style='text-decoration: underline;'>9</span>        2 0.970       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346         5 0.054<span style='text-decoration: underline;'>4</span>        1 0.278        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634         7 0.989        10 0.360        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span>        2 0.741         9 0.675        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373         6 0.729         8 0.581        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span>        1 0.429         6 0.151        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819         9 0.277         3 0.436        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242         4 0.308         5 0.452        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span>        3 0.292         4 0.620        8</span></span></code></pre>

</div>

Huh, apparently we need to use `all_of`, since using an external vector is ambiguous! Right you are, tidyverse team.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat_more_rank</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/relocate.html'>relocate</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>id</span>,</span>
<span>    <span class='nv'>code</span>,</span>
<span>    <span class='nf'><a href='https://tidyselect.r-lib.org/reference/all_of.html'>all_of</a></span><span class='o'>(</span><span class='nv'>new_col_order</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span></span>
<span><span class='c'>#&gt;       id code     x_1 x_1_rank    x_2 x_2_rank   x_3 x_3_rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927        10 0.661         7 0.454        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792         8 0.098<span style='text-decoration: underline;'>9</span>        2 0.970       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346         5 0.054<span style='text-decoration: underline;'>4</span>        1 0.278        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634         7 0.989        10 0.360        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span>        2 0.741         9 0.675        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373         6 0.729         8 0.581        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span>        1 0.429         6 0.151        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819         9 0.277         3 0.436        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242         4 0.308         5 0.452        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span>        3 0.292         4 0.620        8</span></span></code></pre>

</div>

Or alternatively:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat_more_rank</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/relocate.html'>relocate</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>id</span>,</span>
<span>    <span class='nv'>code</span>,</span>
<span>    <span class='nf'><a href='https://rdrr.io/r/base/sort.html'>sort</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/names.html'>names</a></span><span class='o'>(</span><span class='nv'>.</span><span class='o'>)</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span></span>
<span><span class='c'>#&gt;       id code     x_1 x_1_rank    x_2 x_2_rank   x_3 x_3_rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927        10 0.661         7 0.454        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792         8 0.098<span style='text-decoration: underline;'>9</span>        2 0.970       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346         5 0.054<span style='text-decoration: underline;'>4</span>        1 0.278        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634         7 0.989        10 0.360        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span>        2 0.741         9 0.675        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373         6 0.729         8 0.581        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span>        1 0.429         6 0.151        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819         9 0.277         3 0.436        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242         4 0.308         5 0.452        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span>        3 0.292         4 0.620        8</span></span></code></pre>

</div>

`relocate` is a relatively new operation, it just exists to relocate existing columns, and won't remove other columns. In the past I would have done something like:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>dat_more_rank</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/select.html'>select</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>id</span>,</span>
<span>    <span class='nv'>code</span>,</span>
<span>    <span class='nf'><a href='https://tidyselect.r-lib.org/reference/all_of.html'>all_of</a></span><span class='o'>(</span><span class='nv'>new_col_order</span><span class='o'>)</span>,</span>
<span>    <span class='nf'><a href='https://tidyselect.r-lib.org/reference/everything.html'>everything</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 10 × 8</span></span></span>
<span><span class='c'>#&gt;       id code     x_1 x_1_rank    x_2 x_2_rank   x_3 x_3_rank</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Q     0.927        10 0.661         7 0.454        6</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     2 R     0.792         8 0.098<span style='text-decoration: underline;'>9</span>        2 0.970       10</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     3 Y     0.346         5 0.054<span style='text-decoration: underline;'>4</span>        1 0.278        2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     4 B     0.634         7 0.989        10 0.360        3</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 T     0.060<span style='text-decoration: underline;'>5</span>        2 0.741         9 0.675        9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 A     0.373         6 0.729         8 0.581        7</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     7 M     0.035<span style='text-decoration: underline;'>9</span>        1 0.429         6 0.151        1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     8 K     0.819         9 0.277         3 0.436        4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     9 C     0.242         4 0.308         5 0.452        5</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>    10 G     0.065<span style='text-decoration: underline;'>4</span>        3 0.292         4 0.620        8</span></span></code></pre>

</div>

With that `everything` part there being to capture any columns I forgot about, because `select` will only keep the specified columns.

There are many ways we can do these kinds of things, but to me this felt like a nice fun example.

# End

Anywho, that's a bit of tidyverse magic, maybe it'll be useful for you!

