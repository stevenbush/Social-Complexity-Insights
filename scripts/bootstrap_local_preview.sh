#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RUBY_VERSION="3.2.4"
LOCAL_RUBY_DIR="$ROOT_DIR/.local/ruby-$RUBY_VERSION"
LOCAL_CACHE_DIR="$ROOT_DIR/.local/cache"
RUBY_BUILD_CACHE_DIR="$LOCAL_CACHE_DIR/ruby-build"
BUNDLE_PATH="$ROOT_DIR/vendor/bundle"
BUNDLE_APP_CONFIG="$ROOT_DIR/.bundle"
INSTALL_ALIAS_ROOT=""
INSTALL_RUBY_DIR="$LOCAL_RUBY_DIR"

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

ensure_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    fail "Homebrew is required on macOS to bootstrap the project-local Ruby runtime."
  fi
}

brew_prefix() {
  brew --prefix "$1"
}

prepare_install_alias() {
  local alias_hash alias_name

  if [[ "$ROOT_DIR" != *" "* ]]; then
    return
  fi

  alias_hash="$(printf '%s' "$ROOT_DIR" | shasum | awk '{print substr($1, 1, 8)}')"
  alias_name="social-complexity-insights-preview-$alias_hash"
  INSTALL_ALIAS_ROOT="/tmp/$alias_name"
  INSTALL_RUBY_DIR="$INSTALL_ALIAS_ROOT/.local/ruby-$RUBY_VERSION"

  ln -sfn "$ROOT_DIR" "$INSTALL_ALIAS_ROOT"
  printf 'Using path alias %s -> %s\n' "$INSTALL_ALIAS_ROOT" "$ROOT_DIR"
}

ensure_formulae() {
  local formula
  local missing=()
  for formula in ruby-build openssl@3 libyaml readline gmp; do
    if ! brew list --versions "$formula" >/dev/null 2>&1; then
      missing+=("$formula")
    fi
  done

  if ((${#missing[@]} > 0)); then
    printf 'Installing Homebrew packages: %s\n' "${missing[*]}"
    brew install "${missing[@]}"
  fi
}

local_ruby_version() {
  "$LOCAL_RUBY_DIR/bin/ruby" -e 'print RUBY_VERSION' 2>/dev/null || true
}

ensure_local_ruby() {
  local current_version
  current_version="$(local_ruby_version)"

  if [[ "$current_version" == "$RUBY_VERSION" ]]; then
    printf 'Using existing local Ruby %s at %s\n' "$current_version" "$LOCAL_RUBY_DIR"
    return
  fi

  if [[ -e "$LOCAL_RUBY_DIR" && -z "$current_version" ]]; then
    fail "Found an incomplete local Ruby at $LOCAL_RUBY_DIR. Remove it and rerun this bootstrap script."
  fi

  mkdir -p "$RUBY_BUILD_CACHE_DIR"

  export RUBY_BUILD_CACHE_PATH="$RUBY_BUILD_CACHE_DIR"
  export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew_prefix openssl@3) --with-readline-dir=$(brew_prefix readline) --with-libyaml-dir=$(brew_prefix libyaml) --with-gmp-dir=$(brew_prefix gmp)"

  printf 'Installing Ruby %s into %s\n' "$RUBY_VERSION" "$LOCAL_RUBY_DIR"
  "$(brew_prefix ruby-build)/bin/ruby-build" "$RUBY_VERSION" "$INSTALL_RUBY_DIR"
}

setup_local_env() {
  local gem_home
  gem_home="$("$LOCAL_RUBY_DIR/bin/ruby" -e 'print Gem.default_dir')"

  export PATH="$LOCAL_RUBY_DIR/bin:$PATH"
  export GEM_HOME="$gem_home"
  export GEM_PATH="$gem_home"
  export BUNDLE_PATH="$BUNDLE_PATH"
  export BUNDLE_APP_CONFIG="$BUNDLE_APP_CONFIG"
}

install_bundler() {
  if ! "$LOCAL_RUBY_DIR/bin/bundle" --version >/dev/null 2>&1; then
    "$LOCAL_RUBY_DIR/bin/gem" install bundler --no-document
  fi
}

install_gems() {
  mkdir -p "$BUNDLE_APP_CONFIG"
  "$LOCAL_RUBY_DIR/bin/bundle" config set --local path "vendor/bundle"
  "$LOCAL_RUBY_DIR/bin/bundle" install
}

main() {
  ensure_brew
  prepare_install_alias
  ensure_formulae
  ensure_local_ruby
  setup_local_env
  install_bundler
  install_gems

  printf '\nBootstrap complete.\n'
  printf 'Run ./scripts/preview.sh to start the local Jekyll server.\n'
}

main "$@"
