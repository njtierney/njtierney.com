# How to write a new post

The whole lifecycle of a post, start to finish. Day-to-day it's:
**new folder → write `index.qmd` → preview → commit & push.**

## The quick way

Steps 1 and 2 below are automated (the replacement for
`blogdown::new_post()`). From the repo root, in R:

```r
source("scripts/new-post.R")
new_post("My Great Title", categories = c("rstats", "blag"))
```

That creates `posts/<today>-my-great-title/index.qmd` from the archetype in
`scripts/templates/post.qmd` (frontmatter plus the Air setup chunk from
step 2) and opens it. Useful extras:

- call it with no `categories` to be shown every category used so far
  (`used_categories()` does the same)
- `draft = TRUE` starts the post as a draft
- `date = as.Date("2026-08-01")` overrides today's date
- edit `scripts/templates/post.qmd` to change what new posts start from

Then pick up at step 3 (preview). The manual steps follow, for reference.

## 1. Make a folder for the post

One post = one folder inside `posts/`, named with the date and a short slug:

```
posts/
└── 2026-07-10-my-new-post/
```

The folder name is the post's URL forever
(`njtierney.com/posts/2026-07-10-my-new-post/`), so pick a slug you like.

## 2. Write the post in a single file inside that folder

Always called `index`:

```
posts/
└── 2026-07-10-my-new-post/
    ├── index.qmd        ← the post (use .md if there's no R code)
    └── imgs/            ← optional: any photos/images you want to include
```

At the top of the file, fill in a small YAML header — title, date,
categories. That's the only admin. No `author:` (the site doesn't show it),
no `slug:` or `aliases:` (those were only for preserving old Hugo URLs on
migrated posts). Reference images relatively, e.g. `![](imgs/photo.jpg)`.

```yaml
---
title: "My New Post"
date: '2026-07-10'
categories:
  - rstats
---
```

If the post has R code, start with this setup chunk — it pipes each chunk's
displayed code through [Air](https://posit-dev.github.io/air/) at render
time, so the code on the blog always comes out consistently formatted no
matter how scrappily it was typed (the `.qmd` source itself is untouched;
Air can't format chunks in `.qmd` files directly yet — see
[posit-dev/air#455](https://github.com/posit-dev/air/issues/455)):

````markdown
```{r setup, include=FALSE}
air_tidy <- function(code, ...) {
  system2("air", c("format", "--stdin-file-path", "chunk.R"),
          input = code, stdout = TRUE)
}
knitr::opts_chunk$set(tidy = air_tidy)
```
````

(The `chunk.R` path is never written — it just tells Air where to look for
an `air.toml` config, so repo-level Air settings apply to chunks too.)

## 3. Preview while you write

Run `quarto preview` in the repo — it opens the site in your browser and
refreshes every time you save. The post appears at the top of the homepage
listing automatically; there's no register/index file to update anywhere.

## 4. If the post runs R code

When you render/preview, Quarto executes the code once and saves the
results in a `_freeze/` folder at the repo root (it manages this itself —
never edit it):

```
_freeze/
└── posts/
    └── 2026-07-10-my-new-post/    ← cached code results, plots etc.
```

This cache is reused on every later render, so the post's code never
re-runs unless you edit the post — and it means the GitHub publishing
workflow doesn't need R at all. **Commit `_freeze/` along with the post.**

## 5. Publish

Commit the post folder (plus `_freeze/` if it had code) and push to
`master`. GitHub Actions renders the site and it goes live a couple of
minutes later. Nothing else to do.

## Not ready to publish?

Put `draft: true` in the post's header and it stays off the homepage and
out of the RSS feed until you remove that line. Stick to `true`/`false` —
the YAML `yes`/`no` spellings don't work as drafts flags in Quarto.
