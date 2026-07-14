---
title: "Rods Cones Colour Magik: What is Colourblindness?"
author: Nicholas Tierney
date: '2020-06-10'
slug: colourblind
categories:
  - data visualisation
  - rstats
draft: true
tags:
  - colour
  - colourblind
  - palettes
output: hugodown::md_document
rmd_hash: c0a186aedd625828

---

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>p_img</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>obj</span>, <span class='k'>nam</span>) {
  <span class='nf'><a href='https://rdrr.io/r/graphics/image.html'>image</a></span>(<span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span>(<span class='k'>obj</span>), <span class='m'>1</span>, <span class='nf'><a href='https://rdrr.io/r/base/matrix.html'>as.matrix</a></span>(<span class='m'>1</span><span class='o'>:</span><span class='nf'><a href='https://rdrr.io/r/base/length.html'>length</a></span>(<span class='k'>obj</span>)), col=<span class='k'>obj</span>, 
        main = <span class='k'>nam</span>, ylab = <span class='s'>""</span>, xaxt = <span class='s'>"n"</span>, yaxt = <span class='s'>"n"</span>,  bty = <span class='s'>"n"</span>)
}</code></pre>

</div>

This blog post is in a series about using and assessing good colours in R. This is part 1, which discusses colourblindness. Future parts will discuss how to create your own colour palettes and assess others. It draws from work done by [Kevin Wright in pals](), [Stefan]() and [Nathaniel Smith](), and implementations in a paper by Achim Zeil ...

What is colourblindness?
========================

tl;dr

> People with colourblindness might perceive some colours as the same, while those without colourblindness perceive them as different. This can be problematic for interpreting graphics. This difference is due to a biological difference in their eyes.

Simplifying things somewhat, let's talk briefly about anatomy.

Here's a side (sagittal) view eyeball and a retina, with some exaggerated rays of light going through the lens of the eye.

*shotty drawing of side view of the eye*

The retina is this layer of the eye that connects to light sensitive cells known as "rods and cones", called so because, well, they look like rods, and cones.

*shotty drawing of rods and cones*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/include_graphics.html'>include_graphics</a></span>(<span class='s'>"imgs/wiki-rod.png"</span>)
<span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/include_graphics.html'>include_graphics</a></span>(<span class='s'>"imgs/wiki-cone.png"</span>)
</code></pre>
<img src="imgs/wiki-rod.png" width="40%" style="display: block; margin: auto;" /><img src="imgs/wiki-cone.png" width="40%" style="display: block; margin: auto;" />

</div>

*Illustrations of [Rods](https://en.wikipedia.org/wiki/File:Cone2.svg) and [Cones](https://en.wikipedia.org/wiki/File:Cone_cell_eng.png), taken from from Wikipedia, Licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/deed.en).*

It's about 120 million rod cells to 6 to 7 million cone cells, about a 20:1 ratio.

Light comes in, and gets focussed by the lens onto a section of the eye called the *fovea*. Think of this like the bullseye on a target. It's the center of attention and has the most points. It represents the center of our focus.

*shotty drawing*

The fovea contains a crazy high concentration of cones. So the light hits these rods and cones, and then, after some certain amount of neurological magic (like the fact that the image is presented upside down but our brain flips it), we see an image in full colour.

*magic neurology*

*image presented*

Amazing.

So let's break down what makes up an image here. Let's first just look at a black and white view, where we see the intensity/brightness of the colour.

*Black and white image*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#&gt; Linking to ImageMagick 7.0.10.10</span>
<span class='c'>#&gt; Enabled features: freetype, ghostscript, lcms, webp</span>
<span class='c'>#&gt; Disabled features: cairo, fontconfig, fftw, pango, rsvg, x11</span></code></pre>

</div>

We add colour to the image using the cones in our eye. These react more to certain light wavelengths. You can think of these like "colour channels" of an image. Summing these together we end up at our previous image. We can actually separate the image into these channels, and represent the intensity of each of these colours, red, green, and blue:

<div class="highlight">

<img src="figs/image-channels-1.png" width="700px" style="display: block; margin: auto;" />

</div>

Initially I was expecting to just see only the literal colours, red, green, and blue - so while grayscale? This represents the chroma/saturation/intensity of that single colour. So really white means really read.

This might more sense seeing all of these together:

<div class="highlight">

<img src="figs/stack-all-1.png" width="700px" style="display: block; margin: auto;" />

</div>

There are three types of cones in the eye. They each activate more when they receive light of certain spectrum:

-   Red *red cone image*
-   Green *green cone image*
-   Blue *blue cone image*

These are more sensitive to each of these colour wavelengths:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/include_graphics.html'>include_graphics</a></span>(<span class='s'>"https://upload.wikimedia.org/wikipedia/commons/0/04/Cone-fundamentals-with-srgb-spectrum.svg"</span>)
</code></pre>
<img src="https://upload.wikimedia.org/wikipedia/commons/0/04/Cone-fundamentals-with-srgb-spectrum.svg" width="700px" style="display: block; margin: auto;" />

</div>

\[from <a href="https://en.wikipedia.org/wiki/Cone_cell" class="uri">https://en.wikipedia.org/wiki/Cone_cell</a>\]

> Normalized responsivity spectra of human cone cells, S, M, and L types

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>read_tidy_photowave</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>path</span>){
  <span class='k'>readr</span>::<span class='nf'><a href='https://readr.tidyverse.org/reference/read_delim.html'>read_csv</a></span>(file = <span class='k'>path</span>,
                  col_names = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='s'>"wavelength_nm"</span>,
                                <span class='s'>"cone_s"</span>,
                                <span class='s'>"cone_m"</span>,
                                <span class='s'>"cone_l"</span>)) <span class='o'>%&gt;%</span> 
  <span class='k'>tidyr</span>::<span class='nf'><a href='https://tidyr.tidyverse.org/reference/pivot_longer.html'>pivot_longer</a></span>(cols = <span class='k'>cone_s</span><span class='o'>:</span><span class='k'>cone_l</span>,
                      names_to = <span class='s'>"type"</span>,
                      values_to = <span class='s'>"response"</span>)
}

