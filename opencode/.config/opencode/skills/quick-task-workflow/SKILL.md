---
name: quick-task-workflow
description: Use when the user explicitly asks for a lightweight or simple workflow for a small, bounded implementation task.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: feature-development
---

## What I do

Run a short, safe workflow for small implementation tasks: clarify only blocking ambiguity, get approval on an inline spec and plan, implement the complete change, verify it, and prepare an atomic commit with explicit git permission.

## Trigger

Any message like:
- "Use quick workflow for this"
- "Run a simple workflow"
- "Faz pelo fluxo simples"
- "/quick-task add this small change"

Use the full spec and plan workflow instead when the request spans multiple major features, requires architecture decisions, introduces external providers, changes persistence, or has unclear product behavior.

## Workflow

### Step 1: Confirm The Task Fits

Treat "quick" as the shortest safe workflow, not permission to skip workflow. Inspect only the minimum context needed to classify the request.

Use this skill only when the task is small, bounded, and can be completed as one atomic change. If the request contains multiple major workflows or hidden decisions, stop and recommend the full brainstorming/spec/plan workflow.

### Step 2: Ask Only Blocking Questions

Ask a concise question only when implementation would require guessing about scope, behavior, provider choice, data model, security, or user-facing semantics.

If there is no blocking ambiguity, continue without asking.

### Step 3: Propose Inline Spec And Plan

Write a short message in the chat with:
- Objective
- Scope
- Out of scope
- Done criteria
- Plan with 2-5 steps

Ask for approval before editing files. Do not create spec or plan files.

### Step 4: Implement The Whole Approved Task

Make the smallest correct change. Follow existing code style and any domain-specific skill that applies. Do not touch unrelated files or user changes.

### Step 5: Verify

Run the smallest relevant verification command. If no clear verification exists, inspect the change and state that no project verification command was available.

### Step 6: Prepare Commit Safely

Before any non-readonly git action, inspect `git status` and `git diff`. Ask explicit permission before `git add`, `git commit`, branch operations, or push, even if the user asked for automatic commits.

Stage only intended paths and use an atomic conventional commit message.

## Quick Reference

| Situation | Action |
|----------|--------|
| Small bounded task | Use quick workflow |
| Multiple features | Recommend full workflow |
| Missing provider/security/data decision | Ask one blocking question |
| User says "no extra prompts" | Still ask before required git actions |
| Dirty worktree | Preserve unrelated changes |

## Common Mistakes

- Treating "quick" or "simple" as permission to skip approval.
- Silently choosing vendors, data models, billing rules, or analytics events.
- Implementing broad feature bundles instead of decomposing them.
- Staging unrelated dirty worktree changes.
- Committing automatically without explicit git permission.

## Rules

- Keep the inline plan to 2-5 steps.
- Do not create spec or plan files in this workflow.
- Do not use this skill for large, ambiguous, or multi-subsystem work.
- Do not skip applicable domain skills.
- Do not run non-readonly git commands without explicit permission.
