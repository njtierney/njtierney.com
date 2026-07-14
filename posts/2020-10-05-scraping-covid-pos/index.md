---
title: Fancy Times and Scales with COVID data
date: '2020-10-11'
slug: times-scales-covid
categories:
  - rstats
  - scales
  - time series
  - covid19
  - data visualisation
aliases:
  - /post/2020/10/11/times-scales-covid/
---

Ah, COVID19. Yet another COVID19 blog post? Kinda? Not really? This blog post covers how to:

-   Scrape nicely formatted tables from a website with [`polite`](https://dmi3kno.github.io/polite/), [`rvest`](https://rvest.tidyverse.org/) and the [`tidyverse`](https://tidyverse.org/)
-   Format dates with `strptime`
-   Filter out dates using [`tsibble`](https://tsibble.tidyverts.org/)
-   Use nicely formatted percentages in [`ggplot2`](https://ggplot2.tidyverse.org/) with [`scales`](https://scales.r-lib.org/).

We're in lockdown here in Melbourne and I find myself looking at all the case numbers every day. A number that I've been paying attention to helps is the positive test rate - the number of positive tests divided by the number of total tests.

There's a great website, [covidlive.com.au](https://covidlive.com.au/), posted on [covidliveau](https://twitter.com/covidliveau), maintained by [Anthony Macali](https://twitter.com/migga)

We're going to look at the [daily positive test rates for Victoria](https://covidlive.com.au/report/daily-positive-test-rate/vic), first let's load up the three packages we'll need, the `tidyverse` for general data manipulation and plotting and friends, `rvest` for web scraping, and `polite` for ethically managing the webscraping.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ───────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.2</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>

<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://rvest.tidyverse.org/'>rvest</a></span>)

<span class='c'>#&gt; Loading required package: xml2</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'rvest'</span>

<span class='c'>#&gt; The following object is masked from 'package:purrr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     pluck</span>

<span class='c'>#&gt; The following object is masked from 'package:readr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     guess_encoding</span>

<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/dmi3kno/polite'>polite</a></span>)
<span class='k'>conflicted</span>::<span class='nf'><a href='https://rdrr.io/pkg/conflicted/man/conflict_prefer.html'>conflict_prefer</a></span>(<span class='s'>"pluck"</span>, <span class='s'>"purrr"</span>)

<span class='c'>#&gt; [conflicted] Will prefer <span style='color: #0000BB;'>purrr::pluck</span><span> over any other package</span></span>

<span class='k'>conflicted</span>::<span class='nf'><a href='https://rdrr.io/pkg/conflicted/man/conflict_prefer.html'>conflict_prefer</a></span>(<span class='s'>"filter"</span>, <span class='s'>"dplyr"</span>)

<span class='c'>#&gt; [conflicted] Will prefer <span style='color: #0000BB;'>dplyr::filter</span><span> over any other package</span></span>
</code></pre>

</div>

(Note that I'm saying to prefer `pluck` from `purrr`, since there is a namespace conflict).

First we define the web address into `vic_test_url` and use `polite`'s `bow` function to check we are allowed to scrape the data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_test_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://covidlive.com.au/report/daily-positive-test-rate/vic"</span>

<span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span>(<span class='k'>vic_test_url</span>) 

<span class='c'>#&gt; &lt;polite session&gt; https://covidlive.com.au/report/daily-positive-test-rate/vic</span>
<span class='c'>#&gt;     User-agent: polite R package - https://github.com/dmi3kno/polite</span>
<span class='c'>#&gt;     robots.txt: 2 rules are defined for 2 bots</span>
<span class='c'>#&gt;    Crawl delay: 5 sec</span>
<span class='c'>#&gt;   The path is scrapable for this user-agent</span>
</code></pre>

</div>

OK, looks like we're all set to go, let's `scrape` the data. This is another function from `polite` that follows the rule set from `bow` - making sure here to obey the crawl delay, and only to scrape if `bow` allows it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span>(<span class='k'>vic_test_url</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span>() 

<span class='c'>#&gt; {html_document}</span>
<span class='c'>#&gt; &lt;html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en"&gt;</span>
<span class='c'>#&gt; [1] &lt;head&gt;\n&lt;!-- Title --&gt;&lt;title&gt;Daily Positive Test Rate in Victoria - COVID ...</span>
<span class='c'>#&gt; [2] &lt;body id="page-report"&gt;\n&lt;div class="wrapper"&gt;\n\n  &lt;!-- Header --&gt;       ...</span>
</code></pre>

</div>

A shout out to [Dmytro Perepolkin](https://github.com/dmi3kno), the creator of `polite`, such a lovely package.

This gives us this HTML document. Looking at the website, I'm fairly sure it is a nice HTML table, and we can confirm this using developer tools in Chrome (or your browser of choice)

<div class="highlight">

<img src="figs/covid-live-site.png" width="700px" style="display: block; margin: auto;" />

</div>

There are many ways to extract the right part of the site, but I like to just try getting the HTML table out using [`html_table()`](https://rvest.tidyverse.org/reference/html_table.html). We're going to look at the output using [`str()`](https://rdrr.io/r/utils/str.html), which provides a summary of the **str**ucture of the data to save ourselves printing all the HTML tables

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span>(<span class='k'>vic_test_url</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span>() <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_table.html'>html_table</a></span>() <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/utils/str.html'>str</a></span>()

<span class='c'>#&gt; List of 2</span>
<span class='c'>#&gt;  $ :'data.frame':  2 obs. of  5 variables:</span>
<span class='c'>#&gt;   ..$ X1: chr [1:2] "COVID LIVE" "Last updated 5 hours ago"</span>
<span class='c'>#&gt;   ..$ X2: chr [1:2] "20,281" "Cases"</span>
<span class='c'>#&gt;   ..$ X3: chr [1:2] "9.7" "14 Day Av"</span>
<span class='c'>#&gt;   ..$ X4: chr [1:2] "2.84M" "Tests"</span>
<span class='c'>#&gt;   ..$ X5: chr [1:2] "810" "Deaths"</span>
<span class='c'>#&gt;  $ :'data.frame':  203 obs. of  4 variables:</span>
<span class='c'>#&gt;   ..$ DATE : chr [1:203] "11 Oct" "10 Oct" "09 Oct" "08 Oct" ...</span>
<span class='c'>#&gt;   ..$ CASES: int [1:203] 12 12 10 10 4 13 11 12 6 8 ...</span>
<span class='c'>#&gt;   ..$ TESTS: chr [1:203] "12,925" "16,647" "15,585" "15,298" ...</span>
<span class='c'>#&gt;   ..$ POS  : chr [1:203] "0.09 %" "0.07 %" "0.06 %" "0.07 %" ...</span>
</code></pre>

</div>

This tells us we want the second list element, which is the data frame, and then make that a `tibble` for nice printing:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span>(<span class='k'>vic_test_url</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span>() <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_table.html'>html_table</a></span>() <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/pluck.html'>pluck</a></span>(<span class='m'>2</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span>()

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 203 x 4</span></span>
<span class='c'>#&gt;    DATE   CASES TESTS  POS   </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 11 Oct    12 12,925 0.09 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 10 Oct    12 16,647 0.07 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 09 Oct    10 15,585 0.06 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 08 Oct    10 15,298 0.07 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 07 Oct     4 16,429 0.02 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 06 Oct    13 9,286  0.14 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 05 Oct    11 9,023  0.12 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 04 Oct    12 11,994 0.10 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 03 Oct     6 11,281 0.05 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 02 Oct     8 12,550 0.06 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 193 more rows</span></span>
</code></pre>

</div>

All together now:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_test_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://covidlive.com.au/report/daily-positive-test-rate/vic"</span>

<span class='k'>vic_test_data_raw</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span>(<span class='k'>vic_test_url</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span>() <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_table.html'>html_table</a></span>() <span class='o'>%&gt;%</span> 
  <span class='k'>purrr</span>::<span class='nf'><a href='https://purrr.tidyverse.org/reference/pluck.html'>pluck</a></span>(<span class='m'>2</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span>()

<span class='k'>vic_test_data_raw</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 203 x 4</span></span>
<span class='c'>#&gt;    DATE   CASES TESTS  POS   </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 11 Oct    12 12,925 0.09 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 10 Oct    12 16,647 0.07 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 09 Oct    10 15,585 0.06 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 08 Oct    10 15,298 0.07 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 07 Oct     4 16,429 0.02 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 06 Oct    13 9,286  0.14 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 05 Oct    11 9,023  0.12 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 04 Oct    12 11,994 0.10 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 03 Oct     6 11,281 0.05 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 02 Oct     8 12,550 0.06 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 193 more rows</span></span>
</code></pre>

</div>

OK awesome, now let's format the dates. We've got them in the format of the Day of the month in decimal form and then the 3 letter month abbreviation. We can convert this into a nice date object using `strptime`. This is a function I always forget how to use, so I end up browsing the help file every time and playing with a toy example until I get what I want. There are probably better ways, but this seems to work for me.

What this says is:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span>(<span class='s'>"05 Oct"</span>, format = <span class='s'>"%d %b"</span>) 

<span class='c'>#&gt; [1] "2020-10-05 AEDT"</span>
</code></pre>

</div>

-   Take the string, "05 Oct"
-   The format that this follows is
    -   Day of the month as decimal number (01--31) (represented as "%d")
    -   followed by a space, then
    -   Abbreviated month name in the current locale on this platform. (Also matches full name on input: in some locales there are no abbreviations of names.) (represented as "%d").

For this to work, we need the string in the `format` argument to match EXACTLY the input. For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span>(<span class='s'>"05-Oct"</span>, format = <span class='s'>"%d %b"</span>) 

<span class='c'>#&gt; [1] NA</span>
</code></pre>

</div>

Doesn't work (because the dash)

But this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span>(<span class='s'>"05-Oct"</span>, format = <span class='s'>"%d-%b"</span>) 

<span class='c'>#&gt; [1] "2020-10-05 AEDT"</span>
</code></pre>

</div>

Does work, because the dash is in the `format` srtring.

OK and we want that as a `Date` object:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span>(<span class='s'>"05 Oct"</span>, format = <span class='s'>"%d %b"</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span>()

<span class='c'>#&gt; [1] "2020-10-05"</span>
</code></pre>

</div>

Let's wrap this in a little function we can use on our data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>strp_date</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>x</span>) <span class='nf'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span>(<span class='k'>x</span>, format = <span class='s'>"%d %b"</span>))
</code></pre>

</div>

And double check it works:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>strp_date</span>(<span class='s'>"05 Oct"</span>)

<span class='c'>#&gt; [1] "2020-10-05"</span>

<span class='nf'>strp_date</span>(<span class='s'>"05 Oct"</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/class.html'>class</a></span>()

<span class='c'>#&gt; [1] "Date"</span>
</code></pre>

</div>

Ugh, dates.

OK, so now let's clean up the dates.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_test_data_raw</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(DATE = <span class='nf'>strp_date</span>(<span class='k'>DATE</span>))

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 203 x 4</span></span>
<span class='c'>#&gt;    DATE       CASES TESTS  POS   </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2020-10-11    12 12,925 0.09 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2020-10-10    12 16,647 0.07 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2020-10-09    10 15,585 0.06 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2020-10-08    10 15,298 0.07 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2020-10-07     4 16,429 0.02 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2020-10-06    13 9,286  0.14 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2020-10-05    11 9,023  0.12 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2020-10-04    12 11,994 0.10 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2020-10-03     6 11,281 0.05 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2020-10-02     8 12,550 0.06 %</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 193 more rows</span></span>
</code></pre>

</div>

And let's use `parse_number` to convert `TESTS` and `POS` into numbers, as they have commas in them and % signs, so R registers them as character strings.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_test_data_raw</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(DATE = <span class='nf'>strp_date</span>(<span class='k'>DATE</span>),
         TESTS = <span class='nf'>parse_number</span>(<span class='k'>TESTS</span>),
         POS = <span class='nf'>parse_number</span>(<span class='k'>POS</span>))

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 203 x 4</span></span>
<span class='c'>#&gt;    DATE       CASES TESTS   POS</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2020-10-11    12 </span><span style='text-decoration: underline;'>12</span><span>925  0.09</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2020-10-10    12 </span><span style='text-decoration: underline;'>16</span><span>647  0.07</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2020-10-09    10 </span><span style='text-decoration: underline;'>15</span><span>585  0.06</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2020-10-08    10 </span><span style='text-decoration: underline;'>15</span><span>298  0.07</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2020-10-07     4 </span><span style='text-decoration: underline;'>16</span><span>429  0.02</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2020-10-06    13  </span><span style='text-decoration: underline;'>9</span><span>286  0.14</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2020-10-05    11  </span><span style='text-decoration: underline;'>9</span><span>023  0.12</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2020-10-04    12 </span><span style='text-decoration: underline;'>11</span><span>994  0.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2020-10-03     6 </span><span style='text-decoration: underline;'>11</span><span>281  0.05</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2020-10-02     8 </span><span style='text-decoration: underline;'>12</span><span>550  0.06</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 193 more rows</span></span>
</code></pre>

</div>

`parse_number()` (from [`readr`](https://readr.tidyverse.org/)) is one of my favourite little functions, as this saves me a ton of effort.

Now let's use `clean_names()` function from `janitor` to make the names all lower case, making them a bit nicer to deal with. (I don't like holding down shift to type all caps for long periods of time, unless I've got something exciting to celebrate or scream).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_test_data_raw</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(DATE = <span class='nf'>strp_date</span>(<span class='k'>DATE</span>),
         TESTS = <span class='nf'>parse_number</span>(<span class='k'>TESTS</span>),
         POS = <span class='nf'>parse_number</span>(<span class='k'>POS</span>)) <span class='o'>%&gt;%</span> 
  <span class='k'>janitor</span>::<span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span>() 

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 203 x 4</span></span>
<span class='c'>#&gt;    date       cases tests   pos</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2020-10-11    12 </span><span style='text-decoration: underline;'>12</span><span>925  0.09</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2020-10-10    12 </span><span style='text-decoration: underline;'>16</span><span>647  0.07</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2020-10-09    10 </span><span style='text-decoration: underline;'>15</span><span>585  0.06</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2020-10-08    10 </span><span style='text-decoration: underline;'>15</span><span>298  0.07</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2020-10-07     4 </span><span style='text-decoration: underline;'>16</span><span>429  0.02</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2020-10-06    13  </span><span style='text-decoration: underline;'>9</span><span>286  0.14</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2020-10-05    11  </span><span style='text-decoration: underline;'>9</span><span>023  0.12</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2020-10-04    12 </span><span style='text-decoration: underline;'>11</span><span>994  0.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2020-10-03     6 </span><span style='text-decoration: underline;'>11</span><span>281  0.05</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2020-10-02     8 </span><span style='text-decoration: underline;'>12</span><span>550  0.06</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 193 more rows</span></span>
</code></pre>

</div>

And then finally all together now, I'm going to turn this into a [`tsibble`](https://tsibble.tidyverts.org/) - a time series `tibble`, using `as_tsibble`, and specifying the `index` (the time part) as the `date` column. I use this because later on we'll be manipulating the date column, and `tsibble` makes this much easier.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://tsibble.tidyverts.org'>tsibble</a></span>)
<span class='k'>vic_tests</span> <span class='o'>&lt;-</span> <span class='k'>vic_test_data_raw</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span>(DATE = <span class='nf'>strp_date</span>(<span class='k'>DATE</span>),
         TESTS = <span class='nf'>parse_number</span>(<span class='k'>TESTS</span>),
         POS = <span class='nf'>parse_number</span>(<span class='k'>POS</span>)) <span class='o'>%&gt;%</span> 
  <span class='k'>janitor</span>::<span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span>() <span class='o'>%&gt;%</span> 
  <span class='nf'>rename</span>(pos_pct = <span class='k'>pos</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tsibble.tidyverts.org/reference/as-tsibble.html'>as_tsibble</a></span>(index = <span class='k'>date</span>)
</code></pre>

</div>

OK, now to iterate on a few plots.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>vic_tests</span>,
         <span class='nf'>aes</span>(x = <span class='k'>date</span>,
             y = <span class='k'>pos_pct</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() 

</code></pre>
<img src="figs/vic-tests-m1-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Oof, OK, let's remove that negative date, not sure why that is there:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_tests_clean</span> <span class='o'>&lt;-</span> <span class='k'>vic_tests</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>pos_pct</span> <span class='o'>&gt;=</span> <span class='m'>0</span>)

<span class='nf'>ggplot</span>(<span class='k'>vic_tests_clean</span>,
         <span class='nf'>aes</span>(x = <span class='k'>date</span>,
             y = <span class='k'>pos_pct</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() 

</code></pre>
<img src="figs/filter-plot-1.png" width="700px" style="display: block; margin: auto;" />

</div>

OK, looks like in April we have some high numbers, let's bring filter out those dates from before May using `filter_index` - here we specify the start date, and the `.` means the last date:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vic_tests_clean</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tsibble.tidyverts.org/reference/filter_index.html'>filter_index</a></span>(<span class='s'>"2020-05-01"</span> <span class='o'>~</span> <span class='k'>.</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(x = <span class='k'>date</span>,
             y = <span class='k'>pos_pct</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() 

</code></pre>
<img src="figs/filter-index-1.png" width="700px" style="display: block; margin: auto;" />

</div>

OK, much nicer. Looks like things are on the downward-ish. But the I want to add "%" signs to the plot. We could glue/paste those onto the data values, but I prefer to use the [`scales`](https://scales.r-lib.org/) package for this part. We can browse the [`label_percent()`](https://scales.r-lib.org/reference/label_percent.html) reference page to see how to use it:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://scales.r-lib.org'>scales</a></span>)
<span class='k'>vic_tests_clean</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tsibble.tidyverts.org/reference/filter_index.html'>filter_index</a></span>(<span class='s'>"2020-05-01"</span> <span class='o'>~</span> <span class='k'>.</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(x = <span class='k'>date</span>,
             y = <span class='k'>pos_pct</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() <span class='o'>+</span>
  <span class='nf'>scale_y_continuous</span>(labels = <span class='nf'><a href='https://scales.r-lib.org//reference/label_percent.html'>label_percent</a></span>())

</code></pre>
<img src="figs/scales-label-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We specify how we want to change the y axis, using `scale_y_continuous`, and then say that the labels on the y axis need to have the `label_percent` function applied to them. Well, that's how I read it.

OK, but this isn't quite what we want actually, we need to change the scale - since by default it multiplies the number by 100. We also need to change the accuracy, since we want this to 2 decimal places. We can see this with the `percent` function, which is what `label_percent` uses under the hood.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://scales.r-lib.org//reference/label_percent.html'>percent</a></span>(<span class='m'>0.1</span>)

<span class='c'>#&gt; [1] "10%"</span>

<span class='nf'><a href='https://scales.r-lib.org//reference/label_percent.html'>percent</a></span>(<span class='m'>0.1</span>, scale = <span class='m'>1</span>)

<span class='c'>#&gt; [1] "0%"</span>

<span class='nf'><a href='https://scales.r-lib.org//reference/label_percent.html'>percent</a></span>(<span class='m'>0.1</span>, scale = <span class='m'>1</span>, accuracy = <span class='m'>0.01</span>)

<span class='c'>#&gt; [1] "0.10%"</span>
</code></pre>

</div>

So now we change the `accuracy` and `scale` arguments so we get the right looking marks.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://scales.r-lib.org'>scales</a></span>)
<span class='k'>vic_tests_clean</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://tsibble.tidyverts.org/reference/filter_index.html'>filter_index</a></span>(<span class='s'>"2020-05-01"</span> <span class='o'>~</span> <span class='k'>.</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(x = <span class='k'>date</span>,
             y = <span class='k'>pos_pct</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() <span class='o'>+</span>
  <span class='nf'>scale_y_continuous</span>(labels = <span class='nf'><a href='https://scales.r-lib.org//reference/label_percent.html'>label_percent</a></span>(accuracy = <span class='m'>0.01</span>, 
                                            scale = <span class='m'>1</span>))

</code></pre>
<img src="figs/scales-final-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And that's how to scrape some data, parse the dates, filter by time, and make the percentages print nice in a ggplot.

Thanks to [Dmytro Perepolkin](https://github.com/dmi3kno) for `polite`, [Earo Wang](https://earo.me/) for `tsibble`, [Sam Firke](http://samfirke.com/about/) for `janitor`, the awesome [`tidyverse`](https://www.tidyverse.org/) team for creating and maintaining the `tidyverse`, and of course the folks behind R, because R is great.

