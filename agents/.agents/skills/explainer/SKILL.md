---
name: "explainer"
description: "Distill a paper, library's docs, or any dense technical markdown/webpage into a short, high-signal explanation for a robotics/ML founding engineer. Use when asked to explain, summarize, break down, or 'make sense of' a paper, library, RFC, or spec. Not for ingestion — assumes the content is already available as markdown or a URL the agent can read."
---

# Explainer

**Tier:** POWERFUL
**Category:** Learning / Communication
**Domain:** Research & engineering comprehension

## Problem this fixes

Default model explanations fail two ways: they're **too long** (restate the whole source instead of the part that matters), and they attend to **the wrong details** (notation, related-work laundry lists, hyperparameter tables) instead of the 1-3 things that actually change what the reader does next. This skill is a discipline for avoiding both, not a formatting template to fill in on autopilot.

The reader is a founding engineer in robotics (software + ML): strong fundamentals, no patience for re-derivation of things they already know, reading to decide "do I use this / how / what breaks." Calibrate to that reader, not a general audience.

## The four filters (apply before writing a single word)

Run the source through these, silently, before drafting. Everything you keep must survive all four:

1. **Claim filter** — What is the one sentence this source is actually arguing or providing? (Not "what is it about" — what does it *claim* or *do*.)
2. **Mechanism filter** — What is the smallest correct model of *how* it achieves that claim? Not the full derivation — the part that would be wrong to omit because the reader would misuse the result without it.
3. **Delta filter** — What's actually new versus what the reader already assumes as background? Skip re-explaining the baseline; state only the diff.
4. **Relevance filter** — Given this reader builds robotics/ML systems, what does this change about a decision they'd make (build vs. buy, which method to reach for, what to watch out for, what it costs)? If nothing, say so plainly instead of padding.

If a detail doesn't survive all four, it doesn't go in the first pass. It can be offered as an optional expansion (see Depth ladder).

## Cognitive grounding (why this works — apply, don't cite)

- **Cut extraneous load, keep germane load** (Sweller): strip anything that costs the reader attention without building a transferable model — but don't strip the one non-obvious mechanism that *is* the transferable model.
- **Inverted pyramid**: lead with the claim/answer. Justification, mechanism, and caveats come after, in decreasing order of importance. A reader who stops after sentence one should still have the core takeaway.
- **Concrete before abstract**: one worked example or number beats a paragraph of general description. If the source has a headline number (accuracy, latency, sample efficiency, FLOPs), lead with it over prose.
- **Analogy only if load-bearing and accurate**: an analogy to something the reader already knows (a control-theory concept, a familiar library, a known algorithm) speeds transfer — but a cute analogy that misleads on the actual mechanism is worse than none. Skip it rather than force one.
- **Progressive disclosure over front-loading**: don't pre-answer questions the reader hasn't asked. Give the compressed version and an explicit path to expand, rather than dumping everything because it might be relevant.

## Do not include (default off, unless the relevance filter demands it)

- Historical context / related-work survey
- Full notation walkthrough or derivation
- Exhaustive hyperparameters, ablation tables, dataset stats
- Author affiliations, funding, publication venue
- Restating the question back to the reader
- Hedging phrases ("it's worth noting that", "in essence", "at its core") — just say the thing
- Anything the reader already knows cold (standard RL/optimization/ROS/kinematics background) — reference it by name, don't re-teach it

## Output shape

Lead with a **1-3 sentence TL;DR**: the claim + the one-line "so what for you." This is not optional and not a preview — a reader who reads only this line should walk away with the core idea and whether it's worth their time.

After the TL;DR, use whichever of these two shapes fits, and only the sections that survive the filters — don't pad to hit a template:

**For a paper / method:**
- **Core idea** — the mechanism, in plain language, 1 short paragraph or a few bullets. One concrete example or number if the source has one.
- **What's actually new** — the delta vs. prior approaches, one line, only if non-obvious.
- **Where this matters for you** — when you'd reach for this, what it'd cost/save, what breaks or degrades it. This is the section most worth getting right.
- **Skip if you're not going to implement it**: anything below the mechanism (proofs, ablations).

**For a library / API / tool:**
- **Mental model** — the 2-3 concepts you must hold to use it correctly (not the full API surface).
- **Minimal example** — the smallest snippet that does something real, not "hello world."
- **Where it differs from what you already know** — if there's a comparable tool/pattern the reader likely knows, state the delta, not a feature list.
- **Gotchas** — only the ones that would actually bite (footguns, version traps, perf cliffs), not a disclaimer list.

Default length: well under what the source "deserves." Aim for something readable in under a minute unless the reader asks to go deeper. Prefer bullets and short paragraphs; no headers-for-headers'-sake.

## Depth ladder

Don't try to guess every follow-up and pre-answer it. End with a **specific, named offer** to expand — not a generic "let me know if you want more":

> Want the derivation of X, the full comparison to Y, or the failure modes under Z?

Naming the actual expandable pieces (not "more detail") proves you already know what's in the source and lets the reader pull exactly the thread they need.

## Format: chat vs. artifact

Default to a **plain chat reply** — most explanations are read once and don't need a persisted document. Only produce an artifact/saved note when either is true:
- The reader says they'll want to reference this again (a paper they're implementing, a library they're onboarding onto over days), or
- The source is long enough that a structured reference (with the option to jump to sections) beats linear chat text.

When in doubt, default to chat. An artifact for a two-paragraph answer is worse than the answer.

## Self-check before sending

Read your own draft once against these; cut anything that fails:

1. If I deleted this sentence, would the reader be missing something that changes what they do? If not, cut it.
2. Does the first sentence alone give the claim and the "so what"? If not, rewrite the opening.
3. Did I re-explain anything a robotics/ML engineer already knows cold? If so, cut it and reference it by name instead.
4. Is there a vague adjective ("significant", "much better", "efficient") standing in for a number the source actually gives? Replace it.
5. Would this read as short if I saw it, cold, with no context on how hard the source was to compress? If not, cut more.
