#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_RUBY_DIR="$ROOT_DIR/.local/ruby-3.2.4"
BUNDLE_PATH="$ROOT_DIR/vendor/bundle"
BUNDLE_APP_CONFIG="$ROOT_DIR/.bundle"
PREVIEW_URL="http://127.0.0.1:4000/Social-Complexity-Insights/"

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

if [[ ! -x "$LOCAL_RUBY_DIR/bin/ruby" ]]; then
  fail "Local Ruby was not found at $LOCAL_RUBY_DIR. Run ./scripts/bootstrap_local_preview.sh first."
fi

if [[ ! -x "$LOCAL_RUBY_DIR/bin/bundle" ]]; then
  fail "Bundler is not available in the local Ruby runtime. Rerun ./scripts/bootstrap_local_preview.sh."
fi

GEM_HOME="$("$LOCAL_RUBY_DIR/bin/ruby" -e 'print Gem.default_dir')"

export PATH="$LOCAL_RUBY_DIR/bin:$PATH"
export GEM_HOME="$GEM_HOME"
export GEM_PATH="$GEM_HOME"
export BUNDLE_PATH="$BUNDLE_PATH"
export BUNDLE_APP_CONFIG="$BUNDLE_APP_CONFIG"

cd "$ROOT_DIR"

ruby scripts/generate_posts.rb

printf 'Preview URL: %s\n' "$PREVIEW_URL"

# LiveReload defaults to port 35729; another Jekyll/editor process often holds it and
# causes: eventmachine ... no acceptor (port is in use). Use a less crowded default
# and allow override via JEKYLL_LIVERELOAD_PORT; set JEKYLL_LIVERELOAD=0 to disable.
jekyll_serve_args=(--host 127.0.0.1 --port 4000)
if [[ "${JEKYLL_LIVERELOAD:-1}" != "0" ]]; then
  jekyll_serve_args+=(--livereload --livereload-port "${JEKYLL_LIVERELOAD_PORT:-35217}")
fi
exec bundle exec jekyll serve "${jekyll_serve_args[@]}"
