import { existsSync } from "node:fs";
import { spawnSync } from "node:child_process";

const candidates = process.platform === "win32"
  ? ["C:\\HaxeToolkit\\haxe\\haxe.exe", "C:\\Program Files\\HaxeToolkit\\haxe\\haxe.exe", "haxe"]
  : ["haxe"];

const compiler = candidates.find(value => value === "haxe" || existsSync(value));
const result = spawnSync(compiler, ["build.hxml"], { stdio: "inherit", shell: compiler === "haxe" && process.platform === "win32" });
if (result.error) {
  console.error("Haxe 4.3.7 or newer is required. Install it from https://haxe.org/download/.");
  process.exit(1);
}
process.exit(result.status ?? 1);
