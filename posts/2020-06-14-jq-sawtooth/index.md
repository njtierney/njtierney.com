---
title: 'Just Quickly: Removing Sawtooth Patterns in Line Graphs'
date: '2020-06-14'
slug: jq-sawtooth
categories:
  - rstats
  - data visualisation
aliases:
  - /post/2020/06/14/jq-sawtooth/
---

Sometimes you come across a plot that looks like the following:

<div class="highlight">

<img src="figs/ozbaby-example-1.png" width="700px" style="display: block; margin: auto;" />

</div>

And you might think:

> Something does not look right but I have no idea what is going on here

And that's OK.

So, what's the problem with the plot, and how do you solve it?

Well, the problem is we have these "sawtooth" patterns in the data, where the data goes up and down.

Typically, we can solve this problem by including some grouping characteristic into the data visualisation.

It is also worth noting that this doesn't always mean a plot is bad - this could actually be the exact type of plot that you might expect to see (for example in a time series with very high periodicity, perhaps).

But, in our case, we need to understand what our data is first, and what we expect. We are looking at [ozbabynames](https://github.com/ropenscilabs/ozbabynames) - the names at birth of people in Australia. So we are plotting the number of names of a person at birth for each year. In our example we can look at the occurrences of the name, "Kim", like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>oz_kim</span>,
       <span class='nf'>aes</span>(x = <span class='k'>year</span>,
           y = <span class='k'>count</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>()
</code></pre>
<img src="figs/oz-kim-1.png" width="700px" style="display: block; margin: auto;" />

</div>

We don't expect the name "kim" to suddenly crash down each year - especially since this looks to be an exact vertical drop.

So what do we do?

This vis problem often means there is some grouping characteristic missing from the graphic. For example, in this case, "sex" is not shown in the data. In showing it, we get:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://colorspace.R-Forge.R-project.org'>colorspace</a></span>)
  <span class='nf'>ggplot</span>(<span class='k'>oz_kim</span>,
         <span class='nf'>aes</span>(x = <span class='k'>year</span>,
             y = <span class='k'>count</span>,
             colour = <span class='k'>sex</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() <span class='o'>+</span>
  <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/scale_colour_discrete_qualitative.html'>scale_colour_discrete_qualitative</a></span>()
</code></pre>
<img src="figs/add-sex-1.png" width="700px" style="display: block; margin: auto;" />

</div>

So we see that there is still some sawtooth patterns going on. Let's look at the data to see if there are other variables we are missing:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>oz_kim</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 164 x 5</span></span>
<span class='c'>#&gt;    name  sex     year count state          </span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>  </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span>          </span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>017     2 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>016     1 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>015     1 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>014     2 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> Kim   Male    </span><span style='text-decoration: underline;'>2</span><span>014     1 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>012     1 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>011     3 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>010     1 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>009     1 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> Kim   Female  </span><span style='text-decoration: underline;'>2</span><span>008     3 South Australia</span></span>
<span class='c'>#&gt; <span style='color: #555555;'># … with 154 more rows</span></span></code></pre>

</div>

Aha! We can see that there is another grouping characteristic going on - State. Let's facet the graph for each state, giving us:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>oz_kim</span>,
       <span class='nf'>aes</span>(x = <span class='k'>year</span>,
           y = <span class='k'>count</span>,
           colour = <span class='k'>sex</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>() <span class='o'>+</span> 
  <span class='nf'>facet_wrap</span>(<span class='o'>~</span><span class='k'>state</span>) <span class='o'>+</span>
  <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/scale_colour_discrete_qualitative.html'>scale_colour_discrete_qualitative</a></span>()
</code></pre>
<img src="figs/add-sex-state-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Setting group correctly (Addition as of 2020/06/22)
---------------------------------------------------

[Emma Vitz](https://twitter.com/EmmaVitz) had an interesting example of another sawtooth type problem shared on twitter:

<blockquote class="twitter-tweet"><a href="https://twitter.com/i/web/status/1272395508309360641"></a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

The solution was discussed in the thread, but let's unpack this. Let's first recreate the data used (taken by eyeballing the graphic):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='k'>pageviews</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span>(
  age = <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/rep.html'>rep</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='s'>"18-24"</span>,
                     <span class='s'>"25-34"</span>,
                     <span class='s'>"35-44"</span>,
                     <span class='s'>"45-54"</span>,
                     <span class='s'>"55-64"</span>,
                     <span class='s'>"65"</span>), <span class='m'>2</span>)),
  gender = <span class='nf'><a href='https://rdrr.io/r/base/factor.html'>factor</a></span>(x = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/rep.html'>rep</a></span>(<span class='s'>"Female"</span>, <span class='m'>6</span>),
                        <span class='nf'><a href='https://rdrr.io/r/base/rep.html'>rep</a></span>(<span class='s'>"Male"</span>, <span class='m'>6</span>))),
  pageviews = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>2750</span>, <span class='m'>4200</span>, <span class='m'>1750</span>, <span class='m'>750</span>, <span class='m'>450</span>, <span class='m'>500</span>,
                <span class='m'>2500</span>, <span class='m'>4200</span>, <span class='m'>900</span>, <span class='m'>350</span>, <span class='m'>180</span>, <span class='m'>150</span>)
)

<span class='k'>pageviews</span>
<span class='c'>#&gt; <span style='color: #555555;'># A tibble: 12 x 3</span></span>
<span class='c'>#&gt;    age   gender pageviews</span>
<span class='c'>#&gt;    <span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span> </span><span style='color: #555555;font-style: italic;'>&lt;fct&gt;</span><span>      </span><span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 1</span><span> 18-24 Female      </span><span style='text-decoration: underline;'>2</span><span>750</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 2</span><span> 25-34 Female      </span><span style='text-decoration: underline;'>4</span><span>200</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 3</span><span> 35-44 Female      </span><span style='text-decoration: underline;'>1</span><span>750</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 4</span><span> 45-54 Female       750</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 5</span><span> 55-64 Female       450</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 6</span><span> 65    Female       500</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 7</span><span> 18-24 Male        </span><span style='text-decoration: underline;'>2</span><span>500</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 8</span><span> 25-34 Male        </span><span style='text-decoration: underline;'>4</span><span>200</span></span>
<span class='c'>#&gt; <span style='color: #555555;'> 9</span><span> 35-44 Male         900</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>10</span><span> 45-54 Male         350</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>11</span><span> 55-64 Male         180</span></span>
<span class='c'>#&gt; <span style='color: #555555;'>12</span><span> 65    Male         150</span></span></code></pre>

</div>

So here is the warning given for the first of Emma's plots:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>pageviews</span>,
       <span class='nf'>aes</span>(x = <span class='k'>age</span>,
           y = <span class='k'>pageviews</span>,
           colour = <span class='k'>gender</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>()
<span class='c'>#&gt; geom_path: Each group consists of only one observation. Do you need to adjust</span>
<span class='c'>#&gt; the group aesthetic?</span>
</code></pre>
<img src="figs/emma-plot-warning-1.png" width="700px" style="display: block; margin: auto;" />

</div>

What to do? One way to get the lines to appear is to set `group = 1`

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>pageviews</span>,
       <span class='nf'>aes</span>(x = <span class='k'>age</span>,
           y = <span class='k'>pageviews</span>,
           colour = <span class='k'>gender</span>,
           group = <span class='m'>1</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>()
</code></pre>
<img src="figs/emma-plot-1.png" width="700px" style="display: block; margin: auto;" />

</div>

But then we get this! That isn't ideal. The solution proposed on twitter was to set `group = gender` as well as `colour = gender`.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>ggplot</span>(<span class='k'>pageviews</span>,
       <span class='nf'>aes</span>(x = <span class='k'>age</span>,
           y = <span class='k'>pageviews</span>,
           colour = <span class='k'>gender</span>,
           group = <span class='k'>gender</span>)) <span class='o'>+</span> 
  <span class='nf'>geom_line</span>()
</code></pre>
<img src="figs/emma-plot-fix-1.png" width="700px" style="display: block; margin: auto;" />

</div>

The answer was provided by [Peter Green](https://twitter.com/pitakakariki), who said:

> Looks like since x=age is a factor, ggplot is "helpfully" making age the group instead of gender? Which would explain why fixing it with the explicit group=gender works?

My take on this is that since there are two factors here, it causes `ggplot` some confusion. The default behaviour of `ggplot` when setting `colour` is to use the same grouping, but in this case, as there are two factors, it doesn't know what to pick. By setting the `group` explicitly, you get the right plot.

Wrapping Up
===========

So, **how to remove sawtooth patterns in a plot?**

1.  Understand what sort of graphic you are expecting
2.  Explore and potentially include all grouping features into the graphic
3.  Ensure that if you have factors in some of your aesthetics (`x`, `y`, `colour`, `size`), that you specify `group` to the right variable in your dataset.

