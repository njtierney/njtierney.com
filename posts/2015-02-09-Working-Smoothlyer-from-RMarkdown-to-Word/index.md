---
title: Working Smoothly(er) from RMarkdown to Word.
date: "2015-02-09"
categories:
- rmarkdown
- rstats
slug: smoothlyer-rmd-docx
aliases:
  - /post/2015/02/09/smoothlyer-rmd-docx/
---

I'm a pretty huge fan of RMarkdown, as it is a great way for me to write my code and my text together. It seems really a rather a natural thing to do. You write about your analyses, and the code is there. You update some function or some data, and your figures and tables update with it.

In my head I feel as though I am working more efficiently. However there is some research to suggest that LaTeX users actually work slower than Word users. However, LaTeX users _feel better_ about using LaTeX. I would like to dub this the **brown corduroy trousers effect**, quoting Robin Williams, who said something like:

> Method Acting is like peeing whilst wearing brown corduroy trousers. Nobody knows the difference but it sure as hell feels nice.

Anyway. I started to use knitr to process my work documents at the end of 2013, specifically using the LaTeX formatting. Which made me feel good.

Then I switched to Rmarkdown after a conversation with Hadley Wickham at a Young Statisticians Dinner at the Australian Statisticians Conference in Sydney, in 2014. Amongst other things "Have you seen [dplyr?](http://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html) and ["read this book!"](http://www.amazon.com/Style-Clarity-Chicago-Writing-Publishing/dp/0226899152). Hadley told me that he uses RMarkdown almost exclusively now, not really going back to the .Rnw knitr LaTeX files. He also said that there's a button that will convert it to LaTeX style and also ... get this... to microsoft word.

Converting to word documents is really awesome, because my supervisors often prefer to read and edit my papers in word. Knitr does a really good job of putting everything from RMarkdown into Word, but it doesn't do everything that I'd like. I usually spend 1 or 2 minutes changing the font and line spacing and inserting page numbers. Then I spend anywhere from 2 to 15 minutes manually resizing images. Painful. But every time I did it, I would always think:

> It's just this once...

And then I would think:

> Maybe there's a way to get R to do all this for me?

But I assumed that would be more effort than it was worth.

Well, tonight I cracked, and went googling for how to fix this problem. It turns out that this was a royal pain the arse.

<a href="http://stackoverflow.com/questions/18884778/poor-resolution-in-knitr-using-rmd">I tried this solution.</a>

Both didn't really work.

So then I then tried to solve this problem using a macro in word.

I've never _touched_ macros in Word. They always seemed weird and odd to me. Regardless, in I went to the macro editor. I hit the record button, and did all of the font changes, colour changes, and spacing changes I always do. Then I saved this macro.

Then I went on to find a way to change the image sizes. I took a wrong turn into a [blog that had me developing a GUI](https://cybertext.wordpress.com/2014/02/07/word-resize-all-images-in-a-document-to-the-same-width/)...which didn't end up working for me. There's 30 minutes I won't be getting back. But then I found this [snippet of code](http://yuriy-okhmat.blogspot.co.uk/2011/07/how-to-resize-all-images-in-word.html) snippet of code, which resizes everything to 16 cm, maintaining the aspect ratio.

I created a new macro from scratch and pasted this code in. Boom! Another Macro is born. Then I finished this up by creating a macro that recorded me running those two macros. Not elegant, but effective.

So, total time expended screwing around and making this macro? 2 Hours.

Total time saved? 15 minutes per Word doc that I compile. I think that is worth it.
