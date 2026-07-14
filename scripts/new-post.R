# Create a new blog post from the archetype in scripts/templates/post.qmd.
# Usage, from the repo root:
#
#   source("scripts/new-post.R")
#   new_post("My Great Title", categories = c("rstats", "blag"))
#
# Call `used_categories()` (or `new_post()` with no categories) to see the
# categories used across existing posts. See NEW-POST.md for the full
# workflow.

new_post <- function(title,
                     categories = NULL,
                     date = Sys.Date(),
                     draft = FALSE,
                     open = interactive()) {
  if (!file.exists("_quarto.yml")) {
    stop("Run this from the repository root (where _quarto.yml lives).")
  }
  if (missing(title) || !nzchar(trimws(title))) {
    stop("`title` is required.")
  }

  if (is.null(categories)) {
    existing <- used_categories()
    message(
      "No categories given. Categories used so far:\n  ",
      paste(existing, collapse = ", ")
    )
  }

  slug <- slugify(title)
  dir <- file.path("posts", paste0(format(date, "%Y-%m-%d"), "-", slug))
  if (dir.exists(dir)) {
    stop("There is already a post at ", dir)
  }

  template <- readLines("scripts/templates/post.qmd")
  template <- sub("{{title}}", title, template, fixed = TRUE)
  template <- sub("{{date}}", format(date, "%Y-%m-%d"), template, fixed = TRUE)
  cat_line <- which(template == "{{categories}}")
  if (is.null(categories)) {
    # drop the `categories:` key and its placeholder
    template <- template[-c(cat_line - 1, cat_line)]
  } else {
    template[cat_line] <- paste0("  - ", categories, collapse = "\n")
  }
  if (draft) {
    template <- append(template, "draft: true", after = grep("^date:", template)[1])
  }

  dir.create(dir, recursive = TRUE)
  path <- file.path(dir, "index.qmd")
  writeLines(template, path)

  message("Created ", path)
  message("It will be published at /", dir, "/")
  message("Preview the site with: quarto preview")
  if (draft) {
    message("Remove the `draft: true` line when it's ready to publish.")
  }

  if (open) {
    if (requireNamespace("rstudioapi", quietly = TRUE) &&
          rstudioapi::isAvailable()) {
      rstudioapi::navigateToFile(path)
    } else {
      utils::file.edit(path)
    }
  }
  invisible(path)
}

slugify <- function(title) {
  slug <- tolower(trimws(title))
  slug <- gsub("['\"]", "", slug)
  slug <- gsub("[^a-z0-9]+", "-", slug)
  gsub("^-+|-+$", "", slug)
}

used_categories <- function() {
  posts <- list.files(
    "posts",
    pattern = "^index\\.(md|qmd)$",
    recursive = TRUE,
    full.names = TRUE
  )
  cats <- unlist(lapply(posts, function(p) {
    lines <- readLines(p, warn = FALSE)
    fence <- which(lines == "---")
    if (length(fence) < 2) return(character())
    fm <- lines[(fence[1] + 1):(fence[2] - 1)]
    key <- grep("^categories:", fm)
    if (!length(key)) return(character())
    items <- character()
    for (line in fm[-seq_len(key[1])]) {
      if (!grepl("^\\s+-\\s*", line)) break
      items <- c(items, sub("^\\s+-\\s*", "", line))
    }
    # also handle inline form: categories: [a, b]
    inline <- sub("^categories:\\s*", "", fm[key[1]])
    if (nzchar(inline)) {
      items <- c(items, strsplit(gsub("[][]", "", inline), ",\\s*")[[1]])
    }
    trimws(items)
  }))
  sort(unique(cats[nzchar(cats)]))
}