<span class='c'># data provided from http://cvrl.ucl.ac.uk/cones.htm</span>
<span class='c'># 10-deg fundamentals based on the Stiles &amp; Burch 10-deg CMFs</span>
  <span class='c'># units: energy (linear)</span>
  <span class='c'># stepsize: 0.1 nm</span>
  <span class='c'># Format: csv</span>

<span class='k'>cone_response</span> <span class='o'>&lt;-</span> <span class='nf'>read_tidy_photowave</span>(
  <span class='k'>here</span>::<span class='nf'><a href='https://rdrr.io/pkg/here/man/here.html'>here</a></span>(<span class='s'>"content/post/drafts/2020-06-10-what-is-colourblindness/data/linss2_10e_fine.csv"</span>)
)
<span class='c'>#&gt; Parsed with column specification:</span>
<span class='c'>#&gt; cols(</span>
<span class='c'>#&gt;   wavelength_nm = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   cone_s = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   cone_m = <span style='color: #00BB00;'>col_double()</span><span>,</span></span>
<span class='c'>#&gt;   cone_l = <span style='color: #00BB00;'>col_double()</span></span>
<span class='c'>#&gt; )</span></code></pre>

</div>

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Attaching packages</span><span> ───────────────────────────── tidyverse 1.3.0 ──</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.0     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>✔</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>
<span class='c'>#&gt; ── <span style='font-weight: bold;'>Conflicts</span><span> ──────────────────────────────── tidyverse_conflicts() ──</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>✖</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://docs.r4photobiology.info/ggspectra'>ggspectra</a></span>)
<span class='c'>#&gt; Loading required package: photobiology</span>
<span class='c'>#&gt; News at https://www.r4photobiology.info/</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'photobiology'</span>
<span class='c'>#&gt; The following object is masked from 'package:tidyr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     spread</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://scales.r-lib.org'>scales</a></span>)
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'scales'</span>
<span class='c'>#&gt; The following object is masked from 'package:purrr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     discard</span>
<span class='c'>#&gt; The following object is masked from 'package:readr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     col_factor</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://docs.r4photobiology.info/photobiology'>photobiology</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://docs.r4photobiology.info/photobiologyWavebands'>photobiologyWavebands</a></span>)

<span class='k'>gg_cone_receptor</span> <span class='o'>&lt;-</span> <span class='nf'>function</span>(<span class='k'>cone_response</span>){
<span class='nf'><a href='https://docs.r4photobiology.info/ggspectra//reference/ggplot.html'>ggplot</a></span>(<span class='k'>cone_response</span>,
       <span class='nf'>aes</span>(x = <span class='k'>wavelength_nm</span>,
           y = <span class='k'>response</span>,
           group = <span class='k'>type</span>)) <span class='o'>+</span> 
  <span class='nf'><a href='https://docs.r4photobiology.info/ggspectra//reference/stat_wl_strip.html'>wl_guide</a></span>(chroma.type = <span class='s'>"CMF"</span>) <span class='o'>+</span>
  <span class='nf'>geom_line</span>(colour = <span class='s'>"white"</span>, size = <span class='m'>0.75</span>) <span class='o'>+</span>
  <span class='nf'>scale_x_continuous</span>(limits = <span class='nf'><a href='https://docs.r4photobiology.info/photobiology//reference/c.html'>c</a></span>(<span class='m'>390</span>, <span class='m'>710</span>), 
                     expand = <span class='nf'><a href='https://docs.r4photobiology.info/photobiology//reference/c.html'>c</a></span>(<span class='m'>0</span>, <span class='m'>0</span>),
                     breaks = <span class='k'>scales</span>::<span class='nf'><a href='https://scales.r-lib.org//reference/breaks_width.html'>breaks_width</a></span>(<span class='m'>25</span>)) <span class='o'>+</span>
    <span class='nf'>labs</span>(x = <span class='s'>"Wavelength (nm)"</span>,
         y = <span class='s'>"Normalised cone response (linear energy)"</span>)
}

