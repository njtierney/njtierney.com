# Quarto migration notes (branch: `quarto-migration`)

This branch contains the complete Quarto version of the site, replicating
the hugo-xmin look. The old Hugo/blogdown site is untouched — `_quarto.yml`
only renders the new files, so both coexist until cutover.

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

## What's here

- `_quarto.yml` — site config: header/footer, theme, utterances comments
  (post pages only; pages set `comments: false`), RSS feed at `/index.xml`,
  "Edit this page" footer links (`repo-actions`).
- `assets/` — `theme.scss` + `hover.css` + `syntax.css` replicating the
  hugo-xmin + custom CSS look; `header.html` is the site header (logo,
  two-tone title, menu); `listing.ejs` renders the homepage post list in
  the Hugo `YYYY/MM/DD title` format.
- `index.qmd` — homepage listing of `posts/`.
- `bio.qmd`, `consulting.qmd`, `talks.qmd`, `resources.qmd`,
  `software.qmd`, `cv.qmd`, `publications.qmd` — converted from
  `content/*.md`.
- `posts/` — all 77 published posts (2013–2026).
- `scripts/new-post.R` + `scripts/templates/post.qmd` — the
  `blogdown::new_post()` replacement; see `NEW-POST.md`.

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

## Going live: hosting and DNS

Status (2026-07-14): the repo was transferred from `rbind/njtierney.com`
to **`njtierney/njtierney.com`** (the rbind org's domain-verification
policy blocked attaching the custom domain; a personal repo has no such
policy, and the utterances comment issues moved with the repo). GitHub
Pages is enabled on the transferred repo (deploy from `gh-pages` / root),
the custom domain `www.njtierney.com` is attached and verified, and the
site is live at the Pages URL. `quarto-migration` still needs merging to
`master`, which is what the publish workflow triggers on.

What remains is DNS (currently pointing at Netlify). At Route 53, hosted
zone `njtierney.com` — only these two records change; never touch MX
(Google email), NS/SOA, or the TXT records:

1. Edit the **A** record (`njtierney.com`): replace Netlify's
   `104.198.14.52` with GitHub Pages' four IPs, one per line:
   `185.199.108.153`, `185.199.109.153`, `185.199.110.153`,
   `185.199.111.153`. Keep "Alias" off.
2. Edit the **CNAME** record (`www`): replace `njt-test.netlify.com` with
   **`njtierney.github.io`** (the personal-account Pages host — *not*
   `rbind.github.io` now that the repo has moved).
3. Both records have TTL 300, so changes land in ~5 minutes; rollback is
   restoring the old values. Leave Netlify running until the switch is
   verified.
4. Once `https://www.njtierney.com` serves the Quarto site, tick
   "Enforce HTTPS" in the Pages settings (appears after the certificate
   is issued), then decommission the Netlify site.

The leftover `_github-challenge-*` TXT record from the abandoned rbind
org-verification attempt can be deleted from Route 53 if present.

## Other remaining work

1. Small fidelity gap vs the old site: no per-post reading time.
2. The old Hugo `/categories/*` and `/tags/*` taxonomy pages have no
   equivalent and will 404 after cutover (low-value pages; accepted).
3. Once live, delete the Hugo files (`config.toml`, `content/`, `layouts/`,
   `themes/`, `static/`, `resources/`, `archetypes/`, `netlify.toml`,
   `.hugo_build.lock`, `public/`) and this file. Salvaged already:
   drafts → `drafts/`, images → `imgs/` + `hexes/` + `favicon.ico`,
   legacy `static/_redirects` rules → post aliases. **Keep the `render:`
   allowlist in `_quarto.yml`** — it is what stops Quarto rendering
   `drafts/`.
