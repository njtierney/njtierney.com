---
title: Quickly Assessing Colour Palettes
date: '2020-10-15'
slug: assess-colour
categories:
  - data visualisation
  - colour palette
  - rstats
aliases:
  - /post/2020/10/15/assess-colour/
---

You want to use a nice colour palette but you're not sure if it's colour blind friendly? Here are some quick ways to check this in \#rstats.

Using prismatic
===============

The [prismatic](https://github.com/EmilHvitfeldt/prismatic) package by [Emil Hvitfeldt](https://github.com/EmilHvitfeldt) provides some nice approaches to this with the function [`check_color_blindness()`](https://rdrr.io/pkg/prismatic/man/check_color_blindness.html). You provide a vector of colour codes, and it simulates how they appear for people with different types of colourblindness.

For example, we can check the "Cold" palette from the `qualitative_chl` colour palette from [colorspace](https://colorspace.r-forge.r-project.org/index.html) by [Achim Zeileis](https://eeecon.uibk.ac.at/~zeileis/) and co, like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://colorspace.R-Forge.R-project.org'>colorspace</a></span>)
<span class='k'>hcl_cold</span> <span class='o'>&lt;-</span> 
<span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/hcl_palettes.html'>qualitative_hcl</a></span>(n = <span class='m'>3</span>,
                palette = <span class='s'>"Cold"</span>)

<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/EmilHvitfeldt/prismatic'>prismatic</a></span>)
<span class='nf'><a href='https://rdrr.io/pkg/prismatic/man/check_color_blindness.html'>check_color_blindness</a></span>(<span class='k'>hcl_cold</span>)

</code></pre>
<img src="figs/example-1.png" width="700px" style="display: block; margin: auto;" />

</div>

But what if you want to check a few palettes in quicker succession? I used a function like this to help. First, getting a handle on what qualitative colour palettes are available:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>hcl_pals_q</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/hcl_palettes.html'>hcl_palettes</a></span>(type = <span class='s'>"qualitative"</span>)
<span class='k'>hcl_pals_q</span>

<span class='c'>#&gt; HCL palettes</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Type:  Qualitative </span>
<span class='c'>#&gt; Names: Pastel 1, Dark 2, Dark 3, Set 2, Set 3, Warm, Cold, Harmonic, Dynamic</span>
</code></pre>

</div>

Then writing a function to pick three colours. I also needed a specific alpha level of 0.67, but that was just me. I called it `qual_cvd` because it assesses qualitative colour palettes for colour vision deficiency (CVD).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'>magrittr</span>)
<span class='k'>qual_cvd</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>palette</span> = <span class='s'>"Pastel1"</span>, <span class='k'>alpha</span> = <span class='m'>0.67</span>){
  <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/hcl_palettes.html'>qualitative_hcl</a></span>(n = <span class='m'>3</span>,
                  alpha = <span class='k'>alpha</span>,
                  palette = <span class='k'>palette</span>)  <span class='o'>%&gt;%</span> 
    <span class='nf'><a href='https://rdrr.io/pkg/prismatic/man/check_color_blindness.html'>check_color_blindness</a></span>()
}
</code></pre>

</div>

Then we can demonstrate it like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>qual_cvd</span>(<span class='s'>"Dark 2"</span>)

</code></pre>
<img src="figs/demo-check-cvd-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>qual_cvd</span>(<span class='s'>"Dark 3"</span>)

</code></pre>
<img src="figs/demo-check-cvd-2.png" width="700px" style="display: block; margin: auto;" />

</div>

Looks like Dark 3 is a good one!

Using colorspace
================

The `colorspace` package provides some really nice functions for exploring CVD.

One thing I really love here is the `demoplot` function, which provides an example of what a plot might look like with a given colour palette. For example:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/hcl_palettes.html'>qualitative_hcl</a></span>(n = <span class='m'>3</span>,
                alpha = <span class='m'>0.67</span>,
                palette = <span class='s'>"Cold"</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/demoplot.html'>demoplot</a></span>(type = <span class='s'>"map"</span>)

</code></pre>
<img src="figs/qual-demoplot-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There are many other plot types you can choose from, ("map", "heatmap", "scatter", "spine", "bar", "pie", "perspective", "mosaic", and "lines").