<span class='k'>cone_response</span> <span class='o'>%&gt;%</span> <span class='nf'>gg_cone_receptor</span>()
<span class='c'>#&gt; Warning: Removed 4550 row(s) containing missing values (geom_path).</span>
</code></pre>
<img src="figs/unnamed-chunk-2-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>cone_response</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>type</span> <span class='o'>==</span> <span class='s'>"cone_s"</span>) <span class='o'>%&gt;%</span>  <span class='nf'>gg_cone_receptor</span>()
<span class='c'>#&gt; Warning: Removed 1200 row(s) containing missing values (geom_path).</span>
</code></pre>
<img src="figs/unnamed-chunk-2-2.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>cone_response</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>type</span> <span class='o'>==</span> <span class='s'>"cone_m"</span>) <span class='o'>%&gt;%</span>  <span class='nf'>gg_cone_receptor</span>()
<span class='c'>#&gt; Warning: Removed 1200 row(s) containing missing values (geom_path).</span>
</code></pre>
<img src="figs/unnamed-chunk-2-3.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>cone_response</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>type</span> <span class='o'>==</span> <span class='s'>"cone_l"</span>) <span class='o'>%&gt;%</span>  <span class='nf'>gg_cone_receptor</span>()
<span class='c'>#&gt; Warning: Removed 2150 row(s) containing missing values (geom_path).</span>
</code></pre>
<img src="figs/unnamed-chunk-2-4.png" width="700px" style="display: block; margin: auto;" />

</div>

