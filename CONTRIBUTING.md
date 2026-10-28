# Contributing

Thanks for helping improve this skill. The goal is a skill that produces better motion with fewer failed attempts.

## What helps most

- **Verified attributes.** Check a node with `get_layer_definition`, then mark it with a check mark in `nodes-catalogue.md`.
- **Tested recipes.** Add a recipe to `deliverables-workflows.md` only if you ran it in Cavalry and looked at the result at several frames. Say which Cavalry version you used.
- **Pitfalls with a source.** Add them to `community-tips.md` with a link, a date, the Cavalry version and a reliability tag.
- **Corrections.** If a statement is wrong or out of date, fix it and cite the doc or the test that proves it.

## Rules

- Keep `SKILL.md` short. Detail belongs in `references/`, loaded on demand.
- Prefer procedural solutions (behaviours, duplicators, connections, palette) over keyframes in every recipe.
- Never put client names, personal paths or private project data in examples. Use neutral placeholders.
- Test in a new scene, never in someone's working project.
- One topic per pull request, with a short description of what you changed and how you checked it.

## Commit messages

Imperative mood, under 72 characters for the first line, for example `Fix stroke setup order in the badge recipe`.

## Reporting a problem

Open an issue with the Cavalry version, the prompt you gave, what you expected and what happened. Paste the script and the error if there is one.
