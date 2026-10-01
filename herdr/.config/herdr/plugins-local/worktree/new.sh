#!/usr/bin/env bash
set -euo pipefail

read -rp "worktree (name, branch or #pr): " arg
[[ -z "$arg" ]] && exit 0
b="$HOME/Developer/drover/bin/herdr-wt"
[[ -x "$b" ]] || b="$HOME/.local/bin/herdr-wt"
"$b" "$arg" --focus >/dev/null || read -rp "failed, press enter" _
