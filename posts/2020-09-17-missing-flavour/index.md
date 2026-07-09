---
title: The many Flavours of Missing Values
date: '2020-09-17'
slug: missing-flavour
categories:
  - Missing Data
  - rstats
aliases:
  - /post/2020/09/17/missing-flavour/
---

<div class="highlight">

<img src="figs/header-image-small.JPG" width="700px" style="display: block; margin: auto;" />

</div>

`NA` values represent missing values in R. They're awesome, because they're baked right into R natively. There are actually many different flavours of NA values in R:

-   `NA` is a logical
-   `NA_character_` is characters
-   `NA_integer_` is integer values
-   `NA_real_` is doubles (values with decimal points)
-   `NA_complex_` for complex values (like `1i`)

This means that these `NA` values have different properties, even though when printing them , they print as `NA`, they are character, or complex, or whatnot.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span>(<span class='m'>NA</span>)

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span>(<span class='m'>NA_character_</span>)

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/character.html'>is.character</a></span>(<span class='m'>NA_character_</span>)

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/double.html'>is.double</a></span>(<span class='m'>NA_character_</span>)

<span class='c'>#&gt; [1] FALSE</span>

<span class='nf'><a href='https://rdrr.io/r/base/integer.html'>is.integer</a></span>(<span class='m'>NA_integer_</span>)

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/logical.html'>is.logical</a></span>(<span class='m'>NA</span>)

<span class='c'>#&gt; [1] TRUE</span>
</code></pre>

</div>

Uhhh-huh. So, neat? Right? NA values are this double entity that have different classes? Yup! And they're among the special reserved words in R. That's a fun fact.

OK, so why care about this? Well, in R, when you create a vector, it has to resolve to the same class. Not sure what I mean?

Well, imagine you want to have the values 1:3

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>1</span>,<span class='m'>2</span>,<span class='m'>3</span>)

<span class='c'>#&gt; [1] 1 2 3</span>
</code></pre>

</div>

And then you add one that is in quotes, "hello there":

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>1</span>,<span class='m'>2</span>,<span class='m'>3</span>, <span class='s'>"hello there"</span>)

<span class='c'>#&gt; [1] "1"           "2"           "3"           "hello there"</span>
</code></pre>

</div>

They all get converted to "character". For more on this, see [Hadley Wickham's vctrs talk](https://rstudio.com/resources/rstudioconf-2019/vctrs-tools-for-making-size-and-type-consistent-functions/)

Well, it turns out that `NA` values need to have that feature as well, they aren't this amorphous value that magically takes on the class. Well, they kind of are actually, and that's kind of the point - we don't notice it, and it's one of the great things about R, it has native support for NA values.

So, imagine this tiny vector, then:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vec</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='s'>"a"</span>, <span class='m'>NA</span>)
<span class='k'>vec</span>

<span class='c'>#&gt; [1] "a" NA</span>
</code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/character.html'>is.character</a></span>(<span class='k'>vec</span>[<span class='m'>1</span>])

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span>(<span class='k'>vec</span>[<span class='m'>1</span>])

<span class='c'>#&gt; [1] FALSE</span>

<span class='nf'><a href='https://rdrr.io/r/base/character.html'>is.character</a></span>(<span class='k'>vec</span>[<span class='m'>2</span>])

<span class='c'>#&gt; [1] TRUE</span>

<span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span>(<span class='k'>vec</span>[<span class='m'>2</span>])

<span class='c'>#&gt; [1] TRUE</span>
</code></pre>

</div>

OK, so, what's the big deal? What's the deal with this long lead up? Stay with me, we're nearly there:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>vec</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>1</span><span class='o'>:</span><span class='m'>5</span>)
<span class='k'>vec</span>

<span class='c'>#&gt; [1] 1 2 3 4 5</span>
</code></pre>

</div>

Now, let's say we want to replace values greater than 4 to be the next line in [the song by Feist](https://www.youtube.com/watch?v=ABYnqp-bxvg).

If we use the base R, `ifelse`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, yes = <span class='s'>"tell me that you love me more"</span>, no = <span class='k'>vec</span>)

