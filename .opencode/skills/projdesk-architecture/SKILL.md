---
name: projdesk-architecture
description: Enforce ProjDesk CLI architectural rules like progressive refinement, modularity, and alias rewards.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  project: projdesk
---

## What I do

- Force any new CLI command to follow the "Progressive Refinement" and "Alias as a Reward" philosophy (e.g., `pd doctor fix` -> `pd dr f`).
- Read docs/ProjDesk-Architecture-Command-Philosophy.md
- Ensure new features are placed in their own modular files inside the `src/` directory, rather than cluttering `init.sh` or `project.sh`.
- Guarantee that the `main()` router in `project.sh` correctly processes semantic arguments, maintaining a clear semantic tree.
- Maintain the strict separation of concerns, separating logic controllers from display views (like `help.sh`).
- Keep the CLI fast, lightweight, and focused on reducing developer friction.

## When to use me

Use this when you are generating new bash scripts, adding new commands, or refactoring the ProjDesk CLI codebase.
Always verify if the proposed command can be shortened to reward experienced users who read the documentation.
