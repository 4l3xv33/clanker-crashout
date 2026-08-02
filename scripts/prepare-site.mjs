import { cp, mkdir, rm } from "node:fs/promises";
const source = new URL("../node_modules/@ruffle-rs/ruffle/", import.meta.url);
const target = new URL("../public/ruffle/", import.meta.url);
await rm(target, { recursive: true, force: true });
await mkdir(target, { recursive: true });
await cp(source, target, { recursive: true });
console.log("Pinned Ruffle runtime copied into public/ruffle");

