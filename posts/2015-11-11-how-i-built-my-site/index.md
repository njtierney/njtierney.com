---
title: How I built my website
date: "2015-11-11"
categories:
- Jekyll
slug: wp-to-jekyll
aliases:
  - /post/2015/11/11/wp-to-jekyll/
---

I've recently changed my website from Wordpress to Jekyll. In this post I try and succinctly describe how it happened.

# Why change?

Basically, for the following reasons:

- Wordpress doesn't handle [RMarkdown](http://rmarkdown.rstudio.com) very well. 
- I wanted more control without having to result to (read: pay for) Wordpress's plugin system. 
- I wanted to understand more about web development.

These reasons started coalesced together into something relevant and coherent when I was using [Slack](https://slack.com/), a work-chat platform. I had started to share my "cheatsheets" of R code with colleagues, and I thought it would be cool to post them up as little RMarkdown chunks onto my website, which was hosted on wordpress. How hard could it be? I figured I could just post the HTML from the RMarkdown document into wordpress, and boom, should have it all sorted. But for some reason or another, or maybe for no reason, wordpress didn't like that.

Of course, there's an R package for the problem. Yihui (creator of knitr) even has a guide [here](http://yihui.name/knitr/demo/wordpress/) about using the package `RWordpress` to publish blog posts from R to WordPress. So, I figured, hey, maybe this is the way. I was going to follow the instructions on the website...

...But reading it, Yihui says:

> ...Once it is published, it is not straightforward to modify it (although you can), and that is why you, as a cool hacker, **should blog with Jekyll instead of WordPress**. It is always easy to deal with plain text files...

And I thought...I've always wanted to be a _cool hacker_... and I _had_ heard of Jekyll, but wasn't really sure what it was. I _did_ know that [Hadley Wickham's books](http://adv-r-had.co.nz) have been built using it. So chances are if Hadley and Yihui recommend it, I should probably look into it.

## So what is Jekyll? 

Basically, you write posts in a syntax called [Markdown](https://daringfireball.net/projects/markdown/), and then jekyll does the heavy lifting to turn that into a website - automagically turning your text into HTML and CSS, and building the file structure needed for a website to run. This means you can just focus on writing material. Jekyll also allows you to preview the website on your computer before pushing it online. And what I love so much about it is that it is as customizable as you want - you can [download a stock theme](github.com/poole/poole), and keep it simple, or you can customize all the code to create very different websites. For example, [here](http://joshualande.com/), [here](https://developmentseed.org/blog/2011/09/09/jekyll-github-pages/) and [here](http://andreicek.eu/index.html). All of those guys have made their website code publicly available on GitHub. This means if you like something from someone's site, you can check out their [GitHub repository](https://github.com/joshualande/joshualande.github.io) and see how it works and steal/borrow their code.

## So how do I build a site using jekyll?

It is really easy.

Step 1. Create a [GitHub Account](https://github.com)

Step 2. Create a github page, as per instructions [here](https://pages.github.com/).

Step 3. [Download requirements for jekyll](http://jekyllrb.com/docs/quickstart/)

Step 4. Follow directions from [this blog](http://www.sitepoint.com/set-jekyll-blog-5-minutes-poole/)

And that's about it.

## Migrating material from wordpress to jekyll

There are [tools for migrating to jekyll](http://import.jekyllrb.com/docs/home/), but I found them a little hard to follow, probably because I only really understand how to program in R. So, I ended up doing something that I hate doing...and copied and pasted (copypasta'd) each post individually. Then I tinkered with them. Then I put them into the [_posts](https://github.com/njtierney/tierneyn.github.io/tree/master/_posts) directory. I allowed myself to do this as I didn't have that many posts on my original website, so I figured it wasn't that bad. Aaand, I didn't feel like diving into another rabbit hole of xml.

## Customizations

I had a look around at a bunch of different blogs about how to build stuff, and added a few things.

### Enabling commenting using disqus.

To add commenting using disqus, I followed advice from [Joshua Lande's blog](http://joshualande.com/jekyll-github-pages-poole/). In this post, he points out:

> "By setting up the code this way, I can enable commenting on a page-by-page basis. All I have to do is set "comments: True" in the YAML header of the post."

He gives a great guide of how to do it, so I would head there if I were you. But here is what I did:

1. Go to [disqus](https://disqus.com/), create account (if you haven't already)

2. Go to settings (gear icon in the top right), and click "add disqus to site"

3. Go to "engage", and fill in your site name, etc.

4. Choose your platform - choose "universal code"

5. Copy the code from disqus, being sure to [follow their instructions](https://help.disqus.com/customer/en/portal/articles/2158629), to "Recommended: Edit the RECOMMENDED CONFIGURATION VARIABLES section using your CMS or platform's dynamic values. See our documentation to learn why defining identifier and url is important for preventing duplicate threads."

I then decided that I couldn't understand what disqus wanted me to do...so I copied Joshua Lande's text from [his github repo](), changed his name for mine, and continued on. Isn't that cool? Isn't that why GitHub is so awesome?

### Adding google analytics

Again, following advice from [Joshua lande's blog post](http://joshualande.com/jekyll-github-pages-poole/).

Using Google Analytics allows you to see who is visiting your site, from where, and all that stuff that WordPress has built into it. 

When I started, I didn't really know what google analytics was, so I went to their [homepage](http://www.google.com/analytics/)...found the link "sign up for analytics", and followed the prompts - left all the boxes ticked (Google has my soul anyway), and accepted the Ts and Cs. Google then gives me a tracking code, with a nice friendly helpful box, stating: "this is your tracking code". I then inserted this into a new file, [google_analytics.html](https://github.com/njtierney/tierneyn.github.io/blob/master/_includes/google_analytics.html), added the appropriate coce to my [default.html](https://github.com/njtierney/tierneyn.github.io/blob/master/_layouts/default.html)

## Other little customizations:

**Markdown tables**

You can allow simple tables by changing your [_yaml](https://github.com/njtierney/tierneyn.github.io/blob/master/_config.yml) code to select the extension you want. Credit to [Nicole White's blog](https://github.com/nicolewhite/nicolewhite.github.io), where I saw this first.

This means that the output from the R command `knitr::kable(head(iris))`:

```
| Sepal.Length| Sepal.Width| Petal.Length| Petal.Width|Species |
|------------:|-----------:|------------:|-----------:|:-------|
|          5.1|         3.5|          1.4|         0.2|setosa  |
|          4.9|         3.0|          1.4|         0.2|setosa  |
|          4.7|         3.2|          1.3|         0.2|setosa  |
|          4.6|         3.1|          1.5|         0.2|setosa  |
|          5.0|         3.6|          1.4|         0.2|setosa  |
|          5.4|         3.9|          1.7|         0.4|setosa  |
```

turns into

| Sepal.Length| Sepal.Width| Petal.Length| Petal.Width|Species |
|------------:|-----------:|------------:|-----------:|:-------|
|          5.1|         3.5|          1.4|         0.2|setosa  |
|          4.9|         3.0|          1.4|         0.2|setosa  |
|          4.7|         3.2|          1.3|         0.2|setosa  |
|          4.6|         3.1|          1.5|         0.2|setosa  |
|          5.0|         3.6|          1.4|         0.2|setosa  |
|          5.4|         3.9|          1.7|         0.4|setosa  |


There are also all heaps of other extensions you can add to redcarpet. You can read about them all [here](https://github.com/vmg/redcarpet#redcarpet-is-written-with-sugar-spice-and-everything-nice).

**Changing font**

I looked up some awesome [font pairings](fontpair.co), and chose Hind for the header Open Sans for the text. I then inserted some code [into the top lines of the css](https://github.com/njtierney/tierneyn.github.io/public/css/lanyon.css) to import them, and then added them to the appropriate parts of the css. I also changed the monospace font that is used for code to `Monaco`, in [poole.css](https://github.com/njtierney/tierneyn.github.io/public/css/poole.css).

**Adding in excerpts**

I wanted the main blog page to just have excerpts from the blog. This is really easy - you just change `{{ post.content }}` to `{{ post.excerpt }}` in [default.html](https://github.com/njtierney/tierneyn.github.io/_layouts/default.html).

There a few other little things that I did, if you want to see how it all works, just check out my [GitHub repo](https://github.com/njtierney/tierneyn.github.io).

# Getting jekyll to work with RMarkdown

Alright, so this was the reason I wanted to use jekyll in the first place...but I actually ended up having a bit of an epic journey trying to do it. So, I figured it would be better as a separate post, which I will write soon.

# Conclusion

GitHub hosts the website for you, and you use Jekyll to build the website content. You can make the whole website public on GitHub, so people can see exactly how everything works, and the website file structure is stored locally on your computer. This means if you want, you can see exactly how everything works. Using Jekyll gives you control, but makes the load easier to bare. I really like the control you get -  if I don't like some font - I can change it, if I want header text centered - I can do that. For me, it has been a nice compromise between learning how to code a website from absolute scratch, and using a content management system like wordpress.

# Further Reading

Along the way through this journey I found some fantastic guides from other folk on the internet. These guys saved me a lot of time, so I would recommend reading their posts about this:

- [Brendan Rocks](http://brendanrocks.com/blogging-with-rmarkdown-knitr-jekyll/) - this one is particularly awesome.
- [Joshua Lande](http://joshualande.com/jekyll-github-pages-poole/)
- [Nicole White](https://nicolewhite.github.io/2015/02/07/r-blogging-with-rmarkdown-knitr-jekyll.html)
- [Jekyll website in 5 minutes](http://www.sitepoint.com/set-jekyll-blog-5-minutes-poole/)


