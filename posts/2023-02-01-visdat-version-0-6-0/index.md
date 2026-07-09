---
title: visdat Version 0.6.0
date: '2023-02-02'
slug: visdat-060
categories:
  - rstats
  - data visualisation
  - Missing Data
  - rbloggers
aliases:
  - /post/2023/02/02/visdat-060/
---

I'm please to say that visdat version 0.6.0 (codename: "Superman, Lazlo Bane") is now on CRAN. This is the first release in nearly 3 years, there are a couple of new functions for visualising numeric and binary data, as well as some maintenance and bug fixes.

Let's walk through some of the new features, bug fixes, and other misc changes.

# New Features

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/options.html'>options</a></span><span class='o'>(</span>tidyverse.quiet <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span>
<span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://docs.ropensci.org/visdat/'>visdat</a></span><span class='o'>)</span></span></code></pre>

</div>

## `vis_value()` - visualise values

The idea of [`vis_value()`](https://docs.ropensci.org/visdat/reference/vis_value.html) is to visualise numeric data, so that you can get a quick idea of the values in your dataset. It does this by scaling all the data between 0 and 1, but it only works with numeric data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_value.html'>vis_value</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/vis-value-1.png" width="700px" style="display: block; margin: auto;" />

</div>

It can be fun and interesting to arrange by a variable and then show see how that changes the plot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_cor.html'>vis_cor</a></span><span class='o'>(</span><span class='nv'>mtcars</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/vis-cor-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>mtcars</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/arrange.html'>arrange</a></span><span class='o'>(</span><span class='nv'>cyl</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_value.html'>vis_value</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/vis-cor-2.png" width="700px" style="display: block; margin: auto;" />

</div>

Although fair warning that there's a whole set of statistics/data visualisation that focusses on how to arrange rows and columns - a technique called seriation. For a fun introduction, I'd recommend this lovely [blogpost](http://nicolas.kruchten.com/content/2018/02/seriation/) by [Nicholas Kruchten](https://github.com/nicolaskruchten). One day I will [implement seriation in visdat](https://github.com/ropensci/visdat/issues/8).

Note that if you use [`vis_value()`](https://docs.ropensci.org/visdat/reference/vis_value.html) on a dataset that isn't entirely numeric, you will get an error:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_value.html'>vis_value</a></span><span class='o'>(</span><span class='nv'>diamonds</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00; font-weight: bold;'>Error</span><span style='font-weight: bold;'> in `test_if_all_numeric()` at </span><a href='file:///Users/nick/github/njtierney/visdat/R/vis-value.R'><span style='font-weight: bold;'>visdat/R/vis-value.R:33:2</span></a><span style='font-weight: bold;'>:</span></span></span>
<span><span class='c'>#&gt; <span style='color: #BBBB00;'>!</span> Data input can only contain numeric values</span></span>
<span><span class='c'>#&gt; Please subset the data to the numeric values you would like.</span></span>
<span><span class='c'>#&gt; `dplyr::select(&lt;data&gt;, where(is.numeric))`</span></span>
<span><span class='c'>#&gt; Can be helpful here!</span></span>
<span></span></code></pre>

</div>

## `vis_binary()` visualise binary values

The [`vis_binary()`](https://docs.ropensci.org/visdat/reference/vis_binary.html) function is for visualising datasets with binary values - similar to [`vis_value()`](https://docs.ropensci.org/visdat/reference/vis_value.html), but just for binary data (0, 1, NA).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_binary.html'>vis_binary</a></span><span class='o'>(</span><span class='nv'>dat_bin</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/vis-binary-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Thank you to [Trish Gilholm](https://child-health-research.centre.uq.edu.au/profile/3264/trish-gilholm) for her suggested use case for this.

## Facetting in visdat

It is now possible to perform facetting for the following functions in visdat: [`vis_dat()`](https://docs.ropensci.org/visdat/reference/vis_dat.html), [`vis_cor()`](https://docs.ropensci.org/visdat/reference/vis_cor.html), and [`vis_miss()`](https://docs.ropensci.org/visdat/reference/vis_miss.html) via the `facet` argument. This lead to some internal cleaning up of package code (always fun to revisit some old code and refactor!) Here's an example of facetting:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_dat.html'>vis_dat</a></span><span class='o'>(</span><span class='nv'>airquality</span>, facet <span class='o'>=</span> <span class='nv'>Month</span><span class='o'>)</span> </span>
</code></pre>
<img src="figs/vis-dat-facet-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_cor.html'>vis_cor</a></span><span class='o'>(</span><span class='nv'>airquality</span>, facet <span class='o'>=</span> <span class='nv'>Month</span><span class='o'>)</span> </span>
</code></pre>
<img src="figs/vis-cor-facet-1.png" width="700px" style="display: block; margin: auto;" />

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>airquality</span>, facet <span class='o'>=</span> <span class='nv'>Month</span><span class='o'>)</span> </span>
</code></pre>
<img src="figs/vis-miss-facet-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Notably for `vis_miss` when using facetting, you don't get column missingness summaries, as I couldn't quite work out how to do this for each facet.

Thank you to [Sam Firke's](https://twitter.com/samfirke/status/984425923243134976) initial tweet on this that inspired this, and [Jonathan Zadra's](https://github.com/jzadra) contributions in the [issue thread](https://github.com/ropensci/visdat/issues/78).

The next release will implement facetting for [`vis_value()`](https://docs.ropensci.org/visdat/reference/vis_value.html), [`vis_binary()`](https://docs.ropensci.org/visdat/reference/vis_binary.html), [`vis_compare()`](https://docs.ropensci.org/visdat/reference/vis_compare.html), [`vis_expect()`](https://docs.ropensci.org/visdat/reference/vis_expect.html), and [`vis_guess()`](https://docs.ropensci.org/visdat/reference/vis_guess.html) - see [#159](https://github.com/ropensci/visdat/issues/159) to keep track.

## Data methods for plotting

Related to facetting, I have implemented methods that provide data methods for plots with [`data_vis_dat()`](https://docs.ropensci.org/visdat/reference/data-vis-dat.html), [`data_vis_cor()`](https://docs.ropensci.org/visdat/reference/data-vis-cor.html), and [`data_vis_miss()`](https://docs.ropensci.org/visdat/reference/data-vis-miss.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/data-vis-dat.html'>data_vis_dat</a></span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 918 × 4</span></span></span>
<span><span class='c'>#&gt;     rows variable valueType value</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Day      integer   41   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     1 Month    integer   190  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     1 Ozone    integer   7.4  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     1 Solar.R  integer   67   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     1 Temp     integer   5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     1 Wind     numeric   1    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     2 Day      integer   36   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     2 Month    integer   118  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     2 Ozone    integer   8    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     2 Solar.R  integer   72   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 908 more rows</span></span></span>
<span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/data-vis-miss.html'>data_vis_miss</a></span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 918 × 4</span></span></span>
<span><span class='c'>#&gt;     rows variable valueType value</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     1 Day      FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     1 Month    FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     1 Ozone    FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     1 Solar.R  FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     1 Temp     FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     1 Wind     FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     2 Day      FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     2 Month    FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     2 Ozone    FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     2 Solar.R  FALSE     FALSE</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 908 more rows</span></span></span>
<span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/data-vis-cor.html'>data_vis_cor</a></span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 3</span></span></span>
<span><span class='c'>#&gt;    row_1   row_2     value</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Ozone   Ozone    1     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Ozone   Solar.R  0.348 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Ozone   Wind    -<span style='color: #BB0000;'>0.602</span> </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Ozone   Temp     0.698 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Ozone   Month    0.165 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Ozone   Day     -<span style='color: #BB0000;'>0.013</span><span style='color: #BB0000; text-decoration: underline;'>2</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Solar.R Ozone    0.348 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Solar.R Solar.R  1     </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Solar.R Wind    -<span style='color: #BB0000;'>0.056</span><span style='color: #BB0000; text-decoration: underline;'>8</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Solar.R Temp     0.276 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span>
<span></span></code></pre>

</div>

The implementation of this works by providing these functions as S3 methods that have a `.grouped_df` method to facilitate plotting with facets.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>airquality</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>Month</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://docs.ropensci.org/visdat/reference/data-vis-dat.html'>data_vis_dat</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 765 × 5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   Month [5]</span></span></span>
<span><span class='c'>#&gt;    Month  rows variable valueType value</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     5     1 Day      integer   41   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     5     1 Ozone    integer   190  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     5     1 Solar.R  integer   7.4  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     5     1 Temp     integer   67   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5     1 Wind     numeric   1    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     5     2 Day      integer   36   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     5     2 Ozone    integer   118  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     5     2 Solar.R  integer   8    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     5     2 Temp     integer   72   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     5     2 Wind     numeric   2    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 755 more rows</span></span></span>
<span></span></code></pre>

</div>

## Missing values show up in list columns

[`vis_dat()`](https://docs.ropensci.org/visdat/reference/vis_dat.html) [`vis_miss()`](https://docs.ropensci.org/visdat/reference/vis_miss.html) and [`vis_guess()`](https://docs.ropensci.org/visdat/reference/vis_guess.html) now render missing values in list-columns. Let's demonstrate this with the `star_wars` dataset from `dplyr`, which has a few list columns.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>starwars</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 87 × 14</span></span></span>
<span><span class='c'>#&gt;    name        height  mass hair_…¹ skin_…² eye_c…³ birth…⁴ sex   gender homew…⁵</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>        <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Luke Skywa…    172    77 blond   fair    blue       19   male  mascu… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> C-3PO          167    75 <span style='color: #BB0000;'>NA</span>      gold    yellow    112   none  mascu… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> R2-D2           96    32 <span style='color: #BB0000;'>NA</span>      white,… red        33   none  mascu… Naboo  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Darth Vader    202   136 none    white   yellow     41.9 male  mascu… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Leia Organa    150    49 brown   light   brown      19   fema… femin… Aldera…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Owen Lars      178   120 brown,… light   blue       52   male  mascu… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Beru White…    165    75 brown   light   blue       47   fema… femin… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> R5-D4           97    32 <span style='color: #BB0000;'>NA</span>      white,… red        <span style='color: #BB0000;'>NA</span>   none  mascu… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Biggs Dark…    183    84 black   light   brown      24   male  mascu… Tatooi…</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Obi-Wan Ke…    182    77 auburn… fair    blue-g…    57   male  mascu… Stewjon</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 77 more rows, 4 more variables: species &lt;chr&gt;, films &lt;list&gt;,</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   vehicles &lt;list&gt;, starships &lt;list&gt;, and abbreviated variable names</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>#   ¹​hair_color, ²​skin_color, ³​eye_color, ⁴​birth_year, ⁵​homeworld</span></span></span>
<span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://pillar.r-lib.org/reference/glimpse.html'>glimpse</a></span><span class='o'>(</span><span class='nv'>starwars</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; Rows: 87</span></span>
<span><span class='c'>#&gt; Columns: 14</span></span>
<span><span class='c'>#&gt; $ name       <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Luke Skywalker", "C-3PO", "R2-D2", "Darth Vader", "Leia Or…</span></span>
<span><span class='c'>#&gt; $ height     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> 172, 167, 96, 202, 150, 178, 165, 97, 183, 182, 188, 180, 2…</span></span>
<span><span class='c'>#&gt; $ mass       <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 77.0, 75.0, 32.0, 136.0, 49.0, 120.0, 75.0, 32.0, 84.0, 77.…</span></span>
<span><span class='c'>#&gt; $ hair_color <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "blond", NA, NA, "none", "brown", "brown, grey", "brown", N…</span></span>
<span><span class='c'>#&gt; $ skin_color <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "fair", "gold", "white, blue", "white", "light", "light", "…</span></span>
<span><span class='c'>#&gt; $ eye_color  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "blue", "yellow", "red", "yellow", "brown", "blue", "blue",…</span></span>
<span><span class='c'>#&gt; $ birth_year <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> 19.0, 112.0, 33.0, 41.9, 19.0, 52.0, 47.0, NA, 24.0, 57.0, …</span></span>
<span><span class='c'>#&gt; $ sex        <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "male", "none", "none", "male", "female", "male", "female",…</span></span>
<span><span class='c'>#&gt; $ gender     <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "masculine", "masculine", "masculine", "masculine", "femini…</span></span>
<span><span class='c'>#&gt; $ homeworld  <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Tatooine", "Tatooine", "Naboo", "Tatooine", "Alderaan", "T…</span></span>
<span><span class='c'>#&gt; $ species    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span> "Human", "Droid", "Droid", "Human", "Human", "Human", "Huma…</span></span>
<span><span class='c'>#&gt; $ films      <span style='color: #555555; font-style: italic;'>&lt;list&gt;</span> &lt;"The Empire Strikes Back", "Revenge of the Sith", "Return…</span></span>
<span><span class='c'>#&gt; $ vehicles   <span style='color: #555555; font-style: italic;'>&lt;list&gt;</span> &lt;"Snowspeeder", "Imperial Speeder Bike"&gt;, &lt;&gt;, &lt;&gt;, &lt;&gt;, "Imp…</span></span>
<span><span class='c'>#&gt; $ starships  <span style='color: #555555; font-style: italic;'>&lt;list&gt;</span> &lt;"X-wing", "Imperial shuttle"&gt;, &lt;&gt;, &lt;&gt;, "TIE Advanced x1",…</span></span>
<span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_dat.html'>vis_dat</a></span><span class='o'>(</span><span class='nv'>starwars</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/show-vis-lists-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>starwars</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/show-vis-lists-2.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_guess.html'>vis_guess</a></span><span class='o'>(</span><span class='nv'>starwars</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/show-vis-lists-3.png" width="700px" style="display: block; margin: auto;" />

</div>

As you can see, lists are now displayed in the visualisation. Unfortunately `vis_guess` has trouble guessing lists, but that is a limitation due to how it guesses variable types.

Thank you to github user [cregouby](https://github.com/cregouby) for adding this in [#138](https://github.com/ropensci/visdat/pull/138).

## Abbreviation helpers

Long variable names can be annoying and can crowd a plot. The [`abbreviate_vars()`](https://docs.ropensci.org/visdat/reference/abbreviate_vars.html) function can be used to help with this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>long_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tibble.tidyverse.org/reference/tibble.html'>tibble</a></span><span class='o'>(</span></span>
<span>  really_really_long_name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>NA</span>, <span class='kc'>NA</span>, <span class='m'>1</span><span class='o'>:</span><span class='m'>8</span><span class='o'>)</span>,</span>
<span>  very_quite_long_name <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>1</span><span class='o'>:</span><span class='o'>-</span><span class='m'>8</span>, <span class='kc'>NA</span>, <span class='kc'>NA</span><span class='o'>)</span>,</span>
<span>  this_long_name_is_something_else <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>NA</span>, <span class='kc'>NA</span>,</span>
<span>                                       <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span>from <span class='o'>=</span> <span class='m'>0</span>, to <span class='o'>=</span> <span class='m'>1</span>, length.out <span class='o'>=</span> <span class='m'>8</span><span class='o'>)</span><span class='o'>)</span></span>
<span><span class='o'>)</span></span>
<span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>long_data</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/long-data-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Ugh no good.

Use [`abbreviate_vars()`](https://docs.ropensci.org/visdat/reference/abbreviate_vars.html) to help:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>long_data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://docs.ropensci.org/visdat/reference/abbreviate_vars.html'>abbreviate_vars</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/show-abbreviate-vars-1.png" width="700px" style="display: block; margin: auto;" />

</div>

You can control the length of the abbreviation with `min_length`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>long_data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://docs.ropensci.org/visdat/reference/abbreviate_vars.html'>abbreviate_vars</a></span><span class='o'>(</span>min_length <span class='o'>=</span> <span class='m'>5</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/show-abbreviation-length-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Under the hood this uses the base R function, [`abbreviate()`](https://rdrr.io/r/base/abbreviate.html) - a gem of a function.

Thank you to [chapau3](https://github.com/chapau3), and [ivanhanigan](https://github.com/ivanhanigan) for requesting this feature ([#140](https://github.com/ropensci/visdat/issues/140) and [#9](https://github.com/ropensci/visdat/issues/9)).

## Missingness percentages are now integers.

The [`vis_miss()`](https://docs.ropensci.org/visdat/reference/vis_miss.html) function shows a percentage missing of the missing values in each column - I've decided to make this round to integers, as it is only a guide and I found them to be a bit cluttered. I also do not like the idea of extracting summary statistics from graphics, so they now look like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://docs.ropensci.org/visdat/reference/vis_miss.html'>vis_miss</a></span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
</code></pre>
<img src="figs/show-vis-miss-again-1.png" width="700px" style="display: block; margin: auto;" />

</div>

For more accurate representation of missingness summaries please use the [`naniar` R package](http://naniar.njtierney.com/) functions like [`miss_var_summary()`](https://rdrr.io/pkg/naniar/man/miss_var_summary.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/njtierney/naniar'>naniar</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/naniar/man/miss_var_summary.html'>miss_var_summary</a></span><span class='o'>(</span><span class='nv'>airquality</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 3</span></span></span>
<span><span class='c'>#&gt;   variable n_miss pct_miss</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Ozone        37    24.2 </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Solar.R       7     4.58</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Wind          0     0   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Temp          0     0   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Month         0     0   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Day           0     0</span></span>
<span></span></code></pre>

</div>

Which also works with [`dplyr::group_by()`](https://dplyr.tidyverse.org/reference/group_by.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>airquality</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>Month</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://rdrr.io/pkg/naniar/man/miss_var_summary.html'>miss_var_summary</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 25 × 4</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   Month [5]</span></span></span>
<span><span class='c'>#&gt;    Month variable n_miss pct_miss</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span>     5 Ozone         5     16.1</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span>     5 Solar.R       4     12.9</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span>     5 Wind          0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span>     5 Temp          0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span>     5 Day           0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span>     6 Ozone        21     70  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span>     6 Solar.R       0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span>     6 Wind          0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span>     6 Temp          0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span>     6 Day           0      0  </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 15 more rows</span></span></span>
<span></span></code></pre>

</div>

If you find that this really bothers you and you want to have control over the percentage missingness in the columns, please file an issue on visdat and I will look into adding more user control. Ideally I would have added control for users in the first place, but it just wasn't something I was certain users wanted, and would require more arguments to a function, which require more tests...and so on. So with the mindset of keeping this package easy to maintain, I figured this might be the easiest way forward.

## Bug Fixes and Other changes

Here is a quick listing of the other changes in this release of visdat:

-   No longer use `gather` internally: [#141](https://github.com/ropensci/visdat/issues/141)
-   Resolve bug where [`vis_value()`](https://docs.ropensci.org/visdat/reference/vis_value.html) displayed constant values as NA values [128](https://github.com/ropensci/visdat/issues/128) - these constant values are now shown as 1.
-   Removed use of the now deprecated "aes_string" from ggplot2
-   Output of plot in `vis_expect` would reorder columns ([#133](https://github.com/ropensci/visdat/issues/133)), fixed in [#143](https://github.com/ropensci/visdat/pull/134) by [muschellij2](https://github.com/muschellij2).
-   A new vignette on customising colour palettes in visdat, "Customising colour palettes in visdat".
-   No longer uses gdtools for testing [#145](https://github.com/ropensci/visdat/issues/145)
-   Use `cli` internally for error messages.
-   Speed up some internal functions

# Thanks

Thank you to all the users who contributed to this release!

[muschellij2](https://github.com/muschellij2), [chapau3](https://github.com/chapau3), [ivanhanigan](https://github.com/ivanhanigan), [cregouby](https://github.com/cregouby), [jzadra](https://github.com/jzadra).

