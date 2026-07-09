---
title: naniar Version 1.0.0
date: '2023-02-07'
slug: naniar-version-1
categories:
  - rstats
  - data visualisation
  - Missing Data
aliases:
  - /post/2023/02/07/naniar-version-1/
---

# naniar 1.0.0

I'm very pleased to announce that naniar version 1.0.0 is now on CRAN!

Version 1.0.0 of naniar is to signify that this release is associated with the publication of the associated JSS paper <doi:10.18637/jss.v105.i07> (!!!). This paper has been the labour of a lot of effort between myself and [Di Cook](http://www.dicook.org/), and I am very excited to be able to share it.

There is still a lot to do in naniar, and this release does not signify that there are no changes upcoming. It is a 1.0.0 release to establish that this is a stable release, and any changes upcoming will go through a more formal deprecation process.

Here's a brief description of some of the changes in this release

# New things

## JSS publication

You can now retrieve a citation for `naniar` with [`citation()`](https://rdrr.io/r/utils/citation.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/utils/citation.html'>citation</a></span><span class='o'>(</span><span class='s'>"naniar"</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; To cite naniar in publications use:</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt;   Tierney N, Cook D (2023). "Expanding Tidy Data Principles to</span></span>
<span><span class='c'>#&gt;   Facilitate Missing Data Exploration, Visualization and Assessment of</span></span>
<span><span class='c'>#&gt;   Imputations." _Journal of Statistical Software_, *105*(7), 1-31.</span></span>
<span><span class='c'>#&gt;   doi:10.18637/jss.v105.i07 &lt;https://doi.org/10.18637/jss.v105.i07&gt;.</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt; A BibTeX entry for LaTeX users is</span></span>
<span><span class='c'>#&gt; </span></span>
<span><span class='c'>#&gt;   @Article&#123;,</span></span>
<span><span class='c'>#&gt;     title = &#123;Expanding Tidy Data Principles to Facilitate Missing Data Exploration, Visualization and Assessment of Imputations&#125;,</span></span>
<span><span class='c'>#&gt;     author = &#123;Nicholas Tierney and Dianne Cook&#125;,</span></span>
<span><span class='c'>#&gt;     journal = &#123;Journal of Statistical Software&#125;,</span></span>
<span><span class='c'>#&gt;     year = &#123;2023&#125;,</span></span>
<span><span class='c'>#&gt;     volume = &#123;105&#125;,</span></span>
<span><span class='c'>#&gt;     number = &#123;7&#125;,</span></span>
<span><span class='c'>#&gt;     pages = &#123;1--31&#125;,</span></span>
<span><span class='c'>#&gt;     doi = &#123;10.18637/jss.v105.i07&#125;,</span></span>
<span><span class='c'>#&gt;   &#125;</span></span>
<span></span></code></pre>

</div>

## Set missing values with `set_n_miss()` and `set_prop_miss()`

These functions allow you to set a random amount of missingness either as a number of values, or as a proportion:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/njtierney/naniar'>naniar</a></span><span class='o'>)</span></span>
<span><span class='nv'>vec</span> <span class='o'>&lt;-</span> <span class='m'>1</span><span class='o'>:</span><span class='m'>10</span></span>
<span><span class='c'># different each time</span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_n_miss</a></span><span class='o'>(</span><span class='nv'>vec</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;  [1] NA  2  3  4  5  6  7  8  9 10</span></span>
<span></span><span><span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_n_miss</a></span><span class='o'>(</span><span class='nv'>vec</span>, n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 NA</span></span>
<span></span><span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_prop_miss</a></span><span class='o'>(</span><span class='nv'>vec</span>, prop <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;  [1] NA  2  3 NA  5  6  7  8  9 10</span></span>
<span></span><span><span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_prop_miss</a></span><span class='o'>(</span><span class='nv'>vec</span>, prop <span class='o'>=</span> <span class='m'>0.6</span><span class='o'>)</span></span>
<span><span class='c'>#&gt;  [1]  1 NA NA  4 NA NA NA  8  9 NA</span></span>
<span></span></code></pre>

</div>

I would suggest that these functions are used inside a dataframe. I will provide a few examples below using `dplyr`. For just one variable, you could set missingness like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ───────────────────────────── tidyverse 1.3.2 ──</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.4.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 1.0.1</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.8     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.1.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.3.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.5.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.3     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 1.0.0</span></span>
<span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span>
<span></span><span><span class='nv'>mtcars_df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/as_tibble.html'>as_tibble</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>mtcars_df</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/miss-one-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span></span>
<span><span class='nv'>mtcars_miss_mpg</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars_df</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>mpg <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_prop_miss</a></span><span class='o'>(</span><span class='nv'>mpg</span>, <span class='m'>0.5</span><span class='o'>)</span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>mtcars_miss_mpg</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/miss-one-2.png" width="700px" style="display: block; margin: auto;" />

</div>

Or add missingness to a few variables:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mtcars_miss_some</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars_df</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span></span>
<span>      <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>mpg</span>, <span class='nv'>cyl</span>, <span class='nv'>disp</span><span class='o'>)</span>,</span>
<span>      \<span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_prop_miss</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='m'>0.5</span><span class='o'>)</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span></span>
<span><span class='nv'>mtcars_miss_some</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 32 × 11</span></span></span>
<span><span class='c'>#&gt;      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>   <span style='color: #BB0000;'>NA</span>    110  3.9   2.62  16.5     0     1     4     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  21      <span style='color: #BB0000;'>NA</span>   <span style='color: #BB0000;'>NA</span>    110  3.9   2.88  17.0     0     1     4     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  22.8     4  108     93  3.85  2.32  18.6     1     1     4     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  21.4    <span style='color: #BB0000;'>NA</span>  258    110  3.08  3.22  19.4     1     0     3     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>   <span style='color: #BB0000;'>NA</span>    175  3.15  3.44  17.0     0     0     3     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  18.1     6   <span style='color: #BB0000;'>NA</span>    105  2.76  3.46  20.2     1     0     3     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  14.3     8   <span style='color: #BB0000;'>NA</span>    245  3.21  3.57  15.8     0     0     3     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  147.    62  3.69  3.19  20       1     0     4     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  22.8    <span style='color: #BB0000;'>NA</span>  141.    95  3.92  3.15  22.9     1     0     4     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  19.2     6   <span style='color: #BB0000;'>NA</span>    123  3.92  3.44  18.3     1     0     4     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 22 more rows</span></span></span>
<span></span><span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>mtcars_miss_some</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/miss-some-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Or you can add missingness to all variables like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mtcars_miss_all</span> <span class='o'>&lt;-</span> <span class='nv'>mtcars_df</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/across.html'>across</a></span><span class='o'>(</span></span>
<span>      <span class='nf'><a href='https://tidyselect.r-lib.org/reference/everything.html'>everything</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      \<span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/pkg/naniar/man/set-prop-n-miss.html'>set_prop_miss</a></span><span class='o'>(</span><span class='nv'>x</span>, <span class='m'>0.5</span><span class='o'>)</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span></span>
<span><span class='nv'>mtcars_miss_all</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 32 × 11</span></span></span>
<span><span class='c'>#&gt;      mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  160    110  3.9   2.62  16.5    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     4    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>  21      <span style='color: #BB0000;'>NA</span>   <span style='color: #BB0000;'>NA</span>    110  3.9   2.88  17.0     0     1    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>  22.8     4   <span style='color: #BB0000;'>NA</span>     <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     18.6     1    <span style='color: #BB0000;'>NA</span>     4    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>   <span style='color: #BB0000;'>NA</span>    110 <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     19.4    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>  <span style='color: #BB0000;'>NA</span>       8   <span style='color: #BB0000;'>NA</span>     <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>     3.44  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     3     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>  18.1     6  225     <span style='color: #BB0000;'>NA</span> <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     20.2     1     0     3     1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>   <span style='color: #BB0000;'>NA</span>     <span style='color: #BB0000;'>NA</span>  3.21  3.57  <span style='color: #BB0000;'>NA</span>       0    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>  24.4    <span style='color: #BB0000;'>NA</span>  147.    <span style='color: #BB0000;'>NA</span>  3.69  3.19  20      <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span>     4     2</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>  <span style='color: #BB0000;'>NA</span>       4  141.    95  3.92  3.15  22.9    <span style='color: #BB0000;'>NA</span>     0    <span style='color: #BB0000;'>NA</span>    <span style='color: #BB0000;'>NA</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>  <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>  168.   123  3.92 <span style='color: #BB0000;'>NA</span>     <span style='color: #BB0000;'>NA</span>      <span style='color: #BB0000;'>NA</span>     0     4     4</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 22 more rows</span></span></span>
<span></span><span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>mtcars_miss_all</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/miss-all-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/naniar/man/miss_var_summary.html'>miss_var_summary</a></span><span class='o'>(</span><span class='nv'>mtcars_miss_all</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 11 × 3</span></span></span>
<span><span class='c'>#&gt;    variable n_miss pct_miss</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> mpg          16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> cyl          16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> disp         16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> hp           16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> drat         16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> wt           16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> qsec         16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> vs           16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> am           16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> gear         16       50</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>11</span> carb         16       50</span></span>
<span></span></code></pre>

</div>

This resolves [#298](https://github.com/njtierney/naniar/issues/298).

## Bug Fixes and other small changes

-   Replaced [`tidyr::gather`](https://tidyr.tidyverse.org/reference/gather.html) with [`tidyr::pivot_longer`](https://tidyr.tidyverse.org/reference/pivot_longer.html) ([#301](https://github.com/njtierney/naniar/issues/301))

-   Fixed bug in [`gg_miss_var()`](https://rdrr.io/pkg/naniar/man/gg_miss_var.html) where a warning appears to due change in how to remove legend ([#288](https://github.com/njtierney/naniar/issues/288)).

-   Removed package `gdtools` as it is no longer needed ([302](https://github.com/njtierney/naniar/issues/302)).

-   Imported the packages, `vctrs` and `cli` to assist with internal checking and error messages. Both of these packages are "free" dependencies, as they imported by existing dependencies, `dplyr` and `ggplot2`.

# Some thank yous

Thank you to everyone who has contributed to this release! Especially the following people: [@ddauber](https://github.com/ddauber), [@davidgohel](https://github.com/davidgohel).

I am also excited to announce that I have been supported by the R Consortium to improve how R handles missing values! Through this grant, I will be improving the R packages `naniar` and `visdat`. I will be posting more details about this soon, but what this means for you the user is that there will be more updates and improvements to both of these packages in the coming months. Stay tuned.