<span class='c'>#&gt; [1] "1"                             "2"                            </span>
<span class='c'>#&gt; [3] "3"                             "4"                            </span>
<span class='c'>#&gt; [5] "tell me that you love me more"</span>
</code></pre>

</div>

It converts everything to a character. We get what we want here.

Now, if we use [`dplyr::if_else`](https://dplyr.tidyverse.org/reference/if_else.html):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>dplyr</span>::<span class='nf'><a href='https://dplyr.tidyverse.org/reference/if_else.html'>if_else</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, true = <span class='s'>"tell me that you love me more"</span>, false = <span class='k'>vec</span>)

<span class='c'>#&gt; Error: `false` must be a character vector, not an integer vector.</span>
</code></pre>

</div>

ooo, an error? This is useful because you might have a case where you do something like this:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>dplyr</span>::<span class='nf'><a href='https://dplyr.tidyverse.org/reference/if_else.html'>if_else</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, true = <span class='s'>"5"</span>, false = <span class='k'>vec</span>)

<span class='c'>#&gt; Error: `false` must be a character vector, not an integer vector.</span>
</code></pre>

</div>

Which wouldn't be protected against in base:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, yes = <span class='s'>"5"</span>, no = <span class='k'>vec</span>)

<span class='c'>#&gt; [1] "1" "2" "3" "4" "5"</span>
</code></pre>

</div>

So why does that matter for NA values?
--------------------------------------

Well, because if you try and replace values more than 4 with `NA`, you'll get the same error:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>dplyr</span>::<span class='nf'><a href='https://dplyr.tidyverse.org/reference/if_else.html'>if_else</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, true = <span class='m'>NA</span>, false = <span class='k'>vec</span>)

<span class='c'>#&gt; Error: `false` must be a logical vector, not an integer vector.</span>
</code></pre>

</div>

But this can be resolved by using the appropriate `NA` type:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>dplyr</span>::<span class='nf'><a href='https://dplyr.tidyverse.org/reference/if_else.html'>if_else</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, true = <span class='m'>NA_integer_</span>, false = <span class='k'>vec</span>)

<span class='c'>#&gt; [1]  1  2  3  4 NA</span>
</code></pre>

</div>

And that's why it's important to know about.

It's one of these somewhat annoying things that you can come across in the tidyverse, but it's also kind of great. It's opinionated, and it means that you will almost certainly save yourself a whole world of pain later.

What is kind of fun is that using base R you can get some interesting results playing with the different types of `NA` values, like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, yes = <span class='m'>NA</span>, no = <span class='k'>vec</span>)

<span class='c'>#&gt; [1]  1  2  3  4 NA</span>

<span class='nf'><a href='https://rdrr.io/r/base/ifelse.html'>ifelse</a></span>(<span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span>, yes = <span class='m'>NA_character_</span>, no = <span class='k'>vec</span>)

<span class='c'>#&gt; [1] "1" "2" "3" "4" NA</span>
</code></pre>

</div>

It's also worth knowing that you'll get the same error appearing in `case_when`:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>dplyr</span>::<span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span>(
  <span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span> <span class='o'>~</span> <span class='m'>NA</span>,
  <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='k'>vec</span>
  )

<span class='c'>#&gt; Error: must be a logical vector, not an integer vector.</span>
</code></pre>

</div>

But this can be resolved by using the appropriate `NA` value

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>dplyr</span>::<span class='nf'><a href='https://dplyr.tidyverse.org/reference/case_when.html'>case_when</a></span>(
  <span class='k'>vec</span> <span class='o'>&gt;</span> <span class='m'>4</span> <span class='o'>~</span> <span class='m'>NA_integer_</span>,
  <span class='kc'>TRUE</span> <span class='o'>~</span> <span class='k'>vec</span>
  )

<span class='c'>#&gt; [1]  1  2  3  4 NA</span>
</code></pre>

</div>

Lesson learnt?
==============

Remember if you are replacing values with `NA` when using [`dplyr::if_else`](https://dplyr.tidyverse.org/reference/if_else.html) or [`dplyr::case_when`](https://dplyr.tidyverse.org/reference/case_when.html), to consider the flavour of `NA` to use!

Happy travels!

<div class="highlight">

<img src="figs/memer-1.png" width="700px" style="display: block; margin: auto;" />

</div>

