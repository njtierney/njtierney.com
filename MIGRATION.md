# Quarto migration notes (branch: `quarto-migration`)

This branch contains a skeleton Quarto version of the site, replicating the
hugo-xmin look. The old Hugo/blogdown site is untouched — `_quarto.yml` only
renders the new files, so both can coexist while migrating.

Preview locally with:

```bash
quarto preview
```

## Decisions made

- **Old posts use their already-rendered output** (the `.markdown`/`.md` files
  knitted by blogdown/hugodown) copied as plain `.md` posts — no R code is
  re-executed. New posts should be written as `.qmd` (with `freeze: auto`
  already configured).
- **New URL structure**: `/posts/<dirname>/`. Every migrated post carries an
  `aliases:` entry with its old Hugo URL (`/post/YYYY/MM/DD/slug/`), which
  Quarto turns into a redirect page. Note the alias is built from the
  *frontmatter* date + slug (what Hugo used), not the folder name.
- **Deployment: GitHub Pages** via `.github/workflows/publish.yml`
  (quarto-actions, publishes to the `gh-pages` branch). `CNAME` is included
  in the site output for the custom domain.

## What's in the skeleton

- `_quarto.yml` — site config: header/footer, theme, utterances comments
  (post pages only; pages set `comments: false`), RSS feed at `/index.xml`.
- `assets/` — `theme.scss` + `hover.css` replicating the hugo-xmin +
  custom CSS look; `header.html` is the site header (logo, two-tone title,
  menu); `listing.ejs` renders the homepage post list in the Hugo
  `YYYY/MM/DD title` format.
- `index.qmd` — homepage listing of `posts/`.
- `bio.qmd`, `consulting.qmd`, `talks.qmd`, `resources.qmd`, `software.qmd`
  — converted from `content/*.md`.
- `posts/` — 10 representative posts (2013–2024) covering: plain `.md`,
  old blogdown `.markdown` with figures in `static/post/*_files/` (figures
  copied into the post dir and paths rewritten), and modern hugodown
  `index.md` bundles with relative `figs/`/`imgs/` paths.

## Full migration status (done 2026-07-09)

All 76 published posts are migrated, verified against the live sitemap:
every live `/post/YYYY/MM/DD/slug/` URL has a redirect page, no post has a
missing local image, and the RSS feed is copied to the old `/post/index.xml`
path at render time (`scripts/copy-feed.sh`). All pages (`bio`,
`consulting`, `talks`, `resources`, `software`, `cv`, `publications`) carry
aliases for their old pretty URLs.

Notes from the migration:

- The `.Rmd` bundle posts all had hugodown-rendered `index.md` — no
  HTML-to-markdown conversion was needed.
- Three posts demonstrate verbatim R chunks/inline code
  (`2019-07-10-jq-verbatim-inline-r`, `2018-05-16-rtip-3-...`,
  `2017-08-09-some-cran-gotchas`). Quarto's executable-code detection
  doesn't respect nested code fences, so their verbatim examples are
  rewritten as `<pre><code>` with backticks escaped as `&#96;` — identical
  display, no false detection.
- One inline-math usage (`2016-11-06-simple-s3-methods`) used blogdown's
  `` `\(...\)` `` convention; converted to `$...$`.
- `content/post/2017/2017-11-04-tidyverse-billboard/` contained two posts;
  the shadowed ozunconf17 `index.md` was never live and was not migrated.
- Drafts were skipped (`2023-11-08-how-to-get-started-with-r` plus the
  `drafts/` folder — except `2023-04-24-improving-missing-data-m1`, which
  lives in `drafts/` but is published on the live site).
- The ~12 untracked in-progress post folders under `content/post/` were
  left untouched; migrate them by hand when publishing (write as `.qmd`).

## Remaining work

1. **DNS/hosting cutover**: enable GitHub Pages (deploy from `gh-pages`
   branch) in the repo settings, merge this branch to `master` to trigger
   `.github/workflows/publish.yml`, verify the Pages URL, then repoint
   `www.njtierney.com` from Netlify to GitHub Pages.
2. Small fidelity gaps vs the old site: no per-post reading time; no
   "Edit this page" footer link (Quarto's `repo-actions: [edit]` can add
   one if wanted).
3. Once live, delete the Hugo files (`config.toml`, `content/`, `layouts/`,
   `themes/`, `static/`, `resources/`, `netlify.toml`), the `render:`
   allowlist in `_quarto.yml`, and this file.
