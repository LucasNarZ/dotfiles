---
name: write-doc
description: Create, review, or modify clear module documents, architecture docs, and standards docs. Use whenever the user asks to write a new doc, review or improve an existing one, OR change, update, or fix any existing technical documentation for code, architecture, or team practices — including small edits to a doc that already exists.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: documentation
---

## What I do

Create documentation that lets a developer use, run, and reason about a module, an architecture decision, or a project standard without reading the source or asking the author.

## Core principle

Document **what the reader can observe and depend on**, plus the minimum mental model needed to navigate it. Do not document internal structure for its own sake.

The test: if someone rewrites the internals while keeping the same behavior, the doc should still be correct. A doc that breaks on a refactor was documenting the wrong thing — the same failure mode as a test coupled to implementation.

This has one important consequence. A detail that looks like "implementation" still belongs in the doc when it is *observable or actionable* — for example, "the queue delivers at-least-once, so a handler may see the same message twice." That is not infra trivia; it is behavior the caller must handle. The filter is not internal-vs-external, it is whether the reader needs it to use the thing correctly.

## Trigger

Any message like:

- "Create docs for this module"
- "Write architecture documentation for this feature"
- "Document our coding standards"

Ask for the target audience, source material, or destination path only when missing information would force a guess.

## Workflow

### Step 1: Identify the document type

Classify the request as one of:

- **Module document**: how to use and run a module, its contract, its runtime behavior, and its limits.
- **Architecture document**: system shape, boundaries, tradeoffs, integrations, runtime behavior, and failure modes.
- **Standards document**: required practices, examples, exceptions, verification, and ownership.

If the request is a formal decision record, invoke `adr-generator` instead of writing a free-form architecture document.

### Step 2: Gather source facts

Inspect the relevant code, existing docs, configuration, tests, commands, issue context, or branch diff before writing.

Treat source files and working behavior as the source of truth. Do not invent guarantees, commands, dependencies, or ownership.

Pay special attention to two things that are easy to miss from code alone and matter most to the reader:

- **Side effects and execution semantics** — what the module writes, calls, retries, or enqueues; whether work is sync or async; what happens when the same input arrives twice or when a step fails partway.
- **Surprising values or config** — any constant, threshold, ordering, or setting that a reader would not guess (e.g. an out-of-sequence marker, a `batch_size` of 1). Find the reason; if you cannot, mark it as unexplained rather than inventing one.

If the documentation describes unreleased or release-facing behavior, invoke `changelog-generator` when a changelog entry is needed.

### Step 3: Write the document

Lead with what the reader needs first — how to use and run the thing — and push structure and internals toward the end.

**For module docs, in this order:**

1. **Purpose** — what it does and why it exists, in one or two sentences.
2. **Quick start** — the smallest runnable example or invocation, then how to run, test, or verify it locally. This comes before structure, not after.
3. **Inputs and outputs** — the contract, with concrete examples.
4. **Behavior, side effects, and failure modes** — runtime behavior; what it persists, calls, or emits; retry, duplicate, and idempotency semantics; ordering guarantees; what happens on repeated or failed input. Required for anything with execution semantics, not just for architecture docs.
5. **Dependencies** — what it needs to run, including environment and config.
6. **Entry points** — the file(s) a new developer opens first to orient. A short pointer, not a mirror of the file tree (that couples the doc to structure and rots on a move).
7. **Known constraints and non-obvious decisions** — limits, gotchas, and a one-line "why" for any surprising value or setting.

**For architecture docs, include:**

- Context
- Goals and non-goals
- Components
- Data or request flow
- Tradeoffs
- Operational concerns and failure modes
- Open questions

**For standards docs, include:**

- Scope
- Required practices
- Examples
- Exceptions
- Verification
- Maintenance owner or update trigger

### Step 4: Remove writing slop

Invoke `stop-slop` before delivering or committing prose. Cut filler, vague claims, passive voice, and generic AI phrasing.

### Step 5: Verify usefulness

Check the document against the source and confirm:

- A new developer can run or use the module from the doc alone, without opening the source.
- Commands and paths are accurate.
- For anything with side effects, behavior on repeated or failed input is documented.
- Surprising values, thresholds, or settings are explained, not just stated.
- The document states limits instead of implying unsupported behavior.
- The doc would survive an internals refactor that preserves behavior.
- Related ADRs, changelog entries, or standards docs are linked when relevant.

## Rules

- Always write docs in English unless the user explicitly asks for another language.
- Lead with usage and behavior; keep structure and internals near the end.
- Prefer concrete paths, commands, examples, and constraints over broad explanations.
- Document observable, dependable behavior — not internal organization that a refactor would invalidate.
- Document side effects, retry/idempotency behavior, and failure paths for any module that has them; the happy path alone is not enough.
- Explain surprising values and settings; never restate a magic number without its reason (or an explicit note that the reason is unknown).
- Do not document behavior that is not present in code, tests, configuration, or an approved plan.
- Keep module docs close to the module unless the repository already has a different documentation convention.
- Use `adr-generator` for decision records, `changelog-generator` for release notes or changelog changes, and `stop-slop` for prose cleanup.
