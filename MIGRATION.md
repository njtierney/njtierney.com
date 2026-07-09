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

## Remaining work for the full migration

1. **Migrate the other ~160 posts.** The script used for these 10 is a good
   template (parametrise the sample list): for each post, copy the rendered
   markdown, strip `output:`/`rmd_hash:`/`tags:` from frontmatter, add the
   old-URL alias, copy asset dirs, and rewrite `/post/*_files/` figure paths.
2. **~28 old `.Rmd` posts render to HTML, not markdown** (blogdown default
   for `.Rmd`). Their bodies need converting back to markdown
   (e.g. `pandoc -f html -t markdown`) or re-rendering.
3. **RSS subscribers**: the old feed lived at `/post/index.xml`; the new one
   is `/index.xml`. GitHub Pages can't 301 XML, so consider having the
   publish workflow copy `_site/index.xml` to `_site/post/index.xml`.
4. **DNS**: repoint `www.njtierney.com` from Netlify to GitHub Pages when
   ready to switch, and enable Pages (deploy from `gh-pages` branch) in the
   repo settings. The workflow currently triggers on pushes to `master`.
5. Small fidelity gaps vs the old site: no per-post reading time, and the
   post meta block layout (author/date/categories order) differs slightly;
   no "Edit this page" footer link (Quarto's `repo-actions: [edit]` can add
   one if wanted).
6. Once fully migrated, delete the Hugo files (`config.toml`, `content/`,
   `layouts/`, `themes/`, `static/`, `netlify.toml`) and the `render:`
   allowlist in `_quarto.yml`, and this file.
