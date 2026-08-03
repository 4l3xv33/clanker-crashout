# ROGUE INFERENCE

*Correct the model. Rescue the humans.*

An original five-floor educational platformer about diagnosing broken workplace AI systems. The game is written in Haxe, compiled to a real SWF, and played in current browsers through a pinned Ruffle runtime.

**Play the hosted game:** [https://4l3xv33.github.io/rogue-inference/](https://4l3xv33.github.io/rogue-inference/)

## Player controls

| Input | Action |
| --- | --- |
| WASD / Arrow keys | Move and jump |
| Mouse | Play, enter a floor, continue feedback, or choose an incident response |
| Touch D-pad | Left/right movement, up to jump, center star to interact |
| Touch utility buttons | Open notes, AI Codex, fullscreen, and pause |
| Space | Jump |
| E | Inspect evidence, confront a robot, use stairs |
| G | Open field notes |
| C | Open the AI Codex |
| 1–3 or mouse | Choose an incident response |
| Esc | Pause and settings |
| F | Fullscreen |

Settings include independent music/effects levels, reduced motion, low effects, high contrast, larger text, and larger touch controls. The game pauses when it loses focus. The first touch is captured outside Ruffle to enter fullscreen and apply the browser's native landscape lock; an in-game fullscreen recovery button is also available. CSS rotation is used only as a fallback when native locking is unavailable or rejected, so the two mechanisms never double-rotate the game. Ruffle's menu, long-press browser menus, selection, and callouts are disabled. Progress and preferences are stored locally through Flash shared storage where supported by Ruffle.

## Game structure

Each floor uses a different system mechanic inside the same investigation loop:

1. Traverse fixed hazard tracks and corruption gaps to reach three artifacts.
2. Analyze each artifact using the department's evidence mode.
3. Use the findings to unlock or neutralize the floor's system mechanic.
4. Confront a themed robot boss and remove three corruption nodes.
5. Rescue the coworker, earn a mastery grade, unlock a model card, and attempt the replay challenge.

Sales uses evidence-locked firewalls; HR applies biased-ranking slowdown fields; Marketing contains amplification boosts; Digital Media requires a provenance chain; and the Core uses permission gates. The curriculum covers hallucination and grounding, historical bias and contestability, consent and deceptive marketing, provenance and impersonation, and system-level objectives and least privilege. Floor Select stores best scores and times, while the AI Codex records recovered models and completed challenges.

## Build locally

Install [Haxe 4.3.7](https://haxe.org/download/) and Node.js, then run:

```powershell
npm.cmd install
npm.cmd run build:swf
npm.cmd run prepare-site
npm.cmd run validate
npm.cmd run serve
```

Open the local URL printed by `serve`. Do not test by double-clicking `index.html`; browsers restrict WebAssembly and asset loading under `file://`.

## Architecture

```text
src/
├── Main.hx                 Game state and orchestration
├── data/                   Reviewable floor and incident content
├── entities/               Animated player, robots, coworkers, hazards
├── systems/                Save data, settings, procedural audio
├── ui/                     HUD, prompts, incident and pause interfaces
└── world/                  Department layouts and environmental rendering
```

Editable visual references live in `assets/concept`. The title artwork and the player's normalized animation sheets in `assets/game` are embedded directly into the compiled SWF. The player uses transparent bitmap frame animation for run, jump, interact, scan, and damage states; robots, coworkers, hazards, and environments retain lightweight code-native vector drawing. Source sheets, individual frames, timing metadata, and animated previews live under `assets/game/characters/animations`. The GitHub Pages shell is intentionally game-only and fills the browser viewport without page scrolling.

## Editing educational content

Floor briefings, evidence, questions, answers, consequences, and principles are isolated in `src/data/GameContent.hx`. Every incident question contains:

- Three choices
- One correct choice index
- A direct explanation
- A concrete consequence
- A reusable governing principle

Run `npm.cmd run validate` after content edits. Professional legal, HR, privacy, copyright, responsible-AI, accessibility, and representative-player review remain external release inputs; see `docs/review-checklists.md`.

## Production safeguards

- The production build contains no QA keyboard shortcuts.
- Relative URLs support GitHub project Pages under `/rogue-inference/`.
- Ruffle is pinned through `package-lock.json` and copied during deployment.
- GitHub Actions deploys only from `main`.
- Development work should remain on a branch until browser QA passes.

## Deployment

The workflow in `.github/workflows/pages.yml` installs the pinned Ruffle package, validates the build, and deploys `public/` to GitHub Pages. The compiled SWF is committed intentionally; CI does not need Haxe to publish a reviewed release artifact.
