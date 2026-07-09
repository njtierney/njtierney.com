#!/bin/bash
# The Hugo site served its RSS feed at /post/index.xml; Quarto generates it
# at /index.xml. GitHub Pages can't redirect XML, so keep a copy at the old
# path for existing feed subscribers.
set -e
out="${QUARTO_PROJECT_OUTPUT_DIR:-_site}"
# index.xml only exists on full project renders, not single-file renders
if [ -f "$out/index.xml" ]; then
  mkdir -p "$out/post"
  cp "$out/index.xml" "$out/post/index.xml"
fi
