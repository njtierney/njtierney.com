---
title: How to Cite R Packages Like R Markdown
date: '2021-03-19'
slug: cite-r-pkgs
categories:
  - rstats
  - rmarkdown
  - citation
  - bibtex
aliases:
  - /post/2021/03/19/cite-r-pkgs/
---

A friend recently asked me how to cite the R package, "rmarkdown" in their work. Here is how to do just that!

You can get the information straight from R, like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/utils/citation.html'>citation</a></span><span class='o'>(</span><span class='s'>"rmarkdown"</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; To cite the 'rmarkdown' package in publications, please use:</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   JJ Allaire and Yihui Xie and Jonathan McPherson and Javier Luraschi</span>
<span class='c'>#&gt;   and Kevin Ushey and Aron Atkins and Hadley Wickham and Joe Cheng and</span>
<span class='c'>#&gt;   Winston Chang and Richard Iannone (2021). rmarkdown: Dynamic</span>
<span class='c'>#&gt;   Documents for R. R package version 2.7. URL</span>
<span class='c'>#&gt;   https://rmarkdown.rstudio.com.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Yihui Xie and J.J. Allaire and Garrett Grolemund (2018). R Markdown:</span>
<span class='c'>#&gt;   The Definitive Guide. Chapman and Hall/CRC. ISBN 9781138359338. URL</span>
<span class='c'>#&gt;   https://bookdown.org/yihui/rmarkdown.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Yihui Xie and Christophe Dervieux and Emily Riederer (2020). R</span>
<span class='c'>#&gt;   Markdown Cookbook. Chapman and Hall/CRC. ISBN 9780367563837. URL</span>
<span class='c'>#&gt;   https://bookdown.org/yihui/rmarkdown-cookbook.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; To see these entries in BibTeX format, use 'print(&lt;citation&gt;,</span>
<span class='c'>#&gt; bibtex=TRUE)', 'toBibtex(.)', or set</span>
<span class='c'>#&gt; 'options(citation.bibtex.max=999)'.</span></code></pre>

</div>

This provides you with the citation as you might have in the final body of text.

And if you use BibTex to manage your citations you can do the following (as it hints to in the previous output):

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/print.html'>print</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/utils/citation.html'>citation</a></span><span class='o'>(</span><span class='s'>"rmarkdown"</span><span class='o'>)</span>, bibtex <span class='o'>=</span> <span class='kc'>TRUE</span><span class='o'>)</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; To cite the 'rmarkdown' package in publications, please use:</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   JJ Allaire and Yihui Xie and Jonathan McPherson and Javier Luraschi</span>
<span class='c'>#&gt;   and Kevin Ushey and Aron Atkins and Hadley Wickham and Joe Cheng and</span>
<span class='c'>#&gt;   Winston Chang and Richard Iannone (2021). rmarkdown: Dynamic</span>
<span class='c'>#&gt;   Documents for R. R package version 2.7. URL</span>
<span class='c'>#&gt;   https://rmarkdown.rstudio.com.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; A BibTeX entry for LaTeX users is</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   @Manual&#123;,</span>
<span class='c'>#&gt;     title = &#123;rmarkdown: Dynamic Documents for R&#125;,</span>
<span class='c'>#&gt;     author = &#123;JJ Allaire and Yihui Xie and Jonathan McPherson and Javier Luraschi and Kevin Ushey and Aron Atkins and Hadley Wickham and Joe Cheng and Winston Chang and Richard Iannone&#125;,</span>
<span class='c'>#&gt;     year = &#123;2021&#125;,</span>
<span class='c'>#&gt;     note = &#123;R package version 2.7&#125;,</span>
<span class='c'>#&gt;     url = &#123;https://github.com/rstudio/rmarkdown&#125;,</span>
<span class='c'>#&gt;   &#125;</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Yihui Xie and J.J. Allaire and Garrett Grolemund (2018). R Markdown:</span>
<span class='c'>#&gt;   The Definitive Guide. Chapman and Hall/CRC. ISBN 9781138359338. URL</span>
<span class='c'>#&gt;   https://bookdown.org/yihui/rmarkdown.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; A BibTeX entry for LaTeX users is</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   @Book&#123;,</span>
<span class='c'>#&gt;     title = &#123;R Markdown: The Definitive Guide&#125;,</span>
<span class='c'>#&gt;     author = &#123;Yihui Xie and J.J. Allaire and Garrett Grolemund&#125;,</span>
<span class='c'>#&gt;     publisher = &#123;Chapman and Hall/CRC&#125;,</span>
<span class='c'>#&gt;     address = &#123;Boca Raton, Florida&#125;,</span>
<span class='c'>#&gt;     year = &#123;2018&#125;,</span>
<span class='c'>#&gt;     note = &#123;ISBN 9781138359338&#125;,</span>
<span class='c'>#&gt;     url = &#123;https://bookdown.org/yihui/rmarkdown&#125;,</span>
<span class='c'>#&gt;   &#125;</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Yihui Xie and Christophe Dervieux and Emily Riederer (2020). R</span>
<span class='c'>#&gt;   Markdown Cookbook. Chapman and Hall/CRC. ISBN 9780367563837. URL</span>
<span class='c'>#&gt;   https://bookdown.org/yihui/rmarkdown-cookbook.</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt; A BibTeX entry for LaTeX users is</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   @Book&#123;,</span>
<span class='c'>#&gt;     title = &#123;R Markdown Cookbook&#125;,</span>
<span class='c'>#&gt;     author = &#123;Yihui Xie and Christophe Dervieux and Emily Riederer&#125;,</span>
<span class='c'>#&gt;     publisher = &#123;Chapman and Hall/CRC&#125;,</span>
<span class='c'>#&gt;     address = &#123;Boca Raton, Florida&#125;,</span>
<span class='c'>#&gt;     year = &#123;2020&#125;,</span>
<span class='c'>#&gt;     note = &#123;ISBN 9780367563837&#125;,</span>
<span class='c'>#&gt;     url = &#123;https://bookdown.org/yihui/rmarkdown-cookbook&#125;,</span>
<span class='c'>#&gt;   &#125;</span></code></pre>

