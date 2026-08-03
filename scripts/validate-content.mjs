import { readFile, stat } from "node:fs/promises";

const content = await readFile(new URL("../src/data/GameContent.hx", import.meta.url), "utf8");
const main = await readFile(new URL("../src/Main.hx", import.meta.url), "utf8");
const player = await readFile(new URL("../src/entities/Player.hx", import.meta.url), "utf8");
const playerArt = await readFile(new URL("../src/entities/PlayerArt.hx", import.meta.url), "utf8");
const productionBuild = await readFile(new URL("../build.hxml", import.meta.url), "utf8");
const html = await readFile(new URL("../public/index.html", import.meta.url), "utf8");
const app = await readFile(new URL("../public/app.js", import.meta.url), "utf8");
const styles = await readFile(new URL("../public/styles.css", import.meta.url), "utf8");
const swf = await stat(new URL("../public/game.swf", import.meta.url));

const floors = [...content.matchAll(/\bfloor\("/g)].length;
const questions = [...content.matchAll(/\bq\("/g)].length;
const evidenceBlocks = [...content.matchAll(/,"[^\n]+",\[/g)].length;

const failures = [];
if (floors !== 5) failures.push(`Expected 5 floors, found ${floors}`);
if (questions !== 15) failures.push(`Expected 15 questions, found ${questions}`);
if (evidenceBlocks < 5) failures.push("Every floor must declare evidence");
if (swf.size < 1000) failures.push(`SWF is unexpectedly small: ${swf.size} bytes`);
if (main.includes("debug_qa")) failures.push("Production source contains legacy debug_qa");
if (productionBuild.includes("-D qa")) failures.push("Production build enables QA mode");
for (const required of ["./ruffle/ruffle.js", 'id="player"']) {
  if (!html.includes(required)) failures.push(`Website is missing ${required}`);
}
if (!app.includes("./game.swf")) failures.push("Website loader is missing ./game.swf");
if (!main.includes("TitleArt")) failures.push("The generated key art is not embedded in the SWF");
for (const animation of ["run", "jump", "interact", "scan", "damage"]) {
  if (!playerArt.includes(`game-sheets/${animation}.png`)) failures.push(`The ${animation} player animation is not embedded in the SWF`);
}
if (!player.includes('playAction(name:String)') || !main.includes('player.playAction("damage")')) failures.push("Player action animations are not connected to gameplay");
if (!main.includes("TouchControls") || !app.includes('parameters: { mobile:')) failures.push("Mobile touch controls are not connected end to end");
if (!app.includes('contextMenu: "off"')) failures.push("Ruffle context menu is not disabled");
if (!app.includes('orientation.lock("landscape")') || !app.includes("requestFullscreen")) failures.push("Mobile fullscreen landscape lock is not connected");
if (!app.includes('document.addEventListener("pointerup"') || !app.includes("canNativeLock")) failures.push("Landscape lock must capture the first user gesture outside Ruffle");
if (!styles.includes("html.orientation-fallback") || !/transform\s*:\s*rotate/i.test(styles)) failures.push("Unsupported browsers need an isolated landscape fallback");
if (main.includes("SPACE  CLOCK IN") || main.includes("PRESS SPACE TO ENTER")) failures.push("Game entry still depends on a Space prompt");

if (failures.length) {
  console.error(failures.map(value => `- ${value}`).join("\n"));
  process.exit(1);
}
console.log(`Validated ${floors} floors, ${questions} incident controls, ${swf.size} byte SWF, and GitHub Pages-safe assets.`);
