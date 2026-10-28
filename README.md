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

Setup has two parts: connect Cavalry to your agent (once), then install the skill.

### 1. Prerequisites

- **Cavalry 2.8 or later**, running. The skill needs the app open to read and build the scene.
- **The Cavalry MCP server**, connected to your agent. The skill does nothing without it.
- **An agent that supports skills** (a folder with a `SKILL.md`).

### 2. Connect the Cavalry MCP server

The official guide is at <https://cavalry.studio/docs/tips/ai-automation-with-claude/>. In short, for Claude Desktop:

1. Download `cavalry-mcp-server.zip` from that page and unzip it.
2. In Claude, open **Settings > Desktop app > Extensions > Advanced settings > Open extensions folder**.
3. Drag the `cavalry-mcp-server` folder into it, then quit and restart Claude.
4. Back in **Extensions**, click **Configure** on "Cavalry by Canva" and turn it on.
5. In Cavalry, open **Preferences** and check **Enable MCP Server**.

Keep Cavalry and your agent running at the same time. The official page documents Claude Desktop only. For another agent, register the same server through that agent's MCP configuration.

### 3. Install the skill

macOS and Linux:

```sh
git clone https://github.com/picodesign/cavalry-motion-designer.git
cd cavalry-motion-designer
./install.sh
```

Windows (PowerShell):

```powershell
git clone https://github.com/picodesign/cavalry-motion-designer.git
cd cavalry-motion-designer
.\install.ps1
```

Both scripts copy `skills/cavalry-motion-designer` to your user skills folder (`~/.claude/skills` on macOS and Linux, `%USERPROFILE%\.claude\skills` on Windows). Restart your agent session afterwards.

**For one project only**, pass a target folder:

```sh
./install.sh /path/to/your/project/.claude/skills
```

**Without git**, download the repository as a ZIP, unzip it and copy `skills/cavalry-motion-designer` into your agent's skills folder.

### 4. Check that it works

With Cavalry open, ask your agent:

> Can you see the Cavalry MCP server? Then list the layers in my open scene.

If it answers with the layers, the connection works. Then ask for something small to confirm the skill is loaded:

> Create a 2 second title that fades in with an ease, and make the delay adjustable.

A working install builds the title with a control null and an eased animation, then checks the result with a snapshot.

### Update and uninstall

- **Update:** `git pull`, then run the install script again. It replaces the installed copy.
- **Uninstall:** delete the `cavalry-motion-designer` folder from your skills folder.

### Troubleshooting

- **The agent cannot see Cavalry:** make sure Cavalry 2.8 or later is open, **Enable MCP Server** is checked, then restart both apps.
- **The skill never triggers:** restart the agent session and confirm that `cavalry-motion-designer/SKILL.md` sits directly inside the skills folder.
- **A script fails halfway:** Cavalry does not roll back a failed script. Use undo in Cavalry, or ask the agent to delete what it created before retrying.

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
