#!/bin/bash
# paperdb: personal paper library (https://github.com/theguega/paperdb).
# Installs/updates the binary, clones the library, installs the agent skill.
# Needs cargo (rust in the Brewfile); cloning the private library needs GitHub SSH access.

PAPERDB_REPO="https://github.com/theguega/paperdb"
PAPERDB_LIBRARY_REMOTE="git@github.com:theguega/papers.git"

setup_paperdb() {
    if ! command -v cargo >/dev/null 2>&1; then
        warning "cargo not found; skipping paperdb (install the Brewfile formulae first)"
        return 0
    fi

    info "Installing paperdb from $PAPERDB_REPO..."
    cargo install --quiet --locked --git "$PAPERDB_REPO" || return 1
    local bin="$HOME/.cargo/bin/paperdb"

    local library="${PAPERDB_LIBRARY:-$HOME/papers}"
    if [[ -d "$library/.git" ]]; then
        "$bin" sync || warning "paperdb sync failed; run \`paperdb sync\` by hand"
    elif ! "$bin" init "$PAPERDB_LIBRARY_REMOTE"; then
        warning "Could not clone $PAPERDB_LIBRARY_REMOTE (GitHub SSH key set up?); run \`paperdb init $PAPERDB_LIBRARY_REMOTE\` later"
    fi

    "$bin" skill install
}
