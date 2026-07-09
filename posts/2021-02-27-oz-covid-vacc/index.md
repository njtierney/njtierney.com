---
title: What if Australia's vaccination rate is similar to our testing?
date: '2021-03-21'
slug: oz-covid-vacc
categories:
  - rstats
  - covid19
  - data visualisation
  - ggplot2
  - time series
aliases:
  - /post/2021/03/21/oz-covid-vacc/
---

The COVID19 vaccines (plural!) are rolling out around the world, and about 4 weeks ago in late Feb, [Australians got their first vaccine jab](https://www.abc.net.au/news/2021-02-21/australias-first-coronavirus-vaccine-recipient-jane-malysiak/13176274). It's a pretty massive relief that these vaccines (plural!!!) are rolling out so soon.

The ABC helps answer, ["When will you get the COVID-19 vaccine?"](https://www.abc.net.au/news/2021-02-05/when-will-you-get-the-covid-19-vaccine/13112610), which is super cool! The Australian government reckons we'll be vaccinated at a good percentage (80%?) by sometime later in the year - I forget exactly when they said, but let's say about October.

Now, I'm not sure how to imagine how this all takes place, but one thing I thought might be an interesting proxy is using the number of COVID19 tests that we can conduct in a day in Australia to proxy in for the number of vaccinations we can do.

Now, sure, getting a test isn't the same as getting a vaccine, but there are similar PPE controls in place, waiting in queue, and getting swabbed takes about as long as a jab, and I figured it might tell us something.

Fortunately the data is very accessible so it's a question that we can answer with R, some web scraping, some data wrangling, and some graphs.

So the question I'm focusing on in this blog post is:

> "Based on the COVID19 tests that Australia can perform each day, how long will it take to get to 80% of Australians vaccinated?".

To do this we'll recycle some of the code from my previous blog post on [exploring covid numbers in Australia](https://www.njtierney.com/post/2020/10/20/roll-avg-covid/) - I skim over some of the repeated parts of code in this post, but I do provide a full explanation at the previously linked blog post. The data is kindly sourced from [covidliveau](https://covidlive.com.au/).

First, we load up the packages we need:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ───────────────────────────── tidyverse 1.3.0 ──</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.1.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.5</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.3     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.4.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.1</span></span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/dmi3kno/polite'>polite</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://rvest.tidyverse.org/'>rvest</a></span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'rvest'</span>
<span class='c'>#&gt; The following object is masked from 'package:readr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     guess_encoding</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/rstudio/htmltools'>htmltools</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://scales.r-lib.org'>scales</a></span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'scales'</span>
<span class='c'>#&gt; The following object is masked from 'package:purrr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     discard</span>
<span class='c'>#&gt; The following object is masked from 'package:readr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     col_factor</span></code></pre>

</div>

-   `tidyverse` for data wrangling and plotting and magic
-   `polite`, `rvest`, `htmltools` for web scraping
-   `scales` for making nicer plot scales and stuff

We scrape the data for tests in Australia, and extract the table

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>aus_test_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://covidlive.com.au/report/daily-tests/aus"</span>

<span class='nv'>aus_test_data_raw</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span><span class='o'>(</span><span class='nv'>aus_test_url</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_table.html'>html_table</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>purrr</span><span class='nf'>::</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/pluck.html'>pluck</a></span><span class='o'>(</span><span class='m'>2</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>aus_test_data_raw</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 386 x 4</span></span>
<span class='c'>#&gt;    DATE      TESTS      VAR   NET   </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 21 Mar 21 15,186,991 </span><span style='color: #BB0000;'>NA</span><span>    34,669</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 20 Mar 21 15,152,322 </span><span style='color: #BB0000;'>NA</span><span>    36,037</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 19 Mar 21 15,116,285 </span><span style='color: #BB0000;'>NA</span><span>    44,082</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 18 Mar 21 15,072,203 </span><span style='color: #BB0000;'>NA</span><span>    50,496</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 17 Mar 21 15,021,707 </span><span style='color: #BB0000;'>NA</span><span>    54,260</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 16 Mar 21 14,967,447 </span><span style='color: #BB0000;'>NA</span><span>    33,843</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 15 Mar 21 14,933,604 </span><span style='color: #BB0000;'>NA</span><span>    32,312</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 14 Mar 21 14,901,292 </span><span style='color: #BB0000;'>NA</span><span>    29,392</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 13 Mar 21 14,871,900 </span><span style='color: #BB0000;'>NA</span><span>    36,989</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 12 Mar 21 14,834,911 </span><span style='color: #BB0000;'>NA</span><span>    45,015</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 376 more rows</span></span></code></pre>

</div>

We then clean up the dates and numbers, defining a little function, `strp_date`, to present the dates nicely.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>strp_date</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>x</span><span class='o'>)</span> <span class='nf'><a href='https://rdrr.io/r/base/as.Date.html'>as.Date</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/strptime.html'>strptime</a></span><span class='o'>(</span><span class='nv'>x</span>, format <span class='o'>=</span> <span class='s'>"%d %b"</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>aus_tests</span> <span class='o'>&lt;-</span> <span class='nv'>aus_test_data_raw</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>DATE <span class='o'>=</span> <span class='nf'>strp_date</span><span class='o'>(</span><span class='nv'>DATE</span><span class='o'>)</span>,
         TESTS <span class='o'>=</span> <span class='nf'>parse_number</span><span class='o'>(</span><span class='nv'>TESTS</span><span class='o'>)</span>,
         NET <span class='o'>=</span> <span class='nf'>parse_number</span><span class='o'>(</span><span class='nv'>NET</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>janitor</span><span class='nf'>::</span><span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>rename</span><span class='o'>(</span>daily_tests <span class='o'>=</span> <span class='nv'>net</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: 29 parsing failures.</span>
<span class='c'>#&gt; row col expected actual</span>
<span class='c'>#&gt; 358  -- a number      -</span>
<span class='c'>#&gt; 359  -- a number      -</span>
<span class='c'>#&gt; 360  -- a number      -</span>
<span class='c'>#&gt; 361  -- a number      -</span>
<span class='c'>#&gt; 362  -- a number      -</span>
<span class='c'>#&gt; ... ... ........ ......</span>
<span class='c'>#&gt; See problems(...) for more details.</span>

<span class='nv'>aus_tests</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 386 x 4</span></span>
<span class='c'>#&gt;    date          tests var   daily_tests</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>        </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2021-03-21 15</span><span style='text-decoration: underline;'>186</span><span>991 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>34</span><span>669</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2021-03-20 15</span><span style='text-decoration: underline;'>152</span><span>322 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>36</span><span>037</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2021-03-19 15</span><span style='text-decoration: underline;'>116</span><span>285 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>44</span><span>082</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2021-03-18 15</span><span style='text-decoration: underline;'>072</span><span>203 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>50</span><span>496</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2021-03-17 15</span><span style='text-decoration: underline;'>021</span><span>707 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>54</span><span>260</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2021-03-16 14</span><span style='text-decoration: underline;'>967</span><span>447 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>33</span><span>843</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2021-03-15 14</span><span style='text-decoration: underline;'>933</span><span>604 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>32</span><span>312</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2021-03-14 14</span><span style='text-decoration: underline;'>901</span><span>292 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>29</span><span>392</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2021-03-13 14</span><span style='text-decoration: underline;'>871</span><span>900 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>36</span><span>989</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2021-03-12 14</span><span style='text-decoration: underline;'>834</span><span>911 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>45</span><span>015</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 376 more rows</span></span></code></pre>

</div>

We get a sense of the distribution of tests by ploting the number of daily tests in Australia as a boxplot.

This extra line of code improves how big numbers are presented: `scale_x_continuous(labels = label_number(big.mark = ","))`, turning 100000 into 100,000. Perhaps not a big deal, but I think it helps.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>aus_tests</span>,
       <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>daily_tests</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_boxplot</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>scale_x_continuous</span><span class='o'>(</span>labels <span class='o'>=</span> <span class='nf'><a href='https://scales.r-lib.org//reference/label_number.html'>label_number</a></span><span class='o'>(</span>big.mark <span class='o'>=</span> <span class='s'>","</span><span class='o'>)</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 29 rows containing non-finite values (stat_boxplot).</span>
</code></pre>
<img src="figs/plot-tests-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We learn most of the data is around 25-55K tests per day, give or take, and there were some extreme days where we tested over 150K! Not bad, not bad.

Another way to present the same data is to plot is as a density, along with a rug plot to show the data frequency.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gg_cov_dens</span> <span class='o'>&lt;-</span> <span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>aus_tests</span>,
       <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>daily_tests</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_density</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_rug</span><span class='o'>(</span>alpha <span class='o'>=</span> <span class='m'>0.2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_x_continuous</span><span class='o'>(</span>labels <span class='o'>=</span> <span class='nf'><a href='https://scales.r-lib.org//reference/label_number.html'>label_number</a></span><span class='o'>(</span>big.mark <span class='o'>=</span> <span class='s'>","</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>gg_cov_dens</span>
<span class='c'>#&gt; Warning: Removed 29 rows containing non-finite values (stat_density).</span>
</code></pre>
<img src="figs/tests-rug-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This is pretty much a similar presentation of the previous plot, it's fun to look at, plus rug plots are great. If we're interested in what kind of distribution this follows, we can overlay a normal curve over the top with `geom_function`, adding in the estimated mean and standard deviation

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>tests_mean</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/mean.html'>mean</a></span><span class='o'>(</span><span class='nv'>aus_tests</span><span class='o'>$</span><span class='nv'>daily_tests</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>tests_sd</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/sd.html'>sd</a></span><span class='o'>(</span><span class='nv'>aus_tests</span><span class='o'>$</span><span class='nv'>daily_tests</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='nv'>gg_cov_dens</span> <span class='o'>+</span> 
  <span class='nf'>geom_function</span><span class='o'>(</span>fun <span class='o'>=</span> <span class='nv'>dnorm</span>, 
                args <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span>mean <span class='o'>=</span> <span class='nv'>tests_mean</span>, sd <span class='o'>=</span> <span class='nv'>tests_sd</span><span class='o'>)</span>,
                colour <span class='o'>=</span> <span class='s'>"orange"</span><span class='o'>)</span>
<span class='c'>#&gt; Warning: Removed 29 rows containing non-finite values (stat_density).</span>
</code></pre>
<img src="figs/geom-fun-1.png" width="700px" style="display: block; margin: auto;" />

</div>

It looks somewhat normal, but it's a bit more peaky to the left. So, if you needed to assign this a distribution, maybe representing this as a normal isn't the best, or at least we could understand where it isn't representing the data.

Back on task
============

OK so what were we doing? Back to the question:

> "Based on the COVID19 tests that Australia can perform each day, how long will it take to get to 80% of Australians vaccinated?".

Let's calculate the maximum number of tests, and define 80% of [Australia's population](https://www.abs.gov.au/statistics/people/population).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>max_tests</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/Extremes.html'>max</a></span><span class='o'>(</span><span class='nv'>aus_tests</span><span class='o'>$</span><span class='nv'>daily_tests</span>, na.rm <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='nv'>oz_pop_80_pct</span> <span class='o'>&lt;-</span> <span class='m'>0.8</span> <span class='o'>*</span> <span class='m'>25693059</span></code></pre>

</div>

With this new information we then create a new table with a column of the percentage of maximum tests. We want to create a 100 row table, where each row is a percentage of the maximum tests. We can then calculate the number of days until Australia reaches 80% vaccination by dividing the number of 80% of the population bt the propotion of max tests.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>covid_days_until_vac</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span><span class='o'>(</span>pct_of_max_tests <span class='o'>=</span> <span class='o'>(</span><span class='m'>1</span><span class='o'>:</span><span class='m'>100</span><span class='o'>)</span><span class='o'>/</span><span class='m'>100</span>,
       max_tests <span class='o'>=</span> <span class='nv'>max_tests</span>,
       prop_of_max_tests <span class='o'>=</span> <span class='nv'>max_tests</span> <span class='o'>*</span> <span class='nv'>pct_of_max_tests</span>,
       days_until_80_pct_aus_pop_vac <span class='o'>=</span> <span class='nv'>oz_pop_80_pct</span> <span class='o'>/</span> <span class='nv'>prop_of_max_tests</span><span class='o'>)</span>

<span class='nv'>covid_days_until_vac</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 100 x 4</span></span>
<span class='c'>#&gt;    pct_of_max_tests max_tests prop_of_max_tests days_until_80_pct_aus_pop_vac</span>
<span class='c'>#&gt;               <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>     </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>                         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>             0.01    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>1</span><span>362.                        </span><span style='text-decoration: underline;'>15</span><span>092.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>             0.02    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>2</span><span>724.                         </span><span style='text-decoration: underline;'>7</span><span>546.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>             0.03    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>4</span><span>086.                         </span><span style='text-decoration: underline;'>5</span><span>031.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>             0.04    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>5</span><span>448.                         </span><span style='text-decoration: underline;'>3</span><span>773.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>             0.05    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>6</span><span>810.                         </span><span style='text-decoration: underline;'>3</span><span>018.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>             0.06    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>8</span><span>172.                         </span><span style='text-decoration: underline;'>2</span><span>515.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>             0.07    </span><span style='text-decoration: underline;'>136</span><span>194             </span><span style='text-decoration: underline;'>9</span><span>534.                         </span><span style='text-decoration: underline;'>2</span><span>156.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>             0.08    </span><span style='text-decoration: underline;'>136</span><span>194            </span><span style='text-decoration: underline;'>10</span><span>896.                         </span><span style='text-decoration: underline;'>1</span><span>887.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>             0.09    </span><span style='text-decoration: underline;'>136</span><span>194            </span><span style='text-decoration: underline;'>12</span><span>257.                         </span><span style='text-decoration: underline;'>1</span><span>677.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>             0.1     </span><span style='text-decoration: underline;'>136</span><span>194            </span><span style='text-decoration: underline;'>13</span><span>619.                         </span><span style='text-decoration: underline;'>1</span><span>509.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 90 more rows</span></span></code></pre>

</div>

Then we can plot this!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>covid_days_until_vac</span>,
         <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>days_until_80_pct_aus_pop_vac</span>,
             y <span class='o'>=</span> <span class='nv'>pct_of_max_tests</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span>
</code></pre>
<img src="figs/gg-prop-tests-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Ooof. Ok, so let's assume that we will do better than 25% of our maximum tests by filtering that out:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>covid_days_until_vac</span> <span class='o'>%&gt;%</span> 
<span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>pct_of_max_tests</span> <span class='o'>&gt;=</span> <span class='m'>0.25</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>days_until_80_pct_aus_pop_vac</span>,
             y <span class='o'>=</span> <span class='nv'>pct_of_max_tests</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span>
</code></pre>
<img src="figs/prop-tests-25-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Hmmm, OK so if we want to do it within 1 year from now, looks like we'd need to do over 50% of our tests per day?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>covid_days_until_vac</span> <span class='o'>%&gt;%</span> 
<span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>pct_of_max_tests</span> <span class='o'>&gt;=</span> <span class='m'>0.50</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>days_until_80_pct_aus_pop_vac</span>,
             y <span class='o'>=</span> <span class='nv'>pct_of_max_tests</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span>
</code></pre>
<img src="figs/prop-tests-50-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And how many tests is that now? We can change the y axis to proportion of max tests.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gg_covid_50pct_days</span> <span class='o'>&lt;-</span> 
<span class='nv'>covid_days_until_vac</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>pct_of_max_tests</span> <span class='o'>&gt;=</span> <span class='m'>0.50</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>ggplot</span><span class='o'>(</span><span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>days_until_80_pct_aus_pop_vac</span>,
             y <span class='o'>=</span> <span class='nv'>prop_of_max_tests</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_y_continuous</span><span class='o'>(</span>labels <span class='o'>=</span> <span class='nf'><a href='https://scales.r-lib.org//reference/label_number.html'>label_number</a></span><span class='o'>(</span>big.mark <span class='o'>=</span> <span class='s'>","</span><span class='o'>)</span><span class='o'>)</span>
  
<span class='nv'>gg_covid_50pct_days</span>
</code></pre>
<img src="figs/prop-max-tests-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Let's say we want to be done by October 31, that is currently how many days away? We can use lubridate to work that out:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://lubridate.tidyverse.org'>lubridate</a></span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'lubridate'</span>
<span class='c'>#&gt; The following objects are masked from 'package:base':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     date, intersect, setdiff, union</span>
<span class='nv'>n_days_until_vac</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/ymd.html'>ymd</a></span><span class='o'>(</span><span class='s'>"2021-10-31"</span><span class='o'>)</span> <span class='o'>-</span> <span class='nf'><a href='http://lubridate.tidyverse.org/reference/now.html'>today</a></span><span class='o'>(</span><span class='o'>)</span>
<span class='nv'>n_days_until_vac</span>
<span class='c'>#&gt; Time difference of 224 days</span></code></pre>

</div>

So that's 224 days.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gg_covid_50pct_days</span> <span class='o'>+</span> 
  <span class='nf'>geom_vline</span><span class='o'>(</span>xintercept <span class='o'>=</span> <span class='nv'>n_days_until_vac</span>,
             colour <span class='o'>=</span> <span class='s'>"red"</span>,
             lty <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span>
</code></pre>
<img src="figs/unnamed-chunk-1-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And that means we need about this many tests per day:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>n_tests_per_day_needed</span> <span class='o'>&lt;-</span> 
<span class='nv'>covid_days_until_vac</span> <span class='o'>%&gt;%</span> 
  <span class='c'># there is no 224 days</span>
  <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>days_until_80_pct_aus_pop_vac</span> <span class='o'>&lt;=</span> <span class='m'>225</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>slice_head</span><span class='o'>(</span>n <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>pull</span><span class='o'>(</span><span class='nv'>max_tests</span><span class='o'>)</span>

<span class='nv'>n_tests_per_day_needed</span>
<span class='c'>#&gt; [1] 136194</span></code></pre>

</div>

So we need doses per day to get there by October.

What are COVID vaccinations like currently in Australia?
========================================================

And because why not, let's look at what COVID vaccinations are currently like in Australia.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>aus_vac_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://covidlive.com.au/report/daily-vaccinations/aus"</span>

<span class='nv'>aus_test_data_raw</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span><span class='o'>(</span><span class='nv'>aus_vac_url</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_table.html'>html_table</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>purrr</span><span class='nf'>::</span><span class='nf'><a href='https://purrr.tidyverse.org/reference/pluck.html'>pluck</a></span><span class='o'>(</span><span class='m'>2</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>janitor</span><span class='nf'>::</span><span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>date <span class='o'>=</span> <span class='nf'>strp_date</span><span class='o'>(</span><span class='nv'>date</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span>net <span class='o'>=</span> <span class='nf'>stringr</span><span class='nf'>::</span><span class='nf'><a href='https://stringr.tidyverse.org/reference/str_replace.html'>str_replace_all</a></span><span class='o'>(</span>string <span class='o'>=</span> <span class='nv'>net</span>, 
                                        pattern <span class='o'>=</span> <span class='s'>"-"</span>, 
                                        replacement <span class='o'>=</span> <span class='s'>"0"</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span><span class='nf'>across</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='s'>"cwealth"</span>, <span class='s'>"doses"</span>, <span class='s'>"net"</span><span class='o'>)</span>, <span class='nv'>parse_number</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>rename</span><span class='o'>(</span>daily_vacc <span class='o'>=</span> <span class='nv'>net</span><span class='o'>)</span>

<span class='nv'>aus_test_data_raw</span> 
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 35 x 5</span></span>
<span class='c'>#&gt;    date       cwealth  doses var   daily_vacc</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;date&gt;</span><span>       </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;lgl&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 2021-03-21   </span><span style='text-decoration: underline;'>50</span><span>000 </span><span style='text-decoration: underline;'>256</span><span>782 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>2</span><span>951</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 2021-03-20   </span><span style='text-decoration: underline;'>50</span><span>000 </span><span style='text-decoration: underline;'>253</span><span>831 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>13</span><span>077</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 2021-03-19   </span><span style='text-decoration: underline;'>50</span><span>000 </span><span style='text-decoration: underline;'>240</span><span>754 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>14</span><span>697</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2021-03-18   </span><span style='text-decoration: underline;'>50</span><span>000 </span><span style='text-decoration: underline;'>226</span><span>057 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>22</span><span>500</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2021-03-17   </span><span style='text-decoration: underline;'>45</span><span>607 </span><span style='text-decoration: underline;'>203</span><span>557 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>21</span><span>120</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2021-03-16   </span><span style='text-decoration: underline;'>42</span><span>800 </span><span style='text-decoration: underline;'>182</span><span>437 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>17</span><span>656</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2021-03-15   </span><span style='text-decoration: underline;'>39</span><span>760 </span><span style='text-decoration: underline;'>164</span><span>781 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>2</span><span>230</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2021-03-14   </span><span style='text-decoration: underline;'>39</span><span>760 </span><span style='text-decoration: underline;'>162</span><span>551 </span><span style='color: #BB0000;'>NA</span><span>          </span><span style='text-decoration: underline;'>3</span><span>257</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2021-03-13   </span><span style='text-decoration: underline;'>38</span><span>934 </span><span style='text-decoration: underline;'>159</span><span>294 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>24</span><span>191</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2021-03-12   </span><span style='text-decoration: underline;'>30</span><span>000 </span><span style='text-decoration: underline;'>135</span><span>103 </span><span style='color: #BB0000;'>NA</span><span>         </span><span style='text-decoration: underline;'>10</span><span>103</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 25 more rows</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>aus_test_data_raw</span>,
       <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>date</span>,
           y <span class='o'>=</span> <span class='nv'>doses</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_line</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>scale_y_continuous</span><span class='o'>(</span>labels <span class='o'>=</span> <span class='nf'><a href='https://scales.r-lib.org//reference/label_number.html'>label_number</a></span><span class='o'>(</span>big.mark <span class='o'>=</span> <span class='s'>","</span><span class='o'>)</span><span class='o'>)</span>
</code></pre>
<img src="figs/show-current-vac-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Things are just starting out here in Australia with the vaccine, but we're doing to need to see some pretty substantial ramp ups in the future to meet a goal date of the end of October.

