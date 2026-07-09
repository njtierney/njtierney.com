---
title: Rolling Averages with {slider} and Covid Data
date: '2020-10-20'
slug: roll-avg-covid
categories:
  - rstats
  - covid19
  - data visualisation
  - ggplot2
  - time series
aliases:
  - /post/2020/10/20/roll-avg-covid/
---

Things are moving along in the COVID19 world in Melbourne, and the latest numbers we are discussing are the 14 day and 7 day averages. The aim is to get the 14 day average below 5 cases, but people are starting to report the current 7 day average, since this is also encouraging and interesting.

So let's explore how to do sliding averages. We'll [use the covid scraping code from a previous blog post on scraping covid data](https://www.njtierney.com/post/2020/10/11/times-scales-covid/) (I don't think I'll put this into yet another R package, but I'm tempted. But...anyway).

This code checks if we can scrape the data ([`bow()`](https://rdrr.io/pkg/polite/man/bow.html)), scrapes the data ([`scrape()`](https://rdrr.io/pkg/polite/man/scrape.html)), extracts the tables ([`html_table()`](https://rvest.tidyverse.org/reference/html_table.html)), picks (`pluck`) the second one, then converts it to a `tibble` for nice printing.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>covidlive_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://covidlive.com.au/report/daily-cases/vic"</span>

<span class='nv'>covidlive_raw</span> <span class='o'>&lt;-</span> <span class='nv'>covidlive_url</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_table.html'>html_table</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/pluck.html'>pluck</a></span><span class='o'>(</span><span class='m'>2</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tibble.tidyverse.org/reference/as_tibble.html'>as_tibble</a></span><span class='o'>(</span><span class='o'>)</span>
</code></pre>

</div>

Then we do a bit of data cleaning, parsing the dates and numbers properly, and just leaving us with a date and case column:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='nv'>strp_date</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span><span class='o'>(</span><span class='nv'>x</span>, format <span class='o'>=</span> <span class='s'>"%d %b"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>daily_cases</span> <span class='o'>&lt;-</span> <span class='nv'>covidlive_raw</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>DATE <span class='o'>=</span> <span class='nf'>strp_date</span><span class='o'>(</span><span class='nv'>DATE</span><span class='o'>)</span>,
         CASES <span class='o'>=</span> <span class='nf'>parse_number</span><span class='o'>(</span><span class='nv'>CASES</span><span class='o'>)</span>,
         NET <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/warning.html'>suppressWarnings</a></span><span class='o'>(</span><span class='nf'>parse_number</span><span class='o'>(</span><span class='nv'>NET</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>select</span><span class='o'>(</span><span class='o'>-</span><span class='nv'>var</span>,
         <span class='o'>-</span><span class='nv'>cases</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>rename</span><span class='o'>(</span>cases <span class='o'>=</span> <span class='nv'>net</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>select</span><span class='o'>(</span><span class='nv'>date</span>, <span class='nv'>cases</span><span class='o'>)</span>

<span class='nv'>daily_cases</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 272 x 2</span></span>
<span class='c'>#&gt;    date       cases</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2020-10-22    </span><span style='color: #BB0000;'>NA</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2020-10-21     3</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2020-10-20     1</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2020-10-19     4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2020-10-18    -</span><span style='color: #BB0000;'>2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2020-10-17     0</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2020-10-16     2</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2020-10-15     4</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2020-10-14     6</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2020-10-13    10</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 262 more rows</span></span>
</code></pre>

</div>

We can then convert this into a [`tsibble`](https://github.com/tidyverts/tsibble), to make it easier to work with dates.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>daily_ts</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://tsibble.tidyverts.org/reference/as-tsibble.html'>as_tsibble</a></span><span class='o'>(</span><span class='nv'>daily_cases</span>,
                       index <span class='o'>=</span> <span class='nv'>date</span><span class='o'>)</span>
</code></pre>

</div>

Sliding windows?
----------------

No we want to plot a 7 and 14 day average of cases. Thinking about how I would do this, I probably would have identified the "week" of a year, and then grouped by that and calculated the average, and maybe through some `reduce`/`aggregate` functional programming magic.

But there is now a more straightforward way, using using the [{`slider`}](https://davisvaughan.github.io/slider/) R package by [Davis Vaughn](https://github.com/DavisVaughan). This package allows for performing calculations on a specified window size. The idea is very powerful, and was in part [inspired by](https://github.com/DavisVaughan/slider#inspiration) the `slide` family of functions in `tsibble`.

[Earo Wang](https://earo.me/) has given some really nice explanations of what sliding is, in particular I like her [JSM19 talk](https://slides.earo.me/jsm19/#23) and [rstudioconf::2019 talk](https://slides.earo.me/rstudioconf19/#15) - a visual representation is in this gif (lifted from Earo's talk):

<div class="highlight">

<img src="https://tsibble.tidyverts.org/reference/figures/animate-1.gif" width="700px" style="display: block; margin: auto;" />

</div>

slider provides a more general interface, and draws upon the framework in `purrr` and `vctrs` R packages.

Let's show an example by taking the last 14 days of covid cases

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>vec_cases</span> <span class='o'>&lt;-</span> <span class='nv'>daily_ts</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>tail</a></span><span class='o'>(</span><span class='m'>15</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>pull</span><span class='o'>(</span><span class='nv'>cases</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/na.fail.html'>na.omit</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/base/numeric.html'>as.numeric</a></span><span class='o'>(</span><span class='o'>)</span>
  
<span class='nv'>vec_cases</span>

<span class='c'>#&gt;  [1] 10 10 12 12 14 10  6  4  2  0 -2  4  1  3</span>
</code></pre>

</div>

We can use `slide` to calculate the mean of the last 7 days. We can demonstrate how this work by first just printing the data, and using the `.before = 6`, to print the previous 6 values, plus the current one:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tsibble.tidyverts.org/reference/slide.html'>slide</a></span><span class='o'>(</span>.x <span class='o'>=</span> <span class='nv'>vec_cases</span>, 
      .f <span class='o'>=</span> <span class='o'>~</span><span class='nv'>.x</span>,
      .before <span class='o'>=</span> <span class='m'>6</span><span class='o'>)</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 10 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 10 10 12</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1] 10 10 12 12</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[5]]</span>
<span class='c'>#&gt; [1] 10 10 12 12 14</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[6]]</span>
<span class='c'>#&gt; [1] 10 10 12 12 14 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[7]]</span>
<span class='c'>#&gt; [1] 10 10 12 12 14 10  6</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[8]]</span>
<span class='c'>#&gt; [1] 10 12 12 14 10  6  4</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[9]]</span>
<span class='c'>#&gt; [1] 12 12 14 10  6  4  2</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[10]]</span>
<span class='c'>#&gt; [1] 12 14 10  6  4  2  0</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[11]]</span>
<span class='c'>#&gt; [1] 14 10  6  4  2  0 -2</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[12]]</span>
<span class='c'>#&gt; [1] 10  6  4  2  0 -2  4</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[13]]</span>
<span class='c'>#&gt; [1]  6  4  2  0 -2  4  1</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[14]]</span>
<span class='c'>#&gt; [1]  4  2  0 -2  4  1  3</span>
</code></pre>

</div>

This shows us 14 lists, the first 6 containing 1-6 of the numbers, then 7 from thereout.

We can instead run a function, like `mean` to calculate the mean on this output.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tsibble.tidyverts.org/reference/slide.html'>slide</a></span><span class='o'>(</span>.x <span class='o'>=</span> <span class='nv'>vec_cases</span>,
      .f <span class='o'>=</span> <span class='nv'>mean</span>,
      .before <span class='o'>=</span> <span class='m'>7</span><span class='o'>)</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt; [1] 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt; [1] 10</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt; [1] 10.66667</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[4]]</span>
<span class='c'>#&gt; [1] 11</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[5]]</span>
<span class='c'>#&gt; [1] 11.6</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[6]]</span>
<span class='c'>#&gt; [1] 11.33333</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[7]]</span>
<span class='c'>#&gt; [1] 10.57143</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[8]]</span>
<span class='c'>#&gt; [1] 9.75</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[9]]</span>
<span class='c'>#&gt; [1] 8.75</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[10]]</span>
<span class='c'>#&gt; [1] 7.5</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[11]]</span>
<span class='c'>#&gt; [1] 5.75</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[12]]</span>
<span class='c'>#&gt; [1] 4.75</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[13]]</span>
<span class='c'>#&gt; [1] 3.125</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[14]]</span>
<span class='c'>#&gt; [1] 2.25</span>
</code></pre>

</div>

We can even use the `slide_dbl` function to return these as all numeric (the type stability feature borrowed from purrr):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://tsibble.tidyverts.org/reference/slide.html'>slide_dbl</a></span><span class='o'>(</span>.x <span class='o'>=</span> <span class='nv'>vec_cases</span>,
          .f <span class='o'>=</span> <span class='nv'>mean</span>,
          .before <span class='o'>=</span> <span class='m'>7</span><span class='o'>)</span>

<span class='c'>#&gt;  [1] 10.00000 10.00000 10.66667 11.00000 11.60000 11.33333 10.57143  9.75000</span>
<span class='c'>#&gt;  [9]  8.75000  7.50000  5.75000  4.75000  3.12500  2.25000</span>
</code></pre>

</div>

Now let's use this inside our data, first we filter the data down to from the start of october with [`filter_index("2020-10-01" ~ .)`](https://tsibble.tidyverts.org/reference/filter_index.html), then, we calculate the average, using `slide_index_dbl`, where we specify the time index used in the data with `i`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>covid_rolls</span> <span class='o'>&lt;-</span> <span class='nv'>daily_ts</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tsibble.tidyverts.org/reference/filter_index.html'>filter_index</a></span><span class='o'>(</span><span class='s'>"2020-10-01"</span> <span class='o'>~</span> <span class='nv'>.</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>`7 day avg` <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/pkg/slider/man/slide_index.html'>slide_index_dbl</a></span><span class='o'>(</span>.i <span class='o'>=</span> <span class='nv'>date</span>,
                                .x <span class='o'>=</span> <span class='nv'>cases</span>,
                                .f <span class='o'>=</span> <span class='nv'>mean</span>,
                                .before <span class='o'>=</span> <span class='m'>6</span><span class='o'>)</span>,
         `14 day avg` <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/pkg/slider/man/slide_index.html'>slide_index_dbl</a></span><span class='o'>(</span>.i <span class='o'>=</span> <span class='nv'>date</span>,
                                   .x <span class='o'>=</span> <span class='nv'>cases</span>,
                                   .f <span class='o'>=</span> <span class='nv'>mean</span>,
                                   .before <span class='o'>=</span> <span class='m'>13</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>covid_rolls</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tsibble: 22 x 4 [1D]</span></span>
<span class='c'>#&gt;    date       cases `7 day avg` `14 day avg`</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2020-10-01    14       14           14   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2020-10-02     8       11           11   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2020-10-03     6        9.33         9.33</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2020-10-04    12       10           10   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2020-10-05    11       10.2         10.2 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2020-10-06    13       10.7         10.7 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2020-10-07     4        9.71         9.71</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2020-10-08    10        9.14         9.75</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2020-10-09    10        9.43         9.78</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2020-10-10    12       10.3         10   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 12 more rows</span></span>
</code></pre>

</div>

We convert this into long form for easier plotting

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>covid_rolls_long</span> <span class='o'>&lt;-</span> <span class='nv'>covid_rolls</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>pivot_longer</span><span class='o'>(</span>cols <span class='o'>=</span> <span class='m'>3</span><span class='o'>:</span><span class='m'>4</span>,
               names_to <span class='o'>=</span> <span class='s'>"roll_type"</span>,
               values_to <span class='o'>=</span> <span class='s'>"value"</span><span class='o'>)</span>
<span class='nv'>covid_rolls_long</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tsibble: 44 x 4 [1D]</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># Key:       roll_type [2]</span></span>
<span class='c'>#&gt;    date       cases roll_type  value</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2020-10-01    14 7 day avg  14   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2020-10-01    14 14 day avg 14   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2020-10-02     8 7 day avg  11   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2020-10-02     8 14 day avg 11   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2020-10-03     6 7 day avg   9.33</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2020-10-03     6 14 day avg  9.33</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2020-10-04    12 7 day avg  10   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2020-10-04    12 14 day avg 10   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2020-10-05    11 7 day avg  10.2 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2020-10-05    11 14 day avg 10.2 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 34 more rows</span></span>
</code></pre>

</div>

Now let's plot it!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>covid_rolls_long</span>,
       <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>date</span>,
           y <span class='o'>=</span> <span class='nv'>value</span>,
           colour <span class='o'>=</span> <span class='nv'>roll_type</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_hline</span><span class='o'>(</span>yintercept <span class='o'>=</span> <span class='m'>5</span>, linetype <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>lims</span><span class='o'>(</span>y <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>0</span>, <span class='m'>15</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/scale_colour_discrete_qualitative.html'>scale_colour_discrete_qualitative</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>x <span class='o'>=</span> <span class='s'>"Date"</span>,
       y <span class='o'>=</span> <span class='s'>"Rolling Average"</span>,
       colour <span class='o'>=</span> <span class='s'>"Average"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='c'># make the legend inset using code lifted from </span>
  <span class='c'># https://github.com/MilesMcBain/inlegend/blob/master/R/legends.R</span>
  <span class='nf'>theme</span><span class='o'>(</span>legend.justification <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1</span>, <span class='m'>1</span><span class='o'>)</span>,
        legend.position <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1.0</span>, <span class='m'>1</span><span class='o'>)</span>,
        legend.background <span class='o'>=</span> <span class='nf'>ggplot2</span><span class='nf'>::</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/element.html'>element_rect</a></span><span class='o'>(</span>
          colour <span class='o'>=</span> <span class='s'>"#d3d5d6"</span>,
          fill <span class='o'>=</span> <span class='s'>"#ffffff"</span>,
          size <span class='o'>=</span> <span class='m'>0.6</span>
        <span class='o'>)</span><span class='o'>)</span>

<span class='c'>#&gt; Warning: Removed 2 row(s) containing missing values (geom_path).</span>

</code></pre>
<img src="figs/plot-covid-rolls-long-1.png" width="700px" style="display: block; margin: auto;" />

</div>

End
===

The `slider` R package is really neat, and there is more to say about it! But I just thought I'd finish by saying that it is indeed possible to do the same "stretch" and "tile" manouevers as provided by `tsibble`, and I would highly recommend checking out the [slider website](https://davisvaughan.github.io/slider/) for more details on examples like rolling linear models and how to use it to [perform row wise iteration](https://davisvaughan.github.io/slider/articles/rowwise.html).

