---
title: "{geotargets} 0.1.0"
date: '2024-05-27'
slug: geotargets-0-1-0
categories:
  - geospatial
  - rstats
  - targets
  - packages
aliases:
  - /post/2024/05/27/geotargets-0-1-0/
---

I'm very happy to announce [{geotargets}](https://njtierney.github.io/geotargets/) version 0.1.0! The [{geotargets}](https://njtierney.github.io/geotargets/) package extends [{targets}](https://docs.ropensci.org/targets/) to work with geospatial data formats. Version 0.1.0 supports [`terra::vect()`](https://rspatial.github.io/terra/reference/vect.html), [`terra::rast()`](https://rspatial.github.io/terra/reference/rast.html) and [`terra::sprc()`](https://rspatial.github.io/terra/reference/sprc.html) formats. This R package is only possible due to the great work by [Eric Scott](https://ericrscott.com/) and [Andrew Brown](https://humus.rocks/). While this blog post is on my website, I want to emphasise that this project is very much a team effort.

You can download [{geotargets}](https://njtierney.github.io/geotargets/) from the R universe like so:

``` r
install.packages("geotargets", repos = c("https://njtierney.r-universe.dev", "https://cran.r-project.org"))
```

# What is targets? Why do I need geotargets?

The targets package is an R package for managing analytic pipelines. It means that you can write out an analysis in a specific manner, and then as you update code, it will only rerun the necessary parts. Essentially it helps you avoid running large pieces of analysis when you don't need to. To learn more about targets, I'd highly recommend [reading the {targets} manual](https://books.ropensci.org/targets/).

Let's show an example. Let's say we want to get an example raster file from [{terra}](https://rspatial.github.io/terra/), we can do the following:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='nv'>terra_rast_example</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/system.file.html'>system.file</a></span><span class='o'>(</span></span>
<span>  <span class='s'>"ex/elev.tif"</span>, </span>
<span>  package <span class='o'>=</span> <span class='s'>"terra"</span></span>
<span>  <span class='o'>)</span> <span class='o'>|&gt;</span></span>
<span>  <span class='nf'>terra</span><span class='nf'>::</span><span class='nf'><a href='https://rspatial.github.io/terra/reference/rast.html'>rast</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span></span>
<span><span class='nv'>terra_rast_example</span></span>
<span><span class='c'>#&gt; class       : SpatRaster </span></span>
<span><span class='c'>#&gt; dimensions  : 90, 95, 1  (nrow, ncol, nlyr)</span></span>
<span><span class='c'>#&gt; resolution  : 0.008333333, 0.008333333  (x, y)</span></span>
<span><span class='c'>#&gt; extent      : 5.741667, 6.533333, 49.44167, 50.19167  (xmin, xmax, ymin, ymax)</span></span>
<span><span class='c'>#&gt; coord. ref. : lon/lat WGS 84 (EPSG:4326) </span></span>
<span><span class='c'>#&gt; source      : elev.tif </span></span>
<span><span class='c'>#&gt; name        : elevation </span></span>
<span><span class='c'>#&gt; min value   :       141 </span></span>
<span><span class='c'>#&gt; max value   :       547</span></span>
<span></span></code></pre>

</div>

Here is the equivalent code in a targets pipeline - the reason we want to use [{targets}](https://books.ropensci.org/targets/) here is we save the results so we don't need to run them again. In this case the example code doesn't take long to run. But imagine reading in the raster was hugely time and computer expensive and we didn't want to do it again. The [{targets}](https://books.ropensci.org/targets/) package stores the information so we can just read it back in later, and if we try and run the code again it will not update the code unless the data input has changed. Neat, right?

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://docs.ropensci.org/targets/'>targets</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_dir.html'>tar_dir</a></span><span class='o'>(</span><span class='o'>&#123;</span> <span class='c'># tar_dir() runs code from a temporary directory.</span></span>
<span>  <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_script.html'>tar_script</a></span><span class='o'>(</span><span class='o'>&#123;</span></span>
<span>    <span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://docs.ropensci.org/targets/'>targets</a></span><span class='o'>)</span></span>
<span>    <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span></span>
<span>      <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_target.html'>tar_target</a></span><span class='o'>(</span></span>
<span>        <span class='nv'>terra_rast_example</span>,</span>
<span>        <span class='nf'><a href='https://rdrr.io/r/base/system.file.html'>system.file</a></span><span class='o'>(</span><span class='s'>"ex/elev.tif"</span>, package <span class='o'>=</span> <span class='s'>"terra"</span><span class='o'>)</span> <span class='o'>|&gt;</span> <span class='nf'>terra</span><span class='nf'>::</span><span class='nf'><a href='https://rspatial.github.io/terra/reference/rast.html'>rast</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span>      <span class='o'>)</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>&#125;</span><span class='o'>)</span></span>
<span>  <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_make.html'>tar_make</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span>  <span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_read.html'>tar_read</a></span><span class='o'>(</span><span class='nv'>terra_rast_example</span><span class='o'>)</span></span>
<span>  <span class='nv'>x</span></span>
<span><span class='o'>&#125;</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>▶ dispatched target terra_rast_example</span></span></span>
<span><span class='c'><span style='color: #BB0000;'>#&gt; ● completed target terra_rast_example [1.196 seconds]</span></span></span>
<span><span class='c'><span style='color: #BB0000;'>#&gt; ▶ ended pipeline [1.825 seconds]</span></span></span>
<span><span class='c'><span style='color: #BB0000;'>#&gt; </span></span></span>
<span></span><span><span class='c'>#&gt; class       : SpatRaster</span></span>
<span></span><span><span class='c'>#&gt; Error: external pointer is not valid</span></span>
<span></span></code></pre>

</div>

We get an error!

    Error: external pointer is not valid

This is a relatively common gotcha moment when using libraries like [{terra}](https://rspatial.github.io/terra/). This is due to limitations with its underlying C++ implementation. There are specific ways to write and read these objects. See `?terra` for details.

But how do we use [{geotargets}](https://njtierney.github.io/geotargets/) to help with this? It helps handle these write and read steps, so you don't have to worry about them and can use targets as you are used to.

So instead of [`tar_target()`](https://docs.ropensci.org/targets/reference/tar_target.html), you use [`tar_terra_rast()`](https://njtierney.github.io/geotargets/reference/tar_terra_rast.html) to save a [{terra}](https://rspatial.github.io/terra/) raster:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://docs.ropensci.org/targets/'>targets</a></span><span class='o'>)</span></span>
<span><span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_dir.html'>tar_dir</a></span><span class='o'>(</span><span class='o'>&#123;</span> <span class='c'># tar_dir() runs code from a temporary directory.</span></span>
<span>  <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_script.html'>tar_script</a></span><span class='o'>(</span><span class='o'>&#123;</span></span>
<span>    <span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://docs.ropensci.org/targets/'>targets</a></span><span class='o'>)</span></span>
<span>    <span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/njtierney/geotargets'>geotargets</a></span><span class='o'>)</span></span>
<span>    <span class='nf'><a href='https://rdrr.io/r/base/list.html'>list</a></span><span class='o'>(</span></span>
<span>      <span class='nf'><a href='https://njtierney.github.io/geotargets/reference/tar_terra_rast.html'>tar_terra_rast</a></span><span class='o'>(</span></span>
<span>        <span class='nv'>terra_rast_example</span>,</span>
<span>        <span class='nf'><a href='https://rdrr.io/r/base/system.file.html'>system.file</a></span><span class='o'>(</span><span class='s'>"ex/elev.tif"</span>, package <span class='o'>=</span> <span class='s'>"terra"</span><span class='o'>)</span> <span class='o'>|&gt;</span> <span class='nf'>terra</span><span class='nf'>::</span><span class='nf'><a href='https://rspatial.github.io/terra/reference/rast.html'>rast</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span>      <span class='o'>)</span></span>
<span>    <span class='o'>)</span></span>
<span>  <span class='o'>&#125;</span><span class='o'>)</span></span>
<span>  <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_make.html'>tar_make</a></span><span class='o'>(</span><span class='o'>)</span></span>
<span>  <span class='nv'>x</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://docs.ropensci.org/targets/reference/tar_read.html'>tar_read</a></span><span class='o'>(</span><span class='nv'>terra_rast_example</span><span class='o'>)</span></span>
<span>  <span class='nv'>x</span></span>
<span><span class='o'>&#125;</span><span class='o'>)</span></span>
<span><span class='c'>#&gt; <span style='color: #BB0000;'>▶ dispatched target terra_rast_example</span></span></span>
<span><span class='c'><span style='color: #BB0000;'>#&gt; ● completed target terra_rast_example [0.006 seconds]</span></span></span>
<span><span class='c'><span style='color: #BB0000;'>#&gt; ▶ ended pipeline [0.061 seconds]</span></span></span>
<span><span class='c'><span style='color: #BB0000;'>#&gt; </span></span></span>
<span></span><span><span class='c'>#&gt; class       : SpatRaster </span></span>
<span><span class='c'>#&gt; dimensions  : 90, 95, 1  (nrow, ncol, nlyr)</span></span>
<span><span class='c'>#&gt; resolution  : 0.008333333, 0.008333333  (x, y)</span></span>
<span><span class='c'>#&gt; extent      : 5.741667, 6.533333, 49.44167, 50.19167  (xmin, xmax, ymin, ymax)</span></span>
<span><span class='c'>#&gt; coord. ref. : lon/lat WGS 84 (EPSG:4326) </span></span>
<span><span class='c'>#&gt; source      : terra_rast_example </span></span>
<span><span class='c'>#&gt; name        : elevation </span></span>
<span><span class='c'>#&gt; min value   :       141 </span></span>
<span><span class='c'>#&gt; max value   :       547</span></span>
<span></span></code></pre>

</div>

Similarly, there are [`tar_terra_vect()`](https://njtierney.github.io/geotargets/reference/tar_terra_vect.html) and [`tar_terra_sprc()`](https://njtierney.github.io/geotargets/reference/tar_terra_sprc.html) for dealing with vector (shapefile) and sprc (collections of rasters). See the [README example](https://github.com/njtierney/geotargets?tab=readme-ov-file#examples) for more information.

If you'd like to see these functions being used in a more practical context, see the [demo-geotargets](https://github.com/njtierney/demo-geotargets) repository.

# What's next?

We are actively developing [{geotargets}](https://njtierney.github.io/geotargets/), and the next release will focus on adding support for [splitting rasters into tiles](https://github.com/njtierney/geotargets/pull/76), [preserving SpatRaster metadata](https://github.com/njtierney/geotargets/pull/63), and adding [support for {stars}](https://github.com/njtierney/geotargets/pull/33). You can see the [full list of issues](https://github.com/njtierney/geotargets/issues) for more detail on what we are working on.

# Thanks

We have recently generously received support from the R Consortium for our project, ["{geotargets}: Enabling geospatial workflow management with {targets}"](https://github.com/cct-datascience/geotargets-isc-proposal), and so we would like to thank them for their support.

I'd also like to thank [Michael Sumner](https://github.com/mdsumner), [Anthony North](https://github.com/anthonynorth), and [Miles McBain](https://milesmcbain.xyz/) for their helpful discussions, as well as [Will Landau](https://wlandau.github.io/) for writing targets, and being incredibly responsive and helpful to the issues and questions we have asked as we wrote [{geotargets}](https://njtierney.github.io/geotargets/).

