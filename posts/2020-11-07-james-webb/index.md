---
title: James Webb and the XKCD-inspired Wikipedia Scraping
date: '2020-11-07'
slug: james-webb
categories:
  - rstats
aliases:
  - /post/2020/11/07/james-webb/
---

I was talking (well, via video) to a friend about the [James Webb Telescope](https://en.wikipedia.org/wiki/James_Webb_Space_Telescope). The James Webb is going to be a pretty big deal when it launches. It is one of the most complex things designed by humans, and it will do a lot more than the Hubble telescope, which means we can learn more about space, and, well, who knows?

When is it due to launch? It's been delayed quite a few times. There's even a relevant XKCD on this:

<div class="highlight">

<img src="https://imgs.xkcd.com/comics/jwst_delays.png" width="700px" style="display: block; margin: auto;" />

</div>

And, looking at this, I was wondering how accurate the plot [Randall Munroe](https://xkcd.com/about/) made was? Turns out this was an interesting exercise in itself!

This blog post covers how to scrape some tables from Wikipedia, tidy them up, perform some basic modelling, make some forecasts, and plot them.

The packages
============

First let's load up a few libraries:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/dmi3kno/polite'>polite</a></span><span class='o'>)</span>
<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://rvest.tidyverse.org/'>rvest</a></span><span class='o'>)</span>

<span class='c'>#&gt; Loading required package: xml2</span>

<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ───────────────────────────── tidyverse 1.3.0 ──</span></span>

<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.4     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.2</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.2     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.4.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>

<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span>         masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>readr</span><span>::</span><span style='color: #00BB00;'>guess_encoding()</span><span> masks </span><span style='color: #0000BB;'>rvest</span><span>::guess_encoding()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>            masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>purrr</span><span>::</span><span style='color: #00BB00;'>pluck()</span><span>          masks </span><span style='color: #0000BB;'>rvest</span><span>::pluck()</span></span>

<span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/sfirke/janitor'>janitor</a></span><span class='o'>)</span>

<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'janitor'</span>

<span class='c'>#&gt; The following objects are masked from 'package:stats':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     chisq.test, fisher.test</span>

<span class='nf'>conflicted</span><span class='nf'>::</span><span class='nf'><a href='https://rdrr.io/pkg/conflicted/man/conflict_prefer.html'>conflict_prefer</a></span><span class='o'>(</span><span class='s'>"pluck"</span>, <span class='s'>"purrr"</span><span class='o'>)</span>

<span class='c'>#&gt; [conflicted] Will prefer <span style='color: #0000BB;'>purrr::pluck</span><span> over any other package</span></span>
</code></pre>

</div>

-   `polite` and `rvest` are the webscraping tools
-   `tidyverse` gives us many data analysis tools
-   `janitor` provides some extra data cleaning powers.

We also use `conflicted` to state we prefer `pluck` from the `purrr` package (as there is a `pluck` in `rvest`, which has caught me out many a time).

First, let's take a look at the [Wiki article](https://en.wikipedia.org/wiki/James_Webb_Space_Telescope) to get the data and the dates.

It looks like this table is what we want:

<div class="highlight">

<img src="figs/wiki-james-web.png" width="700px" style="display: block; margin: auto;" />

</div>

But how do we download the table into R?

We "inspect element" to identify the table (CMD + Shift + C on Chrome):

<div class="highlight">

<img src="figs/wiki-james-web-element.png" width="700px" style="display: block; margin: auto;" />

</div>

Mousing over the table we see that this has the class: "wikitable". We can use this information to help extract out the right part of the website.

First, let's use the `polite` package to check we can download the data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>wiki_url</span> <span class='o'>&lt;-</span> <span class='s'>"https://en.wikipedia.org/wiki/James_Webb_Space_Telescope"</span>

<span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span><span class='o'>(</span><span class='nv'>wiki_url</span><span class='o'>)</span>

<span class='c'>#&gt; &lt;polite session&gt; https://en.wikipedia.org/wiki/James_Webb_Space_Telescope</span>
<span class='c'>#&gt;     User-agent: polite R package - https://github.com/dmi3kno/polite</span>
<span class='c'>#&gt;     robots.txt: 456 rules are defined for 33 bots</span>
<span class='c'>#&gt;    Crawl delay: 5 sec</span>
<span class='c'>#&gt;   The path is scrapable for this user-agent</span>
</code></pre>

</div>

Ok looks like we are all good! Now let's `scrape` it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>jwebb_data</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/polite/man/bow.html'>bow</a></span><span class='o'>(</span><span class='nv'>wiki_url</span><span class='o'>)</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/pkg/polite/man/scrape.html'>scrape</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='nv'>jwebb_data</span>

<span class='c'>#&gt; {html_document}</span>
<span class='c'>#&gt; &lt;html class="client-nojs" lang="en" dir="ltr"&gt;</span>
<span class='c'>#&gt; [1] &lt;head&gt;\n&lt;meta http-equiv="Content-Type" content="text/html; charset=UTF-8 ...</span>
<span class='c'>#&gt; [2] &lt;body class="mediawiki ltr sitedir-ltr mw-hide-empty-elt ns-0 ns-subject  ...</span>
</code></pre>

</div>

We use tools from `rvest` to identify particular parts. In our case, we want to use `html_nodes` and tell it to get the `.wikitable` that we saw earlier.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>jwebb_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_nodes.html'>html_nodes</a></span><span class='o'>(</span><span class='s'>".wikitable"</span><span class='o'>)</span>

<span class='c'>#&gt; {xml_nodeset (3)}</span>
<span class='c'>#&gt; [1] &lt;table class="wikitable" style="text-align:center; float:center; margin:1 ...</span>
<span class='c'>#&gt; [2] &lt;table class="wikitable" style="font-size:88%; float:right; margin-left:0 ...</span>
<span class='c'>#&gt; [3] &lt;table class="wikitable" style="font-size:0.9em; float:right; margin-left ...</span>
</code></pre>

</div>

We see here that we have three tables, let's extract the tables from each of these, using `map` to run `html_table` on each, using `fill = TRUE` to fill rows with fewer than max columns with NAs, to ensure we get proper data back.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>jwebb_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_nodes.html'>html_nodes</a></span><span class='o'>(</span><span class='s'>".wikitable"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>map</span><span class='o'>(</span><span class='nv'>html_table</span>, fill <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>

<span class='c'>#&gt; [[1]]</span>
<span class='c'>#&gt;                                                                    X1</span>
<span class='c'>#&gt; 1                       Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                                                Name</span>
<span class='c'>#&gt; 3                                                                 IRT</span>
<span class='c'>#&gt; 4                                Infrared Space Observatory (ISO)[57]</span>
<span class='c'>#&gt; 5                  Hubble Space Telescope Imaging Spectrograph (STIS)</span>
<span class='c'>#&gt; 6  Hubble Near Infrared Camera and Multi-Object Spectrometer (NICMOS)</span>
<span class='c'>#&gt; 7                                             Spitzer Space Telescope</span>
<span class='c'>#&gt; 8                                   Hubble Wide Field Camera 3 (WFC3)</span>
<span class='c'>#&gt; 9                                          Herschel Space Observatory</span>
<span class='c'>#&gt; 10                                                               JWST</span>
<span class='c'>#&gt;                                               X2</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                           Year</span>
<span class='c'>#&gt; 3                                           1985</span>
<span class='c'>#&gt; 4                                           1995</span>
<span class='c'>#&gt; 5                                           1997</span>
<span class='c'>#&gt; 6                                           1997</span>
<span class='c'>#&gt; 7                                           2003</span>
<span class='c'>#&gt; 8                                           2009</span>
<span class='c'>#&gt; 9                                           2009</span>
<span class='c'>#&gt; 10                                          2021</span>
<span class='c'>#&gt;                                               X3</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                     Wavelength</span>
<span class='c'>#&gt; 3                                     1.7–118 μm</span>
<span class='c'>#&gt; 4                                     2.5–240 μm</span>
<span class='c'>#&gt; 5                                  0.115–1.03 μm</span>
<span class='c'>#&gt; 6                                     0.8–2.4 μm</span>
<span class='c'>#&gt; 7                                       3–180 μm</span>
<span class='c'>#&gt; 8                                     0.2–1.7 μm</span>
<span class='c'>#&gt; 9                                      55–672 μm</span>
<span class='c'>#&gt; 10                                   0.6–28.5 μm</span>
<span class='c'>#&gt;                                               X4</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                       Aperture</span>
<span class='c'>#&gt; 3                                         0.15 m</span>
<span class='c'>#&gt; 4                                         0.60 m</span>
<span class='c'>#&gt; 5                                          2.4 m</span>
<span class='c'>#&gt; 6                                          2.4 m</span>
<span class='c'>#&gt; 7                                         0.85 m</span>
<span class='c'>#&gt; 8                                          2.4 m</span>
<span class='c'>#&gt; 9                                          3.5 m</span>
<span class='c'>#&gt; 10                                         6.5 m</span>
<span class='c'>#&gt;                                               X5</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                        Cooling</span>
<span class='c'>#&gt; 3                                         Helium</span>
<span class='c'>#&gt; 4                                         Helium</span>
<span class='c'>#&gt; 5                                        Passive</span>
<span class='c'>#&gt; 6                     Nitrogen, later cryocooler</span>
<span class='c'>#&gt; 7                                         Helium</span>
<span class='c'>#&gt; 8                 Passive + Thermo-electric [58]</span>
<span class='c'>#&gt; 9                                         Helium</span>
<span class='c'>#&gt; 10                   Passive + cryocooler (MIRI)</span>
<span class='c'>#&gt;                                               X6</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 3                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 4                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 5                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 6                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 7                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 8                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 9                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 10                                          &lt;NA&gt;</span>
<span class='c'>#&gt;                                               X7</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 3                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 4                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 5                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 6                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 7                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 8                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 9                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 10                                          &lt;NA&gt;</span>
<span class='c'>#&gt;                                               X8</span>
<span class='c'>#&gt; 1  Selected space telescopes and instruments[56]</span>
<span class='c'>#&gt; 2                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 3                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 4                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 5                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 6                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 7                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 8                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 9                                           &lt;NA&gt;</span>
<span class='c'>#&gt; 10                                          &lt;NA&gt;</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[2]]</span>
<span class='c'>#&gt;   Year               Events</span>
<span class='c'>#&gt; 1 1996        NGST started.</span>
<span class='c'>#&gt; 2 2002 named JWST, 8 to 6 m</span>
<span class='c'>#&gt; 3 2004 NEXUS cancelled [60]</span>
<span class='c'>#&gt; 4 2007         ESA/NASA MOU</span>
<span class='c'>#&gt; 5 2010          MCDR passed</span>
<span class='c'>#&gt; 6 2011      Proposed cancel</span>
<span class='c'>#&gt; 7 2021       Planned launch</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; [[3]]</span>
<span class='c'>#&gt;                               Year                   Plannedlaunch</span>
<span class='c'>#&gt; 1                             1997                       2007 [80]</span>
<span class='c'>#&gt; 2                             1998                       2007 [85]</span>
<span class='c'>#&gt; 3                             1999               2007 to 2008 [86]</span>
<span class='c'>#&gt; 4                             2000                       2009 [44]</span>
<span class='c'>#&gt; 5                             2002                       2010 [87]</span>
<span class='c'>#&gt; 6                             2003                       2011 [88]</span>
<span class='c'>#&gt; 7                             2005                            2013</span>
<span class='c'>#&gt; 8                             2006                            2014</span>
<span class='c'>#&gt; 9  2008, Preliminary Design Review 2008, Preliminary Design Review</span>
<span class='c'>#&gt; 10                            2008                            2014</span>
<span class='c'>#&gt; 11    2010, Critical Design Review    2010, Critical Design Review</span>
<span class='c'>#&gt; 12                            2010                    2015 to 2016</span>
<span class='c'>#&gt; 13                            2011                            2018</span>
<span class='c'>#&gt; 14                            2013                            2018</span>
<span class='c'>#&gt; 15                            2017                       2019 [94]</span>
<span class='c'>#&gt; 16                            2018                       2020 [95]</span>
<span class='c'>#&gt; 17                            2018                       2021 [96]</span>
<span class='c'>#&gt; 18                            2020                        2021 [3]</span>
<span class='c'>#&gt;           Budget Plan(Billion USD)</span>
<span class='c'>#&gt; 1                         0.5 [80]</span>
<span class='c'>#&gt; 2                           1 [59]</span>
<span class='c'>#&gt; 3                           1 [59]</span>
<span class='c'>#&gt; 4                         1.8 [59]</span>
<span class='c'>#&gt; 5                         2.5 [59]</span>
<span class='c'>#&gt; 6                         2.5 [59]</span>
<span class='c'>#&gt; 7                           3 [89]</span>
<span class='c'>#&gt; 8                         4.5 [90]</span>
<span class='c'>#&gt; 9  2008, Preliminary Design Review</span>
<span class='c'>#&gt; 10                        5.1 [91]</span>
<span class='c'>#&gt; 11    2010, Critical Design Review</span>
<span class='c'>#&gt; 12            6.5[citation needed]</span>
<span class='c'>#&gt; 13                        8.7 [92]</span>
<span class='c'>#&gt; 14                        8.8 [93]</span>
<span class='c'>#&gt; 15                             8.8</span>
<span class='c'>#&gt; 16                            ≥8.8</span>
<span class='c'>#&gt; 17                            9.66</span>
<span class='c'>#&gt; 18                        ≥10 [34]</span>
</code></pre>

</div>

We want the third table, so we use `pluck`, and convert it to a `tibble` for nice printing

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>jwebb_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_nodes.html'>html_nodes</a></span><span class='o'>(</span><span class='s'>".wikitable"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>map</span><span class='o'>(</span><span class='nv'>html_table</span>, fill <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/pluck.html'>pluck</a></span><span class='o'>(</span><span class='m'>3</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 18 x 3</span></span>
<span class='c'>#&gt;    Year                     Plannedlaunch             `Budget Plan(Billion USD)`</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                    </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                     </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                     </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 1997                     2007 [80]                 0.5 [80]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 1998                     2007 [85]                 1 [59]                    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 1999                     2007 to 2008 [86]         1 [59]                    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2000                     2009 [44]                 1.8 [59]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2002                     2010 [87]                 2.5 [59]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2003                     2011 [88]                 2.5 [59]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2005                     2013                      3 [89]                    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2006                     2014                      4.5 [90]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2008, Preliminary Desig… 2008, Preliminary Design… 2008, Preliminary Design …</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2008                     2014                      5.1 [91]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span><span> 2010, Critical Design R… 2010, Critical Design Re… 2010, Critical Design Rev…</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span><span> 2010                     2015 to 2016              6.5[citation needed]      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>13</span><span> 2011                     2018                      8.7 [92]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>14</span><span> 2013                     2018                      8.8 [93]                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>15</span><span> 2017                     2019 [94]                 8.8                       </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>16</span><span> 2018                     2020 [95]                 ≥8.8                      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>17</span><span> 2018                     2021 [96]                 9.66                      </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>18</span><span> 2020                     2021 [3]                  ≥10 [34]</span></span>
</code></pre>

</div>

We get rid of rows 9 and 11 as they are rows that span the full table and aren't proper data in this context, and then run `clean_names` from `janitor` to make the variable names nicer.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>jwebb_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_nodes.html'>html_nodes</a></span><span class='o'>(</span><span class='s'>".wikitable"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>map</span><span class='o'>(</span><span class='nv'>html_table</span>, fill <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/pluck.html'>pluck</a></span><span class='o'>(</span><span class='m'>3</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>slice</span><span class='o'>(</span><span class='o'>-</span><span class='m'>9</span>, 
        <span class='o'>-</span><span class='m'>11</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 16 x 3</span></span>
<span class='c'>#&gt;    year  plannedlaunch     budget_plan_billion_usd</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>             </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>                  </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 1997  2007 [80]         0.5 [80]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 1998  2007 [85]         1 [59]                 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 1999  2007 to 2008 [86] 1 [59]                 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 2000  2009 [44]         1.8 [59]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 2002  2010 [87]         2.5 [59]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 2003  2011 [88]         2.5 [59]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 2005  2013              3 [89]                 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 2006  2014              4.5 [90]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 2008  2014              5.1 [91]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 2010  2015 to 2016      6.5[citation needed]   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span><span> 2011  2018              8.7 [92]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span><span> 2013  2018              8.8 [93]               </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>13</span><span> 2017  2019 [94]         8.8                    </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>14</span><span> 2018  2020 [95]         ≥8.8                   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>15</span><span> 2018  2021 [96]         9.66                   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>16</span><span> 2020  2021 [3]          ≥10 [34]</span></span>
</code></pre>

</div>

Finally we `parse_number` over all columns, using `across` and friends:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>jwebb</span> <span class='o'>&lt;-</span> <span class='nv'>jwebb_data</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/html_nodes.html'>html_nodes</a></span><span class='o'>(</span><span class='s'>".wikitable"</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>map</span><span class='o'>(</span><span class='nv'>html_table</span>, fill <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rvest.tidyverse.org/reference/pluck.html'>pluck</a></span><span class='o'>(</span><span class='m'>3</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>as_tibble</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>slice</span><span class='o'>(</span><span class='o'>-</span><span class='m'>9</span>,
        <span class='o'>-</span><span class='m'>11</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='https://rdrr.io/pkg/janitor/man/clean_names.html'>clean_names</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>%&gt;%</span> 
  <span class='nf'>mutate</span><span class='o'>(</span><span class='nf'>across</span><span class='o'>(</span><span class='nf'>everything</span><span class='o'>(</span><span class='o'>)</span>, <span class='nv'>parse_number</span><span class='o'>)</span><span class='o'>)</span>

<span class='nv'>jwebb</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 16 x 3</span></span>
<span class='c'>#&gt;     year plannedlaunch budget_plan_billion_usd</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>         </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span>                   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  </span><span style='text-decoration: underline;'>1</span><span>997          </span><span style='text-decoration: underline;'>2</span><span>007                    0.5 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  </span><span style='text-decoration: underline;'>1</span><span>998          </span><span style='text-decoration: underline;'>2</span><span>007                    1   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>  </span><span style='text-decoration: underline;'>1</span><span>999          </span><span style='text-decoration: underline;'>2</span><span>007                    1   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000          </span><span style='text-decoration: underline;'>2</span><span>009                    1.8 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>  </span><span style='text-decoration: underline;'>2</span><span>002          </span><span style='text-decoration: underline;'>2</span><span>010                    2.5 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  </span><span style='text-decoration: underline;'>2</span><span>003          </span><span style='text-decoration: underline;'>2</span><span>011                    2.5 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>  </span><span style='text-decoration: underline;'>2</span><span>005          </span><span style='text-decoration: underline;'>2</span><span>013                    3   </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  </span><span style='text-decoration: underline;'>2</span><span>006          </span><span style='text-decoration: underline;'>2</span><span>014                    4.5 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  </span><span style='text-decoration: underline;'>2</span><span>008          </span><span style='text-decoration: underline;'>2</span><span>014                    5.1 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>  </span><span style='text-decoration: underline;'>2</span><span>010          </span><span style='text-decoration: underline;'>2</span><span>015                    6.5 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span><span>  </span><span style='text-decoration: underline;'>2</span><span>011          </span><span style='text-decoration: underline;'>2</span><span>018                    8.7 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span><span>  </span><span style='text-decoration: underline;'>2</span><span>013          </span><span style='text-decoration: underline;'>2</span><span>018                    8.8 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>13</span><span>  </span><span style='text-decoration: underline;'>2</span><span>017          </span><span style='text-decoration: underline;'>2</span><span>019                    8.8 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>14</span><span>  </span><span style='text-decoration: underline;'>2</span><span>018          </span><span style='text-decoration: underline;'>2</span><span>020                    8.8 </span></span>
<span class='c'>#&gt; <span style='color: #555555;'>15</span><span>  </span><span style='text-decoration: underline;'>2</span><span>018          </span><span style='text-decoration: underline;'>2</span><span>021                    9.66</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>16</span><span>  </span><span style='text-decoration: underline;'>2</span><span>020          </span><span style='text-decoration: underline;'>2</span><span>021                   10</span></span>
</code></pre>

</div>

We now want to check we can make a similar plot to XKCD, let's plot the data, with a linear model fit overlayed:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gg_jwebb</span> <span class='o'>&lt;-</span> <span class='nf'>ggplot</span><span class='o'>(</span><span class='nv'>jwebb</span>,
       <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>,
           y <span class='o'>=</span> <span class='nv'>plannedlaunch</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_point</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_smooth</span><span class='o'>(</span>method <span class='o'>=</span> <span class='s'>"lm"</span>,
              se <span class='o'>=</span> <span class='kc'>FALSE</span><span class='o'>)</span>
<span class='nv'>gg_jwebb</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/jwebb-plot-1.png" width="700px" style="display: block; margin: auto;" />

</div>

OK but now we need to extend out the plot to get a sense of where it can extrapolate to. Let's extend the limits, and add an abline, a line with slope of 1 and intercept through 0.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gg_jwebb</span> <span class='o'>+</span>
  <span class='nf'>lims</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1997</span>,<span class='m'>2030</span><span class='o'>)</span>,
       y <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1997</span>,<span class='m'>2030</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_abline</span><span class='o'>(</span>linetype <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/jwebb-plot-abline-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We want to extend that fitted line ahead, so let's fit a linear model to the data with `plannedlaunch` being predicted by `year` (which is what `geom_smooth(method = "lm")` does under the hood):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>lm_jwebb</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/stats/lm.html'>lm</a></span><span class='o'>(</span><span class='nv'>plannedlaunch</span> <span class='o'>~</span> <span class='nv'>year</span>, <span class='nv'>jwebb</span><span class='o'>)</span>
</code></pre>

</div>

Then we use `augment` to predict some new data for 1997 through to 2030:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://broom.tidymodels.org/'>broom</a></span><span class='o'>)</span>
<span class='nv'>new_data</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span><span class='o'>(</span>year <span class='o'>=</span> <span class='m'>1997</span><span class='o'>:</span><span class='m'>2030</span><span class='o'>)</span>
<span class='nv'>jwebb_predict</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://generics.r-lib.org/reference/augment.html'>augment</a></span><span class='o'>(</span><span class='nv'>lm_jwebb</span>, newdata <span class='o'>=</span> <span class='nv'>new_data</span><span class='o'>)</span>
<span class='nv'>jwebb_predict</span>

<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 34 x 2</span></span>
<span class='c'>#&gt;     year .fitted</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span>   </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span>  </span><span style='text-decoration: underline;'>1</span><span>997   </span><span style='text-decoration: underline;'>2</span><span>007.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span>  </span><span style='text-decoration: underline;'>1</span><span>998   </span><span style='text-decoration: underline;'>2</span><span>008.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span>  </span><span style='text-decoration: underline;'>1</span><span>999   </span><span style='text-decoration: underline;'>2</span><span>008.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span>  </span><span style='text-decoration: underline;'>2</span><span>000   </span><span style='text-decoration: underline;'>2</span><span>009.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span>  </span><span style='text-decoration: underline;'>2</span><span>001   </span><span style='text-decoration: underline;'>2</span><span>010.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span>  </span><span style='text-decoration: underline;'>2</span><span>002   </span><span style='text-decoration: underline;'>2</span><span>010.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span>  </span><span style='text-decoration: underline;'>2</span><span>003   </span><span style='text-decoration: underline;'>2</span><span>011.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span>  </span><span style='text-decoration: underline;'>2</span><span>004   </span><span style='text-decoration: underline;'>2</span><span>012.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span>  </span><span style='text-decoration: underline;'>2</span><span>005   </span><span style='text-decoration: underline;'>2</span><span>012.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span>  </span><span style='text-decoration: underline;'>2</span><span>006   </span><span style='text-decoration: underline;'>2</span><span>013.</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 24 more rows</span></span>
</code></pre>

</div>

Now we can add that to our plot:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>gg_jwebb_pred</span> <span class='o'>&lt;-</span> <span class='nv'>gg_jwebb</span> <span class='o'>+</span>
  <span class='nf'>lims</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1997</span>,<span class='m'>2030</span><span class='o'>)</span>,
       y <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='m'>1997</span>,<span class='m'>2030</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> 
  <span class='nf'>geom_abline</span><span class='o'>(</span>linetype <span class='o'>=</span> <span class='m'>2</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>geom_line</span><span class='o'>(</span>data <span class='o'>=</span> <span class='nv'>jwebb_predict</span>,
            colour <span class='o'>=</span> <span class='s'>"steelblue"</span>,
            linetype <span class='o'>=</span> <span class='m'>3</span>,
            size <span class='o'>=</span> <span class='m'>1</span>,
            <span class='nf'>aes</span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>year</span>,
                y <span class='o'>=</span> <span class='nv'>.fitted</span><span class='o'>)</span><span class='o'>)</span>
<span class='nv'>gg_jwebb_pred</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/lm-add-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And finally add some extra details that XKCD had, using `geom_vline` and `geom_label_rep`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='http://github.com/slowkow/ggrepel'>ggrepel</a></span><span class='o'>)</span>

<span class='nv'>gg_jwebb_pred</span> <span class='o'>+</span> 
  <span class='nf'>geom_vline</span><span class='o'>(</span>xintercept <span class='o'>=</span> <span class='m'>2026.5</span>,
             linetype <span class='o'>=</span> <span class='m'>2</span>,
             colour <span class='o'>=</span> <span class='s'>"orange"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'>labs</span><span class='o'>(</span>title <span class='o'>=</span> <span class='s'>"Predicted James Webb Launch"</span>,
       subtitle <span class='o'>=</span> <span class='s'>"Did Randell Munroe get it right?"</span><span class='o'>)</span> <span class='o'>+</span>
  <span class='nf'><a href='https://rdrr.io/pkg/ggrepel/man/geom_text_repel.html'>geom_label_repel</a></span><span class='o'>(</span>data <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>year <span class='o'>=</span> <span class='m'>2026.5</span>,
                               plannedlaunch <span class='o'>=</span> <span class='m'>2026.5</span><span class='o'>)</span>,
             label <span class='o'>=</span> <span class='s'>"2026"</span>,
             nudge_x <span class='o'>=</span> <span class='o'>-</span><span class='m'>2</span>,
             nudge_y <span class='o'>=</span> <span class='m'>3</span>,
             segment.colour <span class='o'>=</span> <span class='s'>"gray50"</span><span class='o'>)</span>

<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>

</code></pre>
<img src="figs/lm-repel-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Did he get it right?

Yes, of course. Why did I ever doubt him.

