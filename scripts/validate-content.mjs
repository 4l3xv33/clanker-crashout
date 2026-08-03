import { readFile, stat } from "node:fs/promises";

const content = await readFile(new URL("../src/data/GameContent.hx", import.meta.url), "utf8");
const main = await readFile(new URL("../src/Main.hx", import.meta.url), "utf8");
const productionBuild = await readFile(new URL("../build.hxml", import.meta.url), "utf8");
const html = await readFile(new URL("../public/index.html", import.meta.url), "utf8");
const app = await readFile(new URL("../public/app.js", import.meta.url), "utf8");
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
if (main.includes("SPACE  CLOCK IN") || main.includes("PRESS SPACE TO ENTER")) failures.push("Game entry still depends on a Space prompt");

if (failures.length) {
  console.error(failures.map(value => `- ${value}`).join("\n"));
  process.exit(1);
}
console.log(`Validated ${floors} floors, ${questions} incident controls, ${swf.size} byte SWF, and GitHub Pages-safe assets.`);