Image inspired by [figure of responsivity of human eye from Wikipedia](https://en.wikipedia.org/wiki/File:Cone-fundamentals-with-srgb-spectrum.svg), data extracted from [Colour & Vision Research laboratory at UCL's](http://cvrl.ucl.ac.uk) section on [cones](http://cvrl.ucl.ac.uk/cones.htm).

colourblindness (generally) comes from an absence, or reduction in sensitivity of the cones in the eye.

Depending on which cones are missing, this means some sets of colours are indistinguishable from one another. It affects up to 10% of males of European descent, and 1 in 200 women (REF).

So, why does it matter?

Well let's say you have two colours, red and green. Here is what non-colourblind people see:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>red_green</span> <span class='o'>&lt;-</span> <span class='k'>prismatic</span>::<span class='nf'><a href='https://rdrr.io/pkg/prismatic/man/color.html'>colour</a></span>(<span class='nf'><a href='https://docs.r4photobiology.info/photobiology//reference/c.html'>c</a></span>(<span class='s'>"red"</span>, <span class='s'>"darkgreen"</span>))
<span class='nf'>p_img</span>(<span class='k'>red_green</span>, <span class='s'>"Red &amp; Green"</span>)
</code></pre>
<img src="figs/plot-red-green-1.png" width="700px" style="display: block; margin: auto;" />

</div>

But if you have colourblindness, you will likely see something like the following:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>red_green_dt</span> <span class='o'>&lt;-</span> <span class='k'>colorspace</span>::<span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>deutan</a></span>(<span class='k'>red_green</span>)
<span class='k'>red_green_pt</span> <span class='o'>&lt;-</span> <span class='k'>colorspace</span>::<span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>protan</a></span>(<span class='k'>red_green</span>)
<span class='k'>red_green_tt</span> <span class='o'>&lt;-</span> <span class='k'>colorspace</span>::<span class='nf'><a href='http://colorspace.R-Forge.R-project.org//reference/simulate_cvd.html'>tritan</a></span>(<span class='k'>red_green</span>)

<span class='nf'>p_img</span>(<span class='k'>red_green_dt</span>, <span class='s'>"Red &amp; Green at Deutan"</span>)
</code></pre>
<img src="figs/unnamed-chunk-3-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>p_img</span>(<span class='k'>red_green_pt</span>, <span class='s'>"Red &amp; Green at Protan"</span>)
</code></pre>
<img src="figs/unnamed-chunk-3-2.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>p_img</span>(<span class='k'>red_green_tt</span>, <span class='s'>"Red &amp; Green at Tritan"</span>)
</code></pre>
<img src="figs/unnamed-chunk-3-3.png" width="700px" style="display: block; margin: auto;" />

</div>

This is why traffic lights have position markings, instead of just the same position changing colour.

*gif of good traffic light for different vision*

vs

*gif of bad traffic light with different vision*

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>traffic</span> <span class='o'>&lt;-</span> <span class='nf'>image_read_svg</span>(
  <span class='k'>here</span>::<span class='nf'><a href='https://rdrr.io/pkg/here/man/here.html'>here</a></span>(<span class='s'>"content/post/drafts/2020-06-10-what-is-colourblindness/imgs/traffic-light.svg"</span>)
)

<span class='k'>red_light</span> <span class='o'>&lt;-</span> <span class='k'>traffic</span> <span class='o'>%&gt;%</span> <span class='nf'>image_crop</span>(<span class='s'>"275x230 + 0 + 29"</span>)
<span class='k'>amber_light</span> <span class='o'>&lt;-</span> <span class='k'>traffic</span> <span class='o'>%&gt;%</span> <span class='nf'>image_crop</span>(<span class='s'>"275x230 + 0 + 260"</span>)
<span class='k'>green_light</span> <span class='o'>&lt;-</span> <span class='k'>traffic</span> <span class='o'>%&gt;%</span> <span class='nf'>image_crop</span>(<span class='s'>"275x230 + 0 + 491"</span>)

<span class='c'># colorspace::cvd_emulator(here::here("content/post/drafts/2020-06-10-what-is-colourblindness/imgs/traffic-light.jpeg"))</span>

<span class='k'>traffic_deutan</span> <span class='o'>&lt;-</span> <span class='nf'>image_read</span>(
  <span class='k'>here</span>::<span class='nf'><a href='https://rdrr.io/pkg/here/man/here.html'>here</a></span>(<span class='s'>"content/post/drafts/2020-06-10-what-is-colourblindness/imgs/deutan_traffic-light.jpeg"</span>)
)
<span class='k'>traffic_protan</span> <span class='o'>&lt;-</span> <span class='nf'>image_read</span>(
  <span class='k'>here</span>::<span class='nf'><a href='https://rdrr.io/pkg/here/man/here.html'>here</a></span>(<span class='s'>"content/post/drafts/2020-06-10-what-is-colourblindness/imgs/protan_traffic-light.jpeg"</span>)
)
<span class='k'>traffic_tritan</span> <span class='o'>&lt;-</span> <span class='nf'>image_read</span>(
  <span class='k'>here</span>::<span class='nf'><a href='https://rdrr.io/pkg/here/man/here.html'>here</a></span>(<span class='s'>"content/post/drafts/2020-06-10-what-is-colourblindness/imgs/tritan_traffic-light.jpeg"</span>)
)

<span class='k'>traffic_deutan</span> <span class='o'>%&gt;%</span> <span class='nf'>image_annotate</span>(text = <span class='s'>"Deutan"</span>, 
                                  color = <span class='s'>"white"</span>,
                                  gravity = <span class='s'>"south"</span>,
                                  size = <span class='m'>20</span>)
</code></pre>
<img src="figs/unnamed-chunk-4-1.png" width="700px" style="display: block; margin: auto;" />
<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='nf'>image_append</span>(<span class='nf'><a href='https://docs.r4photobiology.info/photobiology//reference/c.html'>c</a></span>(<span class='k'>traffic</span>,
               <span class='k'>traffic_deutan</span>,
               <span class='k'>traffic_protan</span>,
               <span class='k'>traffic_tritan</span>))
</code></pre>
<img src="figs/unnamed-chunk-4-2.png" width="700px" style="display: block; margin: auto;" />

</div>

So the point here is:

> Some colours cannot be distinguished by those with colourblindness, so we need to be careful how we present colour, and what colours we present.

Fin
===

The next blog post will go into details

Further Reading
---------------

-   Achim's paper
-   Radiolab episiode on mantis shrimp
-   <a href="https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html" class="uri">https://cran.r-project.org/web/packages/viridis/vignettes/intro-to-viridis.html</a>
-   <a href="https://www.imagemagick.org/Usage/color_basics/" class="uri">https://www.imagemagick.org/Usage/color_basics/</a>
-   <a href="https://cran.r-project.org/web/packages/ggspectra/vignettes/userguide1-grammar.html" class="uri">https://cran.r-project.org/web/packages/ggspectra/vignettes/userguide1-grammar.html</a>

