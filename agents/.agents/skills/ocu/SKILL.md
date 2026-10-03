---
name: ocu
description: ClickUp (Opalin workspace) through the `ocu` CLI. Use whenever the user mentions ClickUp or anything that lives in it — OKRs (deadlines, describe, comment, update progress), tasks and comments, searching any doc or task by text, ML experiment pages in the ML wiki, weekly meeting summaries, what teammates are doing, Triage, next tasks in a space, creating docs or pages. Use `ocu` instead of ClickUp MCP tools.
---

# ClickUp via `ocu`

## Who you're working for
Theo — Founding Engineer, ML & Software at Opalin (robot manipulation: VLA policies, failure detection,
reward/progression models, data collection and teleop pipelines). He uses ClickUp to track OKRs, log ML
experiments, follow the team, and pick up Triage work. So:
- Write like an ML engineer: setup, data, model, metric, numbers, takeaway. Short and factual, no filler.
- Experiment pages: `## Setup` · `## Results` (table) · `## Takeaways` · `## Next`. New Q4 experiments go under
  `ML wiki / ML experiments / Q4`.
- OKR comments: the finding first, then the evidence (metric, link to page/run), then the next step.
- When suggesting work (Triage, `ocu tasks`), surface ML and software items first.
- He writes quickly, sometimes in French/English mix; keep his meaning, fix only typos when asked.


`ocu` (on PATH via ~/.cargo/bin; source github.com/theguega/ocu (private) — if missing: `git clone git@github.com:theguega/ocu.git ~/Developer/ocu && cargo install --path ~/Developer/ocu`) prints compact tables
`label[N]{fields}:` and ends with `help:` next steps. Run with no args for a digest.

**Writes are dry runs unless `--yes`.** Run once without `--yes`, show Theo what will change,
and only re-run with `--yes` after he explicitly OKs it. Never pass `--yes` on a first attempt.

## Map requests to commands

| Theo asks | Do |
|---|---|
| "deadlines of my OKRs" | `ocu okr deadlines` (`--all` for everyone) |
| "describe this OKR" | `ocu task <id>` (find ids via `ocu okr` or `ocu okr mine`) |
| "comment with the latest finding" | `ocu comment <id> "…"` (long text: `--file -` with a heredoc; reply: `--reply-to <commentId>`) |
| "update progression" | There is no progress field. Use `ocu set <id> "Key Result Metrics=<value>"` and/or `status="in progress"`/`"complete"`; `Summary=` for a narrative. |
| "find the doc about X" / any document | `ocu search <words> [--type page\|task] [--in <space>]` then `ocu doc read <page id>` |
| "put this bench under the reward model page" | write markdown to a scratch file → `ocu page append "<page name or id>" --file f.md` (or `ocu page new "<title>" --under <page> --file f.md` for a sub-page) |
| "my activity this week → weekly meeting summary" | `ocu week` (markdown) → save to a file, edit if needed → `ocu page append <weekly page id> --file f.md`. Weekly pages live under `ML wiki / Weekly meetings / <Month> / <YYYY-MM-DD>`; names can be duplicated, so pass the id from the error list. |
| "what are triage tickets" / "can I work on something" | `ocu triage` · `ocu triage --free` → `ocu take <id>` |
| "next tasks in software" | `ocu tasks --in Software [--free\|--mine] [-n 20]` (also folders/lists: `--in "Software/cell stack"`) |
| "create a doc under Ops" | `ocu doc new "<name>" --in Ops [--file f.md]` |
| "what are people doing" | `ocu activity --days 7` · `--person <name>` · `ocu week --person <name>` |
| OKR overview / my OKR inbox / recent changes | `ocu okr` · `ocu okr mine` · `ocu okr changes --days 7` |

## Notes
- Search runs on a local index (docs + tasks) that auto-syncs incrementally when >15 min old; `ocu sync` forces it, `ocu sync --full` rebuilds (~70 s). Comment text is not indexed.
- `ocu okr mine`, `okr changes`, `week` fetch comments per task; the first run is slow (`week` ~2–3 min), later runs are cached.
- Page and location names resolve fuzzily; ambiguous names fail with a candidate list — pick the id.
- ClickUp's API does not expose whether a comment was edited.
- Link tasks for Theo as `[name](https://app.clickup.com/t/<id>)`.
