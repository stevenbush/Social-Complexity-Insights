#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_RUBY_DIR="$ROOT_DIR/.local/ruby-3.2.4"
BUNDLE_DIR="$ROOT_DIR/vendor/bundle"
POST_DIR="$ROOT_DIR/_posts"

check_ok() {
  printf '[ok] %s\n' "$1"
}

check_warn() {
  printf '[warn] %s\n' "$1"
}

check_fail() {
  printf '[fail] %s\n' "$1" >&2
  exit 1
}

if [[ ! -x "$LOCAL_RUBY_DIR/bin/ruby" ]]; then
  check_fail "Local Ruby was not found at $LOCAL_RUBY_DIR"
fi

RUBY_VERSION="$("$LOCAL_RUBY_DIR/bin/ruby" -e 'print RUBY_VERSION')"
if [[ "$RUBY_VERSION" == 3.2.* ]]; then
  check_ok "Local Ruby version is $RUBY_VERSION"
else
  check_fail "Expected Ruby 3.2.x but found $RUBY_VERSION"
fi

if "$LOCAL_RUBY_DIR/bin/bundle" --version >/dev/null 2>&1; then
  check_ok "Bundler is available"
else
  check_fail "Bundler is missing from the local Ruby runtime"
fi

if [[ -d "$BUNDLE_DIR" ]]; then
  check_ok "Bundler install path exists at $BUNDLE_DIR"
else
  check_warn "Bundler install path is missing at $BUNDLE_DIR"
fi

if [[ -f "$ROOT_DIR/img/bg-index.jpg" && -f "$ROOT_DIR/img/bg-post.jpg" ]]; then
  check_ok "Required Clean Blog background images are present"
else
  check_fail "Required Clean Blog background images are missing from img/"
fi

if find "$POST_DIR" -maxdepth 1 -type f -name '*.md' | grep -q .; then
  check_ok "Generated posts are present in $POST_DIR"
else
  check_warn "No generated posts were found in $POST_DIR"
fi