You can combine your returned colour hex codes with the [`protan()`](http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html), [`deutan()`](http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html), and [`tritan()`](http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html) functions to simulate a particular type of CVD. For example, convert the colours into protanopia:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/hcl_palettes.html'>qualitative_hcl</a></span>(n = <span class='m'>3</span>,
                alpha = <span class='m'>0.67</span>,
                palette = <span class='s'>"Cold"</span>) <span class='o'>%&gt;%</span> 
  <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>protan</a></span>()

<span class='c'>#&gt; [1] "#98ABE5AB" "#A4AECDAB" "#B7AD90AB"</span>
</code></pre>

</div>

Let's wrap this up into a function to return the colour palettes as a list.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>qual_return_cvd</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>palette</span> = <span class='s'>"Cold"</span>, 
                            <span class='k'>alpha</span> = <span class='m'>0.67</span>){
  <span class='k'>pals</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/hcl_palettes.html'>qualitative_hcl</a></span>(n = <span class='m'>3</span>,
                          alpha = <span class='k'>alpha</span>,
                          palette = <span class='k'>palette</span>)
  <span class='k'>pals_protan</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>protan</a></span>(<span class='k'>pals</span>)
  <span class='k'>pals_deutan</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>deutan</a></span>(<span class='k'>pals</span>)
  <span class='k'>pals_tritan</span> <span class='o'>&lt;-</span> <span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>tritan</a></span>(<span class='k'>pals</span>)
  
  <span class='nf'><a href='https://rdrr.io/r/base/function.html'>return</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span>(
    protan = <span class='k'>pals_protan</span>,
    deutan = <span class='k'>pals_deutan</span>,
    tritan = <span class='k'>pals_tritan</span>
    ))
}
<span class='nf'>qual_return_cvd</span>()

<span class='c'>#&gt; $protan</span>
<span class='c'>#&gt; [1] "#98ABE5AB" "#A4AECDAB" "#B7AD90AB"</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $deutan</span>
<span class='c'>#&gt; [1] "#98A9DFAB" "#8C9BCCAB" "#A39F94AB"</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; $tritan</span>
<span class='c'>#&gt; [1] "#A2ACB6AB" "#2CC4BEAB" "#4ABEAFAB"</span>
</code></pre>

</div>

Why return a list? Then we can use [`purrr::walk()`](https://purrr.tidyverse.org/reference/map.html) to iterate over it ([`purrr::map()`](https://purrr.tidyverse.org/reference/map.html) also works, but we just want the side effect, the plot, so walk is fine here).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>qual_return_cvd</span>() <span class='o'>%&gt;%</span>  <span class='k'>purrr</span>::<span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>walk</a></span>(<span class='k'>demoplot</span>)

</code></pre>
<img src="figs/walk-cvd-1.png" width="700px" style="display: block; margin: auto;" /><img src="figs/walk-cvd-2.png" width="700px" style="display: block; margin: auto;" /><img src="figs/walk-cvd-3.png" width="700px" style="display: block; margin: auto;" />

</div>

Hmm, Ok, so not the best, let's try dark 3 again

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>qual_return_cvd</span>(palette = <span class='s'>"Dark 3"</span>) <span class='o'>%&gt;%</span>  <span class='k'>purrr</span>::<span class='nf'><a href='https://purrr.tidyverse.org/reference/map.html'>walk</a></span>(<span class='k'>demoplot</span>)

</code></pre>
<img src="figs/walk-cvd-dark-1.png" width="700px" style="display: block; margin: auto;" /><img src="figs/walk-cvd-dark-2.png" width="700px" style="display: block; margin: auto;" /><img src="figs/walk-cvd-dark-3.png" width="700px" style="display: block; margin: auto;" />

</div>

We get much better separation between the colours, so I think I'd go with "Dark 3".

What is really lovely about the `demoplot` function is that you can get a quick sense of what your selected palette might look like for a given type of plot, without needing to go to the hassle of putting it through your data. This quick iteration is really key, I think.

End
===

There is *always* more to talk about when it comes to colours, and this is just a short post on the topic - I've left a lot out of it, otherwise it wouldn't ever get finished! I do have an upcoming in depth blog post series I've been working on that explains the details of what colour blindness is, but it has been a work in progress for about a year. So, I figured I'd rather get this post out quickly and keep it brief.

If you'd like to learn more about colour blindness in graphics, I gave a talk at Monash Data Fluency about this earlier this year, entitled, "The Use of Colour in Graphics" [slides and materials are available here](https://github.com/njtierney/monash-colour-in-graphics), which also has some nice resources provided on where you can learn more.

