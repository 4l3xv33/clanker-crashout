# Error 9 to 5

A five-floor Flash platformer about diagnosing broken workplace AI systems. Explore each department, inspect three evidence terminals, answer a three-part incident case, free a coworker, and climb to the next floor.

## Controls

- **WASD / Arrow keys:** Move and jump
- **E:** Inspect evidence, confront a robot, or use the stairs
- **1–3:** Choose an incident-response answer
- **Space:** Start or continue after feedback

## Build and run

```powershell
haxe build.hxml
npm.cmd install
npm.cmd run prepare-site
npm.cmd run serve
```

The deployable static site is `public/`.
