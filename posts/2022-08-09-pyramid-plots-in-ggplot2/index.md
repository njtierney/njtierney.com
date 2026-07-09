---
title: Population Pyramid Plots in `ggplot2`
author: Nicholas Tierney
date: '2022-08-09'
slug: ggplot-pyramid
categories:
  - data visualisation
  - covid19
  - ggplot2
  - colour palette
  - rstats
aliases:
  - /post/2022/08/09/ggplot-pyramid/
---

<div class="highlight">

<img src="imgs/two-shopping-carts.jpg" width="700px" style="display: block; margin: auto;" />

</div>

*Two Abandoned Trolleys, Nick Tierney, Film, Olympus XA*

I recently had to make some pyramid plots in R. They are a useful way to compare age structures of populations. They look like this:

![Age population structure of Sydney vs Melbourne](figs/show-pop-pyramid-1.png)

It's been a while since I had to make them, and in the past I've cooked them up in a relatively bespoke way. This time I needed to be able to have some level of programming to them - I wanted to be able to provide any two LGAs in Australia and then make a pyramid plot of them that looked nice.

I started by looking at this [SO thread](https://stackoverflow.com/questions/14680075/simpler-population-pyramid-in-ggplot2) - overall this gave me what I wanted, but I thought I'd walk through my solution, as it is a little different, and might hopefully be useful to others.

# The data

The data is comes from the Australian Bureau of Statistics, which is then cleaned up, and packaged in the [conmat](https://github.com/njtierney/conmat) R package, which I maintain. Before I show that, I'll load the packages I need, `tidyverse` , and `conmat`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://tidyverse.tidyverse.org'>tidyverse</a></span><span class='o'>)</span></span><span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span> ───────────────────────────── tidyverse 1.3.1 ──</span></span><span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>ggplot2</span> 3.3.6     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>purrr  </span> 0.3.4</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tibble </span> 3.1.7     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>dplyr  </span> 1.0.9</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>tidyr  </span> 1.2.0     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>stringr</span> 1.4.0</span></span>
<span><span class='c'>#&gt; <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>readr  </span> 2.1.2     <span style='color: #00BB00;'>✔</span> <span style='color: #0000BB;'>forcats</span> 0.5.1</span></span><span><span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>filter()</span> masks <span style='color: #0000BB;'>stats</span>::filter()</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>✖</span> <span style='color: #0000BB;'>dplyr</span>::<span style='color: #00BB00;'>lag()</span>    masks <span style='color: #0000BB;'>stats</span>::lag()</span></span><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'>conmat</span><span class='o'>)</span></span><span><span class='c'>#&gt; Warning: package 'conmat' was built under R version 4.2.1</span></span></code></pre>

</div>

You can access the age structured population for a given LGA like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='c'># |label: LGA-hobart</span></span>
<span><span class='nf'><a href='https://rdrr.io/pkg/conmat/man/abs_age_lga.html'>abs_age_lga</a></span><span class='o'>(</span><span class='s'>"Hobart (C)"</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 18 × 4</span></span></span>
<span><span class='c'>#&gt;    lga        lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Hobart (C)               0  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>442</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Hobart (C)               5  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>833</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Hobart (C)              10  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>771</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Hobart (C)              15  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>038</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Hobart (C)              20  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>982</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Hobart (C)              25  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>5</span>132</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Hobart (C)              30  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>196</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Hobart (C)              35  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>510</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Hobart (C)              40  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>214</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Hobart (C)              45  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>428</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>11</span> Hobart (C)              50  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>202</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>12</span> Hobart (C)              55  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>381</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>13</span> Hobart (C)              60  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>291</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>14</span> Hobart (C)              65  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>036</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>15</span> Hobart (C)              70  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>512</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>16</span> Hobart (C)              75  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>1</span>721</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>17</span> Hobart (C)              80  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>1</span>189</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>18</span> Hobart (C)              85  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>1</span>372</span></span></code></pre>

</div>

In our case, we want to combine two LGAs and compare them. So let's write a little helper function, `two_abs_age_lga`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>two_abs_age_lga</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>lga_1</span>, <span class='nv'>lga_2</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/bind.html'>bind_rows</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://rdrr.io/pkg/conmat/man/abs_age_lga.html'>abs_age_lga</a></span><span class='o'>(</span><span class='nv'>lga_1</span><span class='o'>)</span>,</span>
<span>    <span class='nf'><a href='https://rdrr.io/pkg/conmat/man/abs_age_lga.html'>abs_age_lga</a></span><span class='o'>(</span><span class='nv'>lga_2</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

So now we can get say, Melbourne and Sydney, like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'>&lt;-</span> <span class='nf'>two_abs_age_lga</span><span class='o'>(</span><span class='s'>"Melbourne (C)"</span>, <span class='s'>"Sydney (C)"</span><span class='o'>)</span></span>
<span><span class='nv'>melb_syd</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 4</span></span></span>
<span><span class='c'>#&gt;    lga           lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C)               0  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>882</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C)               5  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>450</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C)              10  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C)              15  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>9</span>396</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C)              20  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>434</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C)              25  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>546</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C)              30  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>25</span>834</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C)              35  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>15</span>072</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C)              40  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>8</span>554</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C)              45  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>6</span>753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span><span><span class='nf'><a href='https://rdrr.io/r/utils/head.html'>tail</a></span><span class='o'>(</span><span class='nv'>melb_syd</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 6 × 4</span></span></span>
<span><span class='c'>#&gt;   lga        lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;   <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>1</span> Sydney (C)              60  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>8</span>950</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>2</span> Sydney (C)              65  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>7</span>377</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>3</span> Sydney (C)              70  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>6</span>308</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>4</span> Sydney (C)              75  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>002</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>5</span> Sydney (C)              80  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>583</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>6</span> Sydney (C)              85  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>506</span></span></code></pre>

</div>

# The data wrangling

Now, to get the data into this plot, what we want is a plot of the population against each age group. To illustrate this I'll just use Melbourne data:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/conmat/man/abs_age_lga.html'>abs_age_lga</a></span><span class='o'>(</span><span class='s'>"Melbourne (C)"</span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>melb</span>,</span>
<span>       <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>           y <span class='o'>=</span> <span class='nv'>lower.age.limit</span>,</span>
<span>           fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>
<img src="figs/gg-melbourne-popn-oops-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Ack, we need the `y` variable to be a factor

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>melb</span>,</span>
<span>       <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>           y <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>lower.age.limit</span><span class='o'>)</span>,</span>
<span>           fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>
<img src="figs/gg-melbourne-popn-1.png" width="700px" style="display: block; margin: auto;" />

</div>

But what we actually want are two plots, one going the other way for the other group. We can make this happen by making the population negative:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>syd</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/pkg/conmat/man/abs_age_lga.html'>abs_age_lga</a></span><span class='o'>(</span><span class='s'>"Sydney (C)"</span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>syd</span>,</span>
<span>       <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='o'>-</span><span class='nv'>population</span>,</span>
<span>           y <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span><span class='o'>(</span><span class='nv'>lower.age.limit</span><span class='o'>)</span>,</span>
<span>           fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span></span></code></pre>
<img src="figs/gg-sydney-popn-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And then we want to combine those two plots - so we can write something bespoke, like this. Let's also make that age limit data a factor while we are here

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd_pyramid</span> <span class='o'>&lt;-</span> <span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    population <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span></span>
<span>      <span class='nv'>lga</span> <span class='o'>==</span> <span class='s'>"Sydney (C)"</span> <span class='o'>~</span> <span class='o'>-</span><span class='nv'>population</span>,</span>
<span>      <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='nv'>population</span></span>
<span>    <span class='o'>)</span>,</span>
<span>    lower.age.limit <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/as_factor.html'>as_factor</a></span><span class='o'>(</span><span class='nv'>lower.age.limit</span><span class='o'>)</span></span>
<span>  <span class='o'>)</span></span>
<span></span>
<span><span class='nv'>melb_syd_pyramid</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 4</span></span></span>
<span><span class='c'>#&gt;    lga           lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>         <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C) 0                <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>882</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C) 5                <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>450</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C) 10               <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C) 15               <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>9</span>396</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C) 20               <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>434</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C) 25               <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>546</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C) 30               <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>25</span>834</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C) 35               <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>15</span>072</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C) 40               <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>8</span>554</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C) 45               <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>6</span>753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span></code></pre>

</div>

So now we can get this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>melb_syd_pyramid</span>,</span>
<span>         <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>lower.age.limit</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> </span></code></pre>
<img src="figs/beta-version-pyramid-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And that's pretty good!

Let's tidy it up a little bit - we want to change the axis on the bottom to be positive in both directions, so we'll need to specify the break points for the axis marks, as well as the labels. So we want a sequence from one end to the other, but for it to be symmetric. Let's start by getting the range, by using the `range` function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>pop_range</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>melb_syd_pyramid</span><span class='o'>$</span><span class='nv'>population</span><span class='o'>)</span></span>
<span><span class='nv'>pop_range</span></span><span><span class='c'>#&gt; [1] -45686  38546</span></span></code></pre>

</div>

Now we want a sequence from there to the end value. We can use `seq` to make a sequence

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>pop_range_seq</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/seq.html'>seq</a></span><span class='o'>(</span><span class='nv'>pop_range</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span>, <span class='nv'>pop_range</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span>, by <span class='o'>=</span> <span class='m'>15000</span><span class='o'>)</span></span>
<span><span class='nv'>pop_range_seq</span></span><span><span class='c'>#&gt; [1] -45686 -30686 -15686   -686  14314  29314</span></span></code></pre>

</div>

Briefly, what we want to do is something like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>melb_syd_pyramid</span>,</span>
<span>         <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>lower.age.limit</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_x_continuous</a></span><span class='o'>(</span>breaks  <span class='o'>=</span> <span class='nv'>pop_range_seq</span>,</span>
<span>                       labels <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>abs</a></span><span class='o'>(</span><span class='nv'>pop_range_seq</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>
<img src="figs/first-pass-pyramid-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Ugh, but the numbers aren't very nice. We want some nicer numbers. We can use a negative number in `round` to give us something slightly better.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/Round.html'>round</a></span><span class='o'>(</span><span class='nv'>pop_range</span>, <span class='o'>-</span><span class='m'>2</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] -45700  38500</span></span></code></pre>

</div>

But I'd like to round to the nearest 500...and we also need to have a 0 in there as well.

# `base::pretty()`

Turns out this is a pretty common thing to do, and base R has us covered, with [`pretty()`](https://rdrr.io/r/base/pretty.html)! It even includes 0!

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://rdrr.io/r/base/pretty.html'>pretty</a></span><span class='o'>(</span><span class='nv'>pop_range</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] -60000 -40000 -20000      0  20000  40000</span></span></code></pre>

</div>

There are loads of options, but we'll just specify `n` to change the number of breaks

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>pop_range_breaks</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/pretty.html'>pretty</a></span><span class='o'>(</span><span class='nv'>pop_range</span>, n <span class='o'>=</span> <span class='m'>7</span><span class='o'>)</span></span></code></pre>

</div>

So now we have something that looks pretty good

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>melb_syd_pyramid</span>,</span>
<span>         <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>lower.age.limit</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_x_continuous</a></span><span class='o'>(</span>breaks  <span class='o'>=</span> <span class='nv'>pop_range_breaks</span>,</span>
<span>                       labels <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>abs</a></span><span class='o'>(</span><span class='nv'>pop_range_breaks</span><span class='o'>)</span><span class='o'>)</span></span></code></pre>
<img src="figs/pretty-good-pyramid-1.png" width="700px" style="display: block; margin: auto;" />

</div>

OK, but a few more gripes:

-   The numbers are a bit hard to read - we can add a comma into them to improve that with [`scales::comma`](https://scales.r-lib.org/reference/comma.html)

-   the legend needs to be on top

-   The colour scale should be colourblind friendly

## `scales::comma()`

A really cool function! It takes number input and adds commas into them.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='m'>10</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] "10"</span></span><span><span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='m'>100</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] "100"</span></span><span><span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='m'>1000</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] "1,000"</span></span><span><span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='m'>1000000</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] "1,000,000"</span></span></code></pre>

</div>

Let's add that in, along with the changes to the legend, as well as an improved colour scale

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>melb_syd_pyramid</span>,</span>
<span>         <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>lower.age.limit</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_x_continuous</a></span><span class='o'>(</span>breaks  <span class='o'>=</span> <span class='nv'>pop_range_breaks</span>,</span>
<span>                       labels <span class='o'>=</span> <span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>abs</a></span><span class='o'>(</span><span class='nv'>pop_range_breaks</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_brewer.html'>scale_fill_brewer</a></span><span class='o'>(</span>palette <span class='o'>=</span> <span class='s'>"Dark2"</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"top"</span><span class='o'>)</span> </span></code></pre>
<img src="figs/improved-pyramid-scale-1.png" width="700px" style="display: block; margin: auto;" />

</div>

# This doesn't generalise to other data

Unfortunately, if I want to do this to another dataset, which doesn't have Sydney and Melbourne, I'll need to write custom code each time. We can do a little better, let's write this as a function, which takes two inputs, the name of each of the LGAs we want to explore.

This involves a few steps - first, we need to modify the data as we've done above. Let's call this a `prep_pop_pyramid` function. First let's scratch out what it will do.

So we need to get the data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'>&lt;-</span> <span class='nf'>two_abs_age_lga</span><span class='o'>(</span><span class='s'>"Melbourne (C)"</span>, <span class='s'>"Sydney (C)"</span><span class='o'>)</span></span></code></pre>

</div>

Then we need to multiply one of the populations by -1, so that we get the reflected population in the other direction. We had previously done:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    population <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span></span>
<span>      <span class='nv'>lga</span> <span class='o'>==</span> <span class='s'>"Sydney (C)"</span> <span class='o'>~</span> <span class='o'>-</span><span class='nv'>population</span>,</span>
<span>      <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='nv'>population</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 4</span></span></span>
<span><span class='c'>#&gt;    lga           lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C)               0  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>882</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C)               5  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>450</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C)              10  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C)              15  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>9</span>396</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C)              20  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>434</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C)              25  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>546</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C)              30  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>25</span>834</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C)              35  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>15</span>072</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C)              40  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>8</span>554</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C)              45  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>6</span>753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span></code></pre>

</div>

But this will not generalise to *any* two LGA names. So instead we can assign one of the LGAs to a number, which we can do by first grouping by lga, then using [`cur_group_id()`](https://dplyr.tidyverse.org/reference/context.html), to label the groups as a number.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>lga</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>cur_group_id</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      .after <span class='o'>=</span> <span class='nv'>lga</span></span>
<span>    <span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   lga [2]</span></span></span>
<span><span class='c'>#&gt;    lga           age_multiplier lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C)              1               0  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>882</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C)              1               5  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>450</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C)              1              10  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C)              1              15  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>9</span>396</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C)              1              20  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>434</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C)              1              25  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>546</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C)              1              30  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>25</span>834</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C)              1              35  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>15</span>072</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C)              1              40  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>8</span>554</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C)              1              45  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>6</span>753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span></code></pre>

</div>

This then gives us a 1 or a 2. We can then set this to be negative if it is the second group.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>lga</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>cur_group_id</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span><span class='nv'>age_multiplier</span> <span class='o'>==</span> <span class='m'>2</span> <span class='o'>~</span> <span class='m'>1</span>,</span>
<span>                                 <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>,</span>
<span>      .after <span class='o'>=</span> <span class='nv'>lga</span></span>
<span>    <span class='o'>)</span> </span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 5</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># Groups:   lga [2]</span></span></span>
<span><span class='c'>#&gt;    lga           age_multiplier lower.age.limit  year population</span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>               0  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>4</span>882</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>               5  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>3</span>450</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              10  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>2</span>675</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              15  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>9</span>396</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              20  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>434</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              25  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>38</span>546</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              30  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>25</span>834</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              35  <span style='text-decoration: underline;'>2</span>020      <span style='text-decoration: underline;'>15</span>072</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              40  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>8</span>554</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              45  <span style='text-decoration: underline;'>2</span>020       <span style='text-decoration: underline;'>6</span>753</span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span></code></pre>

</div>

Then, we have something that we can use to multiply the population by -1 ! Let's also take this chance to turn age into a factor.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>lga</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>cur_group_id</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span><span class='nv'>age_multiplier</span> <span class='o'>==</span> <span class='m'>2</span> <span class='o'>~</span> <span class='m'>1</span>,</span>
<span>                                 <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>,</span>
<span>      .after <span class='o'>=</span> <span class='nv'>lga</span></span>
<span>    <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>ungroup</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>age <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/as_factor.html'>as_factor</a></span><span class='o'>(</span><span class='nv'>lower.age.limit</span><span class='o'>)</span>,</span>
<span>           population <span class='o'>=</span> <span class='nv'>population</span> <span class='o'>*</span> <span class='nv'>age_multiplier</span><span class='o'>)</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 6</span></span></span>
<span><span class='c'>#&gt;    lga           age_multiplier lower.age.limit  year population age  </span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>               0  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>4</span><span style='color: #BB0000;'>882</span> 0    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>               5  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>3</span><span style='color: #BB0000;'>450</span> 5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              10  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>2</span><span style='color: #BB0000;'>675</span> 10   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              15  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>9</span><span style='color: #BB0000;'>396</span> 15   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              20  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>38</span><span style='color: #BB0000;'>434</span> 20   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              25  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>38</span><span style='color: #BB0000;'>546</span> 25   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              30  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>25</span><span style='color: #BB0000;'>834</span> 30   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              35  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>15</span><span style='color: #BB0000;'>072</span> 35   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              40  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>8</span><span style='color: #BB0000;'>554</span> 40   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              45  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>6</span><span style='color: #BB0000;'>753</span> 45   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span></code></pre>

</div>

And then let's wrap this into a function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>prep_pop_pyramid</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>lga</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>cur_group_id</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span><span class='nv'>age_multiplier</span> <span class='o'>==</span> <span class='m'>2</span> <span class='o'>~</span> <span class='m'>1</span>,</span>
<span>                                 <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='o'>-</span><span class='m'>1</span><span class='o'>)</span>,</span>
<span>      .after <span class='o'>=</span> <span class='nv'>lga</span></span>
<span>    <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>ungroup</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>age <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/as_factor.html'>as_factor</a></span><span class='o'>(</span><span class='nv'>lower.age.limit</span><span class='o'>)</span>,</span>
<span>           population <span class='o'>=</span> <span class='nv'>population</span> <span class='o'>*</span> <span class='nv'>age_multiplier</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

OK so now let's put those two parts together:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'>&lt;-</span> <span class='nf'>two_abs_age_lga</span><span class='o'>(</span></span>
<span>  <span class='s'>"Melbourne (C)"</span>,</span>
<span>  <span class='s'>"Sydney (C)"</span></span>
<span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>melb_syd</span></span><span><span class='c'>#&gt; <span style='color: #555555;'># A tibble: 36 × 6</span></span></span>
<span><span class='c'>#&gt;    lga           age_multiplier lower.age.limit  year population age  </span></span>
<span><span class='c'>#&gt;    <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>           <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>      <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;fct&gt;</span></span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 1</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>               0  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>4</span><span style='color: #BB0000;'>882</span> 0    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 2</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>               5  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>3</span><span style='color: #BB0000;'>450</span> 5    </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 3</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              10  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>2</span><span style='color: #BB0000;'>675</span> 10   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 4</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              15  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>9</span><span style='color: #BB0000;'>396</span> 15   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 5</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              20  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>38</span><span style='color: #BB0000;'>434</span> 20   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 6</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              25  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>38</span><span style='color: #BB0000;'>546</span> 25   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 7</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              30  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>25</span><span style='color: #BB0000;'>834</span> 30   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 8</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              35  <span style='text-decoration: underline;'>2</span>020     -<span style='color: #BB0000; text-decoration: underline;'>15</span><span style='color: #BB0000;'>072</span> 35   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'> 9</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              40  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>8</span><span style='color: #BB0000;'>554</span> 40   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'>10</span> Melbourne (C)             -<span style='color: #BB0000;'>1</span>              45  <span style='text-decoration: underline;'>2</span>020      -<span style='color: #BB0000; text-decoration: underline;'>6</span><span style='color: #BB0000;'>753</span> 45   </span></span>
<span><span class='c'>#&gt; <span style='color: #555555;'># … with 26 more rows</span></span></span></code></pre>

</div>

And now let's wrap the plotting code into a function:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>plot_pop_pyramid</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>pop_range</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>data</span><span class='o'>$</span><span class='nv'>population</span><span class='o'>)</span></span>
<span>  </span>
<span>  <span class='nv'>age_range_seq</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/pretty.html'>pretty</a></span><span class='o'>(</span><span class='nv'>pop_range</span>, n <span class='o'>=</span> <span class='m'>10</span><span class='o'>)</span></span>
<span>  </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>data</span>,</span>
<span>         <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>age</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_x_continuous</a></span><span class='o'>(</span>breaks  <span class='o'>=</span> <span class='nv'>age_range_seq</span>,</span>
<span>                       labels <span class='o'>=</span> <span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>abs</a></span><span class='o'>(</span><span class='nv'>age_range_seq</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_brewer.html'>scale_fill_brewer</a></span><span class='o'>(</span>palette <span class='o'>=</span> <span class='s'>"Dark2"</span>,</span>
<span>                      guide <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guide_legend.html'>guide_legend</a></span><span class='o'>(</span></span>
<span>                        title <span class='o'>=</span> <span class='s'>""</span></span>
<span>                      <span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"top"</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'>plot_pop_pyramid</span><span class='o'>(</span><span class='nv'>melb_syd</span><span class='o'>)</span></span></code></pre>
<img src="figs/show-pop-pyramid-1.png" width="700px" style="display: block; margin: auto;" />

</div>

# End

And that was the end of this blog post. But something about the plots kind of bothered me...

# Bonus - centering

Well, there's actually one final step here that you might be interested in - which is centering the "0" of the population. Perhaps there is another way around this, but the approach that I ended up doing was the following:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>pretty_symmetric</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>range</span>, <span class='nv'>n</span> <span class='o'>=</span> <span class='m'>5</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>range_1</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='nv'>range</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span>, <span class='nv'>range</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span><span class='o'>)</span></span>
<span>  <span class='nv'>range_2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>range</span><span class='o'>[</span><span class='m'>1</span><span class='o'>]</span>, <span class='o'>-</span><span class='nv'>range</span><span class='o'>[</span><span class='m'>2</span><span class='o'>]</span><span class='o'>)</span></span>
<span>  </span>
<span>  <span class='nv'>pretty_vec_1</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/pretty.html'>pretty</a></span><span class='o'>(</span><span class='nv'>range_1</span><span class='o'>)</span></span>
<span>  <span class='nv'>pretty_vec_2</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/pretty.html'>pretty</a></span><span class='o'>(</span><span class='nv'>range_2</span><span class='o'>)</span></span>
<span>  </span>
<span>  <span class='nf'><a href='https://rdrr.io/r/base/pretty.html'>pretty</a></span><span class='o'>(</span></span>
<span>    <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>pretty_vec_1</span>, <span class='nv'>pretty_vec_2</span><span class='o'>)</span>, </span>
<span>    n <span class='o'>=</span> <span class='nv'>n</span></span>
<span>  <span class='o'>)</span></span>
<span>  </span>
<span><span class='o'>&#125;</span></span>
<span></span>
<span><span class='nf'>pretty_symmetric</span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='o'>-</span><span class='m'>5000</span>, <span class='m'>10000</span><span class='o'>)</span><span class='o'>)</span></span><span><span class='c'>#&gt; [1] -10000  -5000      0   5000  10000</span></span></code></pre>

</div>

So then we replace `pretty`, with `pretty_symmetric` , and then need to add this other bit, `expand_limits` which ensures the limits are kept

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>plot_pop_pyramid</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span><span class='o'>&#123;</span></span>
<span>  <span class='nv'>pop_range</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>data</span><span class='o'>$</span><span class='nv'>population</span><span class='o'>)</span></span>
<span>  </span>
<span>  <span class='nv'>age_range_seq</span> <span class='o'>&lt;-</span> <span class='nf'>pretty_symmetric</span><span class='o'>(</span><span class='nv'>pop_range</span>, n <span class='o'>=</span> <span class='m'>5</span><span class='o'>)</span></span>
<span>  </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nv'>data</span>,</span>
<span>         <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>population</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>age</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_x_continuous</a></span><span class='o'>(</span>breaks  <span class='o'>=</span> <span class='nv'>age_range_seq</span>,</span>
<span>                       labels <span class='o'>=</span> <span class='nf'>scales</span><span class='nf'>::</span><span class='nf'><a href='https://scales.r-lib.org/reference/comma.html'>comma</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>abs</a></span><span class='o'>(</span><span class='nv'>age_range_seq</span><span class='o'>)</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/expand_limits.html'>expand_limits</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>age_range_seq</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_brewer.html'>scale_fill_brewer</a></span><span class='o'>(</span>palette <span class='o'>=</span> <span class='s'>"Dark2"</span>,</span>
<span>                      guide <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guide_legend.html'>guide_legend</a></span><span class='o'>(</span></span>
<span>                        title <span class='o'>=</span> <span class='s'>""</span></span>
<span>                      <span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"top"</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nf'>plot_pop_pyramid</span><span class='o'>(</span><span class='nv'>melb_syd</span><span class='o'>)</span></span></code></pre>
<img src="figs/init-pyramid-demo-1.png" width="700px" style="display: block; margin: auto;" />

</div>

This has a nice benefit of facilitating stacking the plots with something like `patchwork` and the 0s will be aligned.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'>&lt;-</span> <span class='nf'>two_abs_age_lga</span><span class='o'>(</span></span>
<span>  <span class='s'>"Melbourne (C)"</span>,</span>
<span>  <span class='s'>"Sydney (C)"</span></span>
<span><span class='o'>)</span> </span>
<span></span>
<span><span class='nv'>bris_hobart</span> <span class='o'>&lt;-</span> <span class='nf'>two_abs_age_lga</span><span class='o'>(</span></span>
<span>  <span class='s'>"Brisbane (C)"</span>,</span>
<span>  <span class='s'>"Hobart (C)"</span></span>
<span><span class='o'>)</span></span>
<span><span class='nv'>alice_perth</span> <span class='o'>&lt;-</span> <span class='nf'>two_abs_age_lga</span><span class='o'>(</span></span>
<span>  <span class='s'>"Alice Springs (T)"</span>,</span>
<span>  <span class='s'>"Perth (C)"</span></span>
<span><span class='o'>)</span> </span></code></pre>

</div>

Then we can stack them together with patchwork

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://patchwork.data-imaginist.com'>patchwork</a></span><span class='o'>)</span></span>
<span><span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>plot_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>/</span></span>
<span><span class='nv'>bris_hobart</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>plot_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>/</span></span>
<span><span class='nv'>alice_perth</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>plot_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span></span></code></pre>
<img src="figs/patchwork-plot-1.png" width="700px" style="display: block; margin: auto;" />

</div>

# Bonus Bonus - per capita

Ugh. OK. These plots are nice, but really, these should be normalised by the total population.

What does that mean? Why would we want to do that? Well, if you have two cities, one with HEAPS of people, and other with 1000 times less people - the numbers are going to be harder to compare. And if the point you are trying to convey is:

> Hey, these two cities have very different population *sizes*

Then we've done that above.

But what we actually kind of care about the most is:

> Hey, do these two cities have similar age distributions?

So like, do they have the same proportion of 20-somethings in both cities? Regardless of the fact that one city has like 100 or 1000 times more people?

So, we should fix it.

Where do we fix it? We need to change the data creation function. Adding a new column, `population_per_capita`, with something like this:

``` r
mutate(population_per_capita = population / sum(population))
```

Which divides the population by the total population. This is sometimes called "normalising". Effectively, we are comparing each age population to the total population.

Also importantly, we need to do this still in the `group_by(lga)` below

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>prep_pop_pyramid</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span> <span class='o'>&#123;</span></span>
<span>  <span class='nv'>data</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>group_by</a></span><span class='o'>(</span><span class='nv'>lga</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/context.html'>cur_group_id</a></span><span class='o'>(</span><span class='o'>)</span>,</span>
<span>      age_multiplier <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span></span>
<span>        <span class='nv'>age_multiplier</span> <span class='o'>==</span> <span class='m'>2</span> <span class='o'>~</span> <span class='m'>1</span>,</span>
<span>        <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='o'>-</span><span class='m'>1</span></span>
<span>      <span class='o'>)</span>,</span>
<span>      .after <span class='o'>=</span> <span class='nv'>lga</span></span>
<span>    <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span>population_per_capita <span class='o'>=</span> <span class='nv'>population</span> <span class='o'>/</span> <span class='nf'><a href='https://rdrr.io/r/base/sum.html'>sum</a></span><span class='o'>(</span><span class='nv'>population</span><span class='o'>)</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/group_by.html'>ungroup</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span></span>
<span>    <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>      age <span class='o'>=</span> <span class='nf'><a href='https://forcats.tidyverse.org/reference/as_factor.html'>as_factor</a></span><span class='o'>(</span><span class='nv'>lower.age.limit</span><span class='o'>)</span>,</span>
<span>      population <span class='o'>=</span> <span class='nv'>population</span> <span class='o'>*</span> <span class='nv'>age_multiplier</span>,</span>
<span>      population_per_capita <span class='o'>=</span> <span class='nv'>population_per_capita</span> <span class='o'>*</span> <span class='nv'>age_multiplier</span></span>
<span>    <span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

And since we've changed the data that we are using now - we aren't using `population` anymore, and I hard coded the plotting code, we need to re-write the function. Perhaps with the benefit of hindsight it would have been better to not hard code variables in the plotting function, but here we are.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>plot_pop_pyramid_per_capita</span> <span class='o'>&lt;-</span> <span class='kr'>function</span><span class='o'>(</span><span class='nv'>data</span><span class='o'>)</span> <span class='o'>&#123;</span></span>
<span>  <span class='nv'>pop_range</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>data</span><span class='o'>$</span><span class='nv'>population_per_capita</span><span class='o'>)</span></span>
<span></span>
<span>  <span class='nv'>age_range_seq</span> <span class='o'>&lt;-</span> <span class='nf'>pretty_symmetric</span><span class='o'>(</span><span class='nv'>pop_range</span>, n <span class='o'>=</span> <span class='m'>5</span><span class='o'>)</span></span>
<span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span></span>
<span>    <span class='nv'>data</span>,</span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span></span>
<span>      x <span class='o'>=</span> <span class='nv'>population_per_capita</span>,</span>
<span>      y <span class='o'>=</span> <span class='nv'>age</span>,</span>
<span>      fill <span class='o'>=</span> <span class='nv'>lga</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_continuous.html'>scale_x_continuous</a></span><span class='o'>(</span></span>
<span>      breaks <span class='o'>=</span> <span class='nv'>age_range_seq</span>,</span>
<span>      labels <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/MathFun.html'>abs</a></span><span class='o'>(</span><span class='nv'>age_range_seq</span><span class='o'>)</span></span>
<span>    <span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/expand_limits.html'>expand_limits</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/range.html'>range</a></span><span class='o'>(</span><span class='nv'>age_range_seq</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_brewer.html'>scale_fill_brewer</a></span><span class='o'>(</span></span>
<span>      palette <span class='o'>=</span> <span class='s'>"Dark2"</span>,</span>
<span>      guide <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guide_legend.html'>guide_legend</a></span><span class='o'>(</span></span>
<span>        title <span class='o'>=</span> <span class='s'>""</span></span>
<span>      <span class='o'>)</span></span>
<span>    <span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"top"</span><span class='o'>)</span></span>
<span><span class='o'>&#125;</span></span></code></pre>

