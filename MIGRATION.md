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

Two repos are in play:

- **`rbind/njtierney.com`** — this repo, the blog source. You have admin
  rights on it; GitHub Pages is currently disabled.
- **`njtierney/njtierney.github.io`** — your personal user-pages repo.
  Pages is enabled but it currently serves a 404 (last touched Mar 2025),
  so nothing depends on it.

They don't conflict: a user-pages repo (`njtierney.github.io`) and a
project-pages repo (`rbind/njtierney.com`) are independent, and a custom
domain can be attached to either. Pick one of these paths.

### Option A (recommended): Pages on this repo

Fewest moving parts — the publish workflow already targets this repo and
needs no tokens or cross-repo setup. `njtierney.github.io` stays untouched.

1. Flip `repo-branch` in `_quarto.yml` to `master` (fixes the "Edit this
   page" links), then merge `quarto-migration` into `master`.
2. Create the `gh-pages` branch once, either by running
   `quarto publish gh-pages` locally, or:
   `git checkout --orphan gh-pages && git rm -rf . && git commit --allow-empty -m "init gh-pages" && git push origin gh-pages && git checkout master`
3. Repo settings → Pages: deploy from branch → `gh-pages` / root.
4. Push to `master` → `.github/workflows/publish.yml` renders and
   publishes. The `CNAME` file in the site output sets the custom domain
   (`www.njtierney.com`) on the Pages site automatically.
5. At your DNS provider: `www` CNAME → `rbind.github.io.`; apex
   `njtierney.com` → A records `185.199.108.153`, `185.199.109.153`,
   `185.199.110.153`, `185.199.111.153` (or a registrar-level redirect
   apex → www). Leave Netlify running until the switch is verified.
6. Once `https://www.njtierney.com` serves the Quarto site, tick
   "Enforce HTTPS" in the Pages settings (appears after the certificate
   is issued), then decommission the Netlify site.

One caveat: GitHub's *verified domains* protection is an org-level setting
on `rbind` that you probably can't configure. The domain works fine
without it; it only matters if Pages were ever disabled while DNS still
pointed at GitHub.

### Option B: publish to `njtierney/njtierney.github.io`

Source stays in this repo; the workflow pushes the rendered site to the
personal repo, so the site lives at `https://njtierney.github.io` plus the
custom domain. Benefits: hosting fully under your own account, and you can
verify the domain in your personal GitHub settings. Costs: the workflow
needs a fine-grained PAT (contents: write on `njtierney.github.io`) stored
as a secret in this repo, and a deploy-step swap (e.g.
`peaceiris/actions-gh-pages` with `external_repository`) — one more token
to mint and rotate.

### Option C: move the repo to your account first

Transfer `rbind/njtierney.com` → `njtierney/njtierney.com`, then follow
Option A there. Cleanest long-term ownership; GitHub redirects the old
repo URLs. Note the utterances comments live as issues in the rbind repo —
they transfer with the repo, but `comments.utterances.repo` and `repo-url`
in `_quarto.yml` must be updated to the new name. Requires the rbind org
to permit the transfer.

## Other remaining work

1. Small fidelity gap vs the old site: no per-post reading time.
2. The old Hugo `/categories/*` and `/tags/*` taxonomy pages have no
   equivalent and will 404 after cutover (low-value pages; accepted).
3. Once live, delete the Hugo files (`config.toml`, `content/`, `layouts/`,
   `themes/`, `static/`, `resources/`, `netlify.toml`), the `render:`
   allowlist in `_quarto.yml`, and this file.
