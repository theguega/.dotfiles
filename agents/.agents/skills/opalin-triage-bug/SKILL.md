---
name: opalin-triage-bug
description: Turn a reported bug into a terse diagnostic, then file it as a ClickUp task in Triage plus a linked GitHub issue on claireai-inc/opalin. Use when someone reports a bug, a crash, a regression, or says "file this", "triage this", "log a bug".
---

# Opalin · Triage Bug

Input: a bug report in any shape (one line, a stack trace, a log dump, a screenshot).
Output: one ClickUp task in **Triage** + one GitHub issue, cross-linked, both carrying
the same four-block diagnostic.

The diagnostic is consumed by an automation agent that branches off the issue and
attempts a fix. **Verbose or hedged text makes that impossible.** Terse or nothing.

## 1. Inspect (time-boxed, read-only)

Find the code that produces the reported behaviour. Grep the error string, the symbol,
the component name. Read only the files you need to name the cause.

- Stop as soon as you can point at a file. Do not read the whole subsystem.
- **Never edit, fix, or run the failing code.** This skill files bugs; it does not fix them.
- If nothing matches after a focused search, say so in the Diagnostic block in one line
  (`Not located — searched X, Y`) and file anyway. A located-nowhere bug still needs a ticket.

## 2. Write the diagnostic — this exact shape, nothing added

```
🐛 [BUG] <Action + Component + Condition>

<One sentence: what breaks.>

📎 Evidence & Logs

<Trimmed error/log/repro. Omit the whole block if there is none.>

🎯 Diagnostic

- `path/to/file.py:120` — <one sentence>
```

Rules:

- Title reads `Action + Component + Condition`, e.g.
  `Recorder drops frames when the uploader backpressures`.
- One sentence means one sentence. No restating the title, no background.
- Evidence: paste the real log lines, trimmed to the relevant ones. No invented output.
  No evidence → drop the block entirely, do not write "N/A".
- Diagnostic: **at most 3** file pointers, each `path:line` + one sentence. No proposed
  patch, no options, no "could also be".
- Uncertain? One clause: `— likely, unconfirmed`. Never a paragraph of caveats.

## 3. Confirm

Show the drafted diagnostic and ask for a go-ahead in one line. The user may edit the
title or severity. On approval, file both — never file one without the other.

## 4. File it

**ClickUp** (MCP tools are deferred — load first with
`ToolSearch("select:mcp__claude_ai_ClickUp__clickup_create_task,mcp__claude_ai_ClickUp__clickup_create_comment")`):

`clickup_create_task` with:
- `list_id`: `901709950598` (Triage, in the Team Space space)
- `name`: the `🐛 [BUG] …` title
- `markdown_description`: the diagnostic, minus the title line
- `task_type`: `Bug` — drop it if the workspace rejects the type
- omit `status` — the list defaults to `pending review`
- `custom_fields`, best-effort — skip any field you cannot judge:
  - Issue Severity `1ac697b9-1334-4f58-9a91-c36fac0c1df1` —
    Critical `5ef9028e-d7f9-46b9-8575-f0918e32a97e` (blocks work / data loss),
    Major `e8bee6b4-21a0-49eb-bb8f-4e88e0c7f3b2` (broken, has a workaround),
    Minor `6641d73f-12d3-40a4-909c-aec1441d0f40`
  - Product/area `517733ae-167f-4c9e-9c8c-410705e5357a` (labels, JSON array of UUIDs) —
    Software `cd576696-996b-4040-8ee4-129c8f46c4a9`, ml `9e7889c8-3a6a-4a30-85cd-bae25f949b4b`,
    Hardware `ac275f68-fb03-4f16-87cd-73aa65498b02`, datavis `753fee76-8487-482d-aa44-dd21ac51ab42`,
    QOL `86009e66-ff84-4295-976b-96909996c0b5`
  - Reported By `ed10ca8e-a8bc-4017-b283-ad9ab267407e` — who reported it, if known

If a field write is rejected, re-read the schema with
`clickup_get_custom_fields(list_id="901709950598")` — the UUIDs above may have drifted.

**GitHub** — same title, same body, plus a link back and a machine-readable footer:

```bash
gh issue create --repo claireai-inc/opalin --label bug \
  --title '🐛 [BUG] <title>' --body-file <(cat <<'EOF'
<diagnostic body>

---
ClickUp: <task url>
<!-- opalin-triage: clickup_task_id=<task id> -->
EOF
)
```

Then close the loop with `clickup_create_comment` (`entity_type=task`, `entity_id=<task id>`):
`GitHub: <issue url>`.
The footer comment is what lets the fix agent write status back to ClickUp — keep it exact.

## 5. Report

Two lines: the ClickUp task as an inline markdown link (never a bare URL), and the issue
number + URL. Nothing else.

## Guardrails

- One bug per run. Several distinct bugs in one report → file them separately, ask first.
- Never file a duplicate: `gh issue list --repo claireai-inc/opalin --search '<key terms>'`
  and `clickup_search` the title first. A hit → show it and ask before filing.
- The ClickUp task and the GitHub issue always carry the same title and body.