</div>

And then you can copy and paste this into your .bibtex file.

How to customise your own citations
===================================

You can create your own custom way to cite your R package by adding a CITATION file in your inst directory [like so](https://github.com/ropensci/visdat/blob/master/inst/CITATION). Which reminds me, I've got to do this for my R package, naniar...

Post script: A thought/issue on automating clipboards.
======================================================

I normally use the [`clipr`](https://github.com/mdlincoln/clipr) package by [Matthew Lincoln](https://matthewlincoln.net/) to save R output to the clipboard, but in this case it didn't quite work, as this, returned:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='kr'><a href='https://rdrr.io/r/base/library.html'>library</a></span><span class='o'>(</span><span class='nv'><a href='https://github.com/mdlincoln/clipr'>clipr</a></span><span class='o'>)</span>
<span class='nf'><a href='https://rdrr.io/pkg/clipr/man/write_clip.html'>write_clip</a></span><span class='o'>(</span><span class='nf'><a href='https://rdrr.io/r/utils/citation.html'>citation</a></span><span class='o'>(</span><span class='s'>"rmarkdown"</span><span class='o'>)</span><span class='o'>)</span></code></pre>

</div>

    Warning message:
    In flat_str(content, breaks) : Coercing content to character

And then this as the output:

    list(title = "rmarkdown: Dynamic Documents for R", author = list(list(given = "JJ", family = "Allaire", role = NULL, email = NULL, comment = NULL), list(given = "Yihui", family = "Xie", role = NULL, email = NULL, comment = NULL), list(given = "Jonathan", family = "McPherson", role = NULL, email = NULL, comment = NULL), list(given = "Javier", family = "Luraschi", role = NULL, email = NULL, comment = NULL), list(given = "Kevin", family = "Ushey", role = NULL, email = NULL, comment = NULL), list(given = "Aron", 
        family = "Atkins", role = NULL, email = NULL, comment = NULL), list(given = "Hadley", family = "Wickham", role = NULL, email = NULL, comment = NULL), list(given = "Joe", family = "Cheng", role = NULL, email = NULL, comment = NULL), list(given = "Winston", family = "Chang", role = NULL, email = NULL, comment = NULL), list(given = "Richard", family = "Iannone", role = NULL, email = NULL, comment = NULL)), year = "2021", note = "R package version 2.7", url = "https://github.com/rstudio/rmarkdown")
    list(title = "R Markdown: The Definitive Guide", author = list(list(given = "Yihui", family = "Xie", role = NULL, email = NULL, comment = NULL), list(given = "J.J.", family = "Allaire", role = NULL, email = NULL, comment = NULL), list(given = "Garrett", family = "Grolemund", role = NULL, email = NULL, comment = NULL)), publisher = "Chapman and Hall/CRC", address = "Boca Raton, Florida", year = "2018", note = "ISBN 9781138359338", url = "https://bookdown.org/yihui/rmarkdown")
    list(title = "R Markdown Cookbook", author = list(list(given = "Yihui", family = "Xie", role = NULL, email = NULL, comment = NULL), list(given = "Christophe", family = "Dervieux", role = NULL, email = NULL, comment = NULL), list(given = "Emily", family = "Riederer", role = NULL, email = NULL, comment = NULL)), publisher = "Chapman and Hall/CRC", address = "Boca Raton, Florida", year = "2020", note = "ISBN 9780367563837", url = "https://bookdown.org/yihui/rmarkdown-cookbook")

I'm not sure how to get around this, but I'm probably missing something obvious, if there are any suggestions, I'm all ears!

