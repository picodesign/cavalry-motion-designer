# Cavalry Motion Designer

![status: beta](https://img.shields.io/badge/status-beta-orange) ![licence: MIT](https://img.shields.io/badge/licence-MIT-blue)

> **Beta.** This skill is under active development. Expect rough edges, unverified attributes and changes between versions. Feedback and test reports are very welcome.

A skill that turns a coding agent into a senior motion designer for [Cavalry](https://cavalry.studio), the procedural 2D animation app. It is built to work with the Cavalry MCP server, so the agent reads the scene, builds it with JavaScript and checks the result on screen.

> Unofficial community project. Not affiliated with or endorsed by Canva or the Cavalry team. Cavalry is a trademark of its owners.

## What it does

- **Procedural first.** The agent reaches for behaviours, duplicators, falloffs, connections and a shared palette before it places a single keyframe. Keyframes are kept for the few gestures that need them.
- **Art direction built in.** Timing in frames and seconds, easing by intention, reading rhythm, safe zones for 16:9, 9:16, 1:1 and 4:5, and a quality checklist to run before delivery.
- **A working loop with the MCP.** Frame the brief, research the node, preflight the script, execute, then verify with snapshots at several frames and bounding-box sampling.
- **Tested recipes.** Logo reveal, word-by-word tagline, social badges in cascade and a 6 second end-card, all driven by a control null so the timing stays editable.
- **Guard rails.** Known traps of the Cavalry JavaScript API (Y axis up, dotted keyframe keys, connection rules, hidden node types) and limits to flag to the client (Lottie, depth of field, particles).

## Install

You need Cavalry with its MCP server connected to your agent.

```sh
git clone https://github.com/picodesign/cavalry-motion-designer.git
cd cavalry-motion-designer
./install.sh
```

The script copies `skills/cavalry-motion-designer` to `~/.claude/skills/`. Restart your agent session afterwards. To install by hand, copy that folder to the skills directory of your agent.

## Use

Describe the motion you want in plain words, for example:

- "Build a 6 second end-card with the logo, a tagline and three social badges, 1920×1080 at 30 fps."
- "Animate this headline word by word, with a soft overshoot."
- "Make this loop seamless."

The skill activates on mentions of Cavalry, logo reveals, end-cards, text animation, duplicators, behaviours, easing, loops or export.

## Layout

```
skills/cavalry-motion-designer/
├── SKILL.md                      entry point: role, method, rules
└── references/
    ├── motion-principles.md      timing, easing, composition, review checklist
    ├── deliverables-workflows.md briefing, scene structure, export, recipes
    ├── nodes-catalogue.md        nodes by category and an intent-to-node table
    ├── mcp-hints-digest.md       text, sub-mesh, colour, loops, paths, data viz
    └── community-tips.md         tips and pitfalls with sources and reliability tags
```

The reference files are written in French. The entry point loads them on demand, so they cost nothing until the task needs them.

## Status and limits

- Node attributes marked with a check mark in `nodes-catalogue.md` were verified against Cavalry. The others are confirmed by node type only; check them with `get_layer_definition` before relying on them.
- Export formats and licence tiers (ProRes, Lottie) are not settled. Test the export before promising a format.
- Forum, Discord and Reddit threads were not reachable when the research was done. Community tips come from the official docs, articles and public issues.

## Contributing

Corrections, new recipes and verified attributes are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

## Licence

[MIT](LICENSE)

Français : [README.fr.md](README.fr.md)
