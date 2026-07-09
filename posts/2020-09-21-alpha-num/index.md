---
title: Create Alpha Numeric Strings
date: '2020-09-21'
slug: alpha-num
categories:
  - functions
  - rstats
aliases:
  - /post/2020/09/21/alpha-num/
---

<div class="highlight">

<img src="figs/en-sign-small.JPG" width="700px" style="display: block; margin: auto;" />

</div>

Sometimes it is useful to create alpha numeric strings. In my case, I wanted to generate something that looked like an API key in a demo.

Here's the code to do that, also with an additional argument to write to clipboard, which I usually want to do, and is made possible with the excellent [`clipr`](https://github.com/mdlincoln/clipr) package by [Matthew Lincoln](https://matthewlincoln.net/).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>alpha_num</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>n</span>, <span class='k'>save_clip</span> = <span class='kc'>TRUE</span>){
  
  <span class='k'>alpha_num_pool</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='k'>letters</span>,
                      <span class='k'>LETTERS</span>,
                      <span class='nf'><a href='https://rdrr.io/r/base/rep.html'>rep</a></span>(<span class='m'>0</span><span class='o'>:</span><span class='m'>9</span>, length.out = <span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span>(<span class='k'>letters</span>)<span class='o'>*</span><span class='m'>2</span>))
  
  <span class='k'>alpha_num_sample</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span>(x = <span class='k'>alpha_num_pool</span>,
                             size = <span class='k'>n</span>,
                             replace = <span class='kc'>TRUE</span>)
  
  <span class='k'>alpha_num_obj</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span>(<span class='k'>alpha_num_sample</span>,
                          collapse = <span class='s'>""</span>)
  
  <span class='kr'>if</span> (<span class='nf'><a href='https://rdrr.io/r/base/Logic.html'>isTRUE</a></span>(<span class='k'>save_clip</span>)) {
    <span class='nf'><a href='https://rdrr.io/r/base/message.html'>message</a></span>(<span class='s'>"writing key of length "</span>, <span class='k'>n</span>, <span class='s'>" to clipboard."</span>)
    <span class='k'>clipr</span>::<span class='nf'><a href='https://rdrr.io/pkg/clipr/man/write_clip.html'>write_clip</a></span>(<span class='k'>alpha_num_obj</span>)
  }
  
  <span class='nf'><a href='https://rdrr.io/r/base/function.html'>return</a></span>(<span class='k'>alpha_num_obj</span>)
  
}
</code></pre>

</div>

And here is the output:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>alpha_num</span>(<span class='m'>1</span>)

<span class='c'>#&gt; writing key of length 1 to clipboard.</span>

<span class='c'>#&gt; [1] "6"</span>

<span class='nf'>alpha_num</span>(<span class='m'>10</span>)

<span class='c'>#&gt; writing key of length 10 to clipboard.</span>

<span class='c'>#&gt; [1] "ojv1jonrvs"</span>
</code></pre>

</div>

Let's briefly break down each part of the function.

I want my key to be comprised of UPPERCASE, lowercase, and numbers.

So I create a vector with the R objects, `LETTERS`, and `letters` which contain the upper and lowercase alphabet. I also repeat the numbers 0 through to 9, and tell it to repeat the alphabet for twice the number of characters in the alphabet. This is so I get (somewhat) more equal representation of letters and numbers.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>alpha_num_pool</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='k'>letters</span>,
                   <span class='k'>LETTERS</span>,
                   <span class='nf'><a href='https://rdrr.io/r/base/rep.html'>rep</a></span>(<span class='m'>0</span><span class='o'>:</span><span class='m'>9</span>, length.out = <span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span>(<span class='k'>letters</span>)<span class='o'>*</span><span class='m'>2</span>))

<span class='k'>alpha_num_pool</span>

<span class='c'>#&gt;   [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r"</span>
<span class='c'>#&gt;  [19] "s" "t" "u" "v" "w" "x" "y" "z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J"</span>
<span class='c'>#&gt;  [37] "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "0" "1"</span>
<span class='c'>#&gt;  [55] "2" "3" "4" "5" "6" "7" "8" "9" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9"</span>
<span class='c'>#&gt;  [73] "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "1" "2" "3" "4" "5" "6" "7"</span>
<span class='c'>#&gt;  [91] "8" "9" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "0" "1"</span>
</code></pre>

</div>

Then I sample that pool, `n` times - for our example here we'll set n = 10

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>alpha_num_sample</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/sample.html'>sample</a></span>(x = <span class='k'>alpha_num_pool</span>,
                           <span class='c'># size = n,</span>
                           size = <span class='m'>10</span>,
                           replace = <span class='kc'>TRUE</span>)

<span class='k'>alpha_num_sample</span>

<span class='c'>#&gt;  [1] "5" "6" "0" "h" "H" "2" "4" "u" "H" "S"</span>
</code></pre>

</div>

Then we need to smush that together into one string, so we use `paste0` and set `collapse = ""`, which says: "collapse with no characters".

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>alpha_num_obj</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/paste.html'>paste0</a></span>(<span class='k'>alpha_num_sample</span>,
                        collapse = <span class='s'>""</span>)
<span class='k'>alpha_num_obj</span>

<span class='c'>#&gt; [1] "560hH24uHS"</span>
</code></pre>

</div>

Next we have this step that writes to clipboard. This asks, \"is `save_clip` TRUE? Then do the following. This uses `isTRUE`, which is a robust way of checking if something is TRUE - I don't think it is needed in this case, but I think it is good practice to use. It also reads better, I think.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'>if</span> (<span class='nf'><a href='https://rdrr.io/r/base/Logic.html'>isTRUE</a></span>(<span class='k'>save_clip</span>)) {
    <span class='nf'><a href='https://rdrr.io/r/base/message.html'>message</a></span>(<span class='s'>"writing key of length "</span>, <span class='k'>n</span>, <span class='s'>" to clipboard."</span>)
    <span class='k'>clipr</span>::<span class='nf'><a href='https://rdrr.io/pkg/clipr/man/write_clip.html'>write_clip</a></span>(<span class='k'>alpha_num_obj</span>)
  }
</code></pre>

</div>

Finally, we return the object:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/function.html'>return</a></span>(<span class='k'>alpha_num_obj</span>)
</code></pre>

</div>

This isn't strictly needed - a function will return whatever the last output is, but in this case it felt kind of right to me as there was this `if` statement section and I wanted to make it clear that the part of the function that returned data was the last part. Generally, `return` is best used when you need a part of a function to return an object early.

And yeah, that's it! Happy generating-alphabetical-numeric-strings!

