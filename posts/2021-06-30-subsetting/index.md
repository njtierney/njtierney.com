---
title: Some Unexpected Things About Subsetting
date: '2021-06-30'
slug: subsetting
categories:
  - rstats
aliases:
  - /post/2021/06/30/subsetting/
---

The other day a colleague of mine ran into an issue where NA values were appearing in their dataset that weren't there before - it was strange stuff!

A close look revealed some interesting things, that I thought might be worthwhile briefly going into. It is to do with the use of `[]` when subsetting, and how this is different to [`base::subset`](https://rdrr.io/r/base/subset.html) and [`dplyr::filter`](https://dplyr.tidyverse.org/reference/filter.html).

Let's start by creating a dataset, `df`. This contains countries and an airport

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/data.frame.html'>data.frame</a></span><span class='o'>(</span>
  country <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>NA</span>, <span class='s'>"AUS"</span>, <span class='s'>"NZL"</span>, <span class='s'>"USA "</span><span class='o'>)</span>,
  airport <span class='o'>=</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>NA</span>, <span class='s'>"BNE"</span>, <span class='s'>"CHC"</span>, <span class='s'>" SFO"</span><span class='o'>)</span>
<span class='o'>)</span>

<span class='nv'>df</span>
<span class='c'>#&gt;   country airport</span>
<span class='c'>#&gt; 1    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; 2     AUS     BNE</span>
<span class='c'>#&gt; 3     NZL     CHC</span>
<span class='c'>#&gt; 4    USA      SFO</span></code></pre>

</div>

If we want to just look at rows that contain "AUS", we can do the following:

``` r
df[df$country == "AUS", ]
```

Which is asking to only choose rows where country is "AUS".

However, when we run this, we get something unexpected

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"AUS"</span>, <span class='o'>]</span>
<span class='c'>#&gt;    country airport</span>
<span class='c'>#&gt; NA    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; 2      AUS     BNE</span></code></pre>

</div>

We get an NA row?

# What? Weird?

Under the hood, [`==`](https://rdrr.io/r/base/Comparison.html) is identifying rows that match this statement.

You could also do this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>FALSE</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>FALSE</span><span class='o'>)</span>, <span class='o'>]</span>
<span class='c'>#&gt;   country airport</span>
<span class='c'>#&gt; 2     AUS     BNE</span></code></pre>

</div>

But that's too hard to manually create those vectors for datasets - we instead get that result out by running it inside the `[]`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"AUS"</span>, <span class='o'>]</span>
<span class='c'>#&gt;    country airport</span>
<span class='c'>#&gt; NA    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; 2      AUS     BNE</span></code></pre>

</div>

So why the NA row?

Well, we do have an NA row in the dataset:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span>
<span class='c'>#&gt;   country airport</span>
<span class='c'>#&gt; 1    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; 2     AUS     BNE</span>
<span class='c'>#&gt; 3     NZL     CHC</span>
<span class='c'>#&gt; 4    USA      SFO</span></code></pre>

</div>

And we can check what the output of `df$country == "AUS"` is:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>where_match_aus</span> <span class='o'>&lt;-</span> <span class='nv'>df</span><span class='o'>$</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"AUS"</span>
<span class='nv'>where_match_aus</span>
<span class='c'>#&gt; [1]    NA  TRUE FALSE FALSE</span></code></pre>

</div>

This shows us the same as what we saw above

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[</span><span class='nv'>where_match_aus</span>, <span class='o'>]</span>
<span class='c'>#&gt;    country airport</span>
<span class='c'>#&gt; NA    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; 2      AUS     BNE</span>
<span class='nv'>df</span><span class='o'>[</span><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span><span class='o'>(</span><span class='kc'>NA</span>, <span class='kc'>TRUE</span>, <span class='kc'>FALSE</span>, <span class='kc'>FALSE</span><span class='o'>)</span>, <span class='o'>]</span>
<span class='c'>#&gt;    country airport</span>
<span class='c'>#&gt; NA    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; 2      AUS     BNE</span></code></pre>

</div>

But what is weird about this is that you can use `NA` inside `[]` when subsetting:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[</span><span class='kc'>NA</span>, <span class='o'>]</span>
<span class='c'>#&gt;      country airport</span>
<span class='c'>#&gt; NA      &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; NA.1    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; NA.2    &lt;NA&gt;    &lt;NA&gt;</span>
<span class='c'>#&gt; NA.3    &lt;NA&gt;    &lt;NA&gt;</span></code></pre>

</div>

And you get a whole lot of weird rows now? Strange, right?

And what happens when our filter is wrong? Remember, "USA" has a trailing space in it, so if we write out "USA", we get:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>[</span><span class='nv'>df</span><span class='o'>$</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"USA"</span>, <span class='o'>]</span>
<span class='c'>#&gt;    country airport</span>
<span class='c'>#&gt; NA    &lt;NA&gt;    &lt;NA&gt;</span></code></pre>

</div>

Since we get `NA` when we do:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nv'>df</span><span class='o'>$</span><span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"USA"</span>
<span class='c'>#&gt; [1]    NA FALSE FALSE FALSE</span></code></pre>

</div>

# What about base::subset or dplyr::filter

For what it's worth, this issue doesn't appear inside [`base::subset`](https://rdrr.io/r/base/subset.html) or [`dplyr::filter`](https://dplyr.tidyverse.org/reference/filter.html) - I guess this means the turn `NA` into FALSE?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># vs subset</span>
<span class='nf'><a href='https://rdrr.io/r/base/subset.html'>subset</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"AUS"</span><span class='o'>)</span>
<span class='c'>#&gt;   country airport</span>
<span class='c'>#&gt; 2     AUS     BNE</span>
<span class='nf'><a href='https://rdrr.io/r/base/subset.html'>subset</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"USA"</span><span class='o'>)</span>
<span class='c'>#&gt; [1] country airport</span>
<span class='c'>#&gt; &lt;0 rows&gt; (or 0-length row.names)</span>
<span class='nf'><a href='https://rdrr.io/r/base/subset.html'>subset</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='kc'>NA</span><span class='o'>)</span>
<span class='c'>#&gt; [1] country airport</span>
<span class='c'>#&gt; &lt;0 rows&gt; (or 0-length row.names)</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># vs filter</span>
<span class='nf'>dplyr</span><span class='nf'>::</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"AUS"</span><span class='o'>)</span>
<span class='c'>#&gt;   country airport</span>
<span class='c'>#&gt; 1     AUS     BNE</span>
<span class='nf'>dplyr</span><span class='nf'>::</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='nv'>country</span> <span class='o'>==</span> <span class='s'>"USA"</span><span class='o'>)</span>
<span class='c'>#&gt; [1] country airport</span>
<span class='c'>#&gt; &lt;0 rows&gt; (or 0-length row.names)</span>
<span class='nf'>dplyr</span><span class='nf'>::</span><span class='nf'><a href='https://dplyr.tidyverse.org/reference/filter.html'>filter</a></span><span class='o'>(</span><span class='nv'>df</span>, <span class='kc'>NA</span><span class='o'>)</span>
<span class='c'>#&gt; [1] country airport</span>
<span class='c'>#&gt; &lt;0 rows&gt; (or 0-length row.names)</span></code></pre>

</div>

# I have more questions, but I have to go

I feel like there are more questions I have about this, and I am probably missing some important details, but I just thought this was interesting!