</div>

All together now

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>melb_syd</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>plot_pop_pyramid_per_capita</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>/</span></span>
<span><span class='nv'>bris_hobart</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>plot_pop_pyramid_per_capita</span><span class='o'>(</span><span class='o'>)</span> <span class='o'>/</span></span>
<span><span class='nv'>alice_perth</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>plot_pop_pyramid_per_capita</span><span class='o'>(</span><span class='o'>)</span></span></code></pre>
<img src="figs/patchwork-plot-per-capita-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And now for comparison to drive home the difference between the per capita pyramid and the raw population pyramid - most notably, there is a huge difference between brisbane and hobart - previously the population numbers in Brisbane drowned out the differnces in Hobart

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>bris_hobart_pyramid</span> <span class='o'>&lt;-</span> <span class='nv'>bris_hobart</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> <span class='nf'>prep_pop_pyramid</span><span class='o'>(</span><span class='o'>)</span></span>
<span><span class='nf'>plot_pop_pyramid</span><span class='o'>(</span><span class='nv'>bris_hobart_pyramid</span><span class='o'>)</span> <span class='o'>/</span></span>
<span>  <span class='nf'>plot_pop_pyramid_per_capita</span><span class='o'>(</span><span class='nv'>bris_hobart_pyramid</span><span class='o'>)</span></span></code></pre>
<img src="figs/patchwork-plot-per-capita-brisbane-hobart-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Another way to present this is as a regular bar graph, which more strongly places our focus on comparison between age groups.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>bris_hobart_pyramid</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://dplyr.tidyverse.org/reference/mutate.html'>mutate</a></span><span class='o'>(</span></span>
<span>    <span class='c'># reverse age_multiplier</span></span>
<span>    population <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span></span>
<span>      <span class='nv'>age_multiplier</span> <span class='o'>==</span> <span class='o'>-</span><span class='m'>1</span> <span class='o'>~</span> <span class='nv'>population</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span>,</span>
<span>      <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='nv'>population</span></span>
<span>    <span class='o'>)</span>,</span>
<span>    population_per_capita <span class='o'>=</span> <span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span><span class='o'>(</span></span>
<span>      <span class='nv'>age_multiplier</span> <span class='o'>==</span> <span class='o'>-</span><span class='m'>1</span> <span class='o'>~</span> <span class='nv'>population_per_capita</span> <span class='o'>*</span> <span class='o'>-</span><span class='m'>1</span>,</span>
<span>      <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='nv'>population_per_capita</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span><span class='o'>(</span></span>
<span>    cols <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='nv'>population</span>,</span>
<span>             <span class='nv'>population_per_capita</span><span class='o'>)</span>,</span>
<span>    names_to <span class='o'>=</span> <span class='s'>"pop_type"</span>,</span>
<span>    values_to <span class='o'>=</span> <span class='s'>"pop_value"</span></span>
<span>  <span class='o'>)</span> <span class='o'><a href='https://magrittr.tidyverse.org/reference/pipe.html'>%&gt;%</a></span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggplot.html'>ggplot</a></span><span class='o'>(</span><span class='nf'><a href='https://ggplot2.tidyverse.org/reference/aes.html'>aes</a></span><span class='o'>(</span>x <span class='o'>=</span> <span class='nv'>age</span>,</span>
<span>             y <span class='o'>=</span> <span class='nv'>pop_value</span>,</span>
<span>             fill <span class='o'>=</span> <span class='nv'>lga</span><span class='o'>)</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/geom_bar.html'>geom_col</a></span><span class='o'>(</span>position <span class='o'>=</span> <span class='s'>"dodge"</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/facet_wrap.html'>facet_wrap</a></span><span class='o'>(</span><span class='o'>~</span><span class='nv'>pop_type</span>,</span>
<span>             scales <span class='o'>=</span> <span class='s'>"free_y"</span>,</span>
<span>             ncol <span class='o'>=</span> <span class='m'>1</span><span class='o'>)</span> <span class='o'>+</span> </span>
<span>  <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/scale_brewer.html'>scale_fill_brewer</a></span><span class='o'>(</span></span>
<span>      palette <span class='o'>=</span> <span class='s'>"Dark2"</span>,</span>
<span>      guide <span class='o'>=</span> <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/guide_legend.html'>guide_legend</a></span><span class='o'>(</span></span>
<span>        title <span class='o'>=</span> <span class='s'>""</span></span>
<span>      <span class='o'>)</span></span>
<span>    <span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/ggtheme.html'>theme_minimal</a></span><span class='o'>(</span><span class='o'>)</span> <span class='o'>+</span></span>
<span>    <span class='nf'><a href='https://ggplot2.tidyverse.org/reference/theme.html'>theme</a></span><span class='o'>(</span>legend.position <span class='o'>=</span> <span class='s'>"top"</span><span class='o'>)</span></span></code></pre>
<img src="figs/plot-per-capita-brisbane-hobart-bar-1.png" width="700px" style="display: block; margin: auto;" />

</div>

In some ways, I think I prefer this graph - there are many ways to present information, and in this case it helps us more clearly compare the differences between two places. It also strongly highlights the difference between using per capita and raw population values.

# PS

I actually wrote this up initially to make a figure for a grant. Then, unhappy with the fact that I had to alter the code 2 times to make the figure, I converted it into a targets pipeline, which you can see here on github: <https://github.com/njtierney/target-pop-pyramid>

Also fun fact, the figure didn't make it into the grant. But now you've got this blog post, so that's pretty neat, I guess?

