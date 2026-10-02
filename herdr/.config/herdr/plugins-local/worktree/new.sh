#!/usr/bin/env bash
set -euo pipefail

read -rp "worktree (name, branch or #pr): " arg
[[ -z "$arg" ]] && exit 0
"$HOME/.local/bin/herdr-wt" "$arg" --focus >/dev/null || read -rp "failed, press enter" _
