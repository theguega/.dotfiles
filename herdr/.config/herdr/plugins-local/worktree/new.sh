#!/usr/bin/env bash
set -euo pipefail

prefix="${HERDR_WORKTREE_PREFIX:-theo}"
root=$(dirname "$(git rev-parse --path-format=absolute --git-common-dir)")
repo=$(basename "$root")

read -rp "branch: $prefix/" name
[[ -z "$name" ]] && exit 0

slug=${name//\//-}
"$HERDR_BIN_PATH" worktree create --cwd "$root" --branch "$prefix/$name" \
  --path "$(dirname "$root")/$repo.$slug" --label "$slug" --focus >/dev/null \
  || read -rp "failed, press enter" _
