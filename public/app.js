(() => {
  const shell = document.querySelector("#player");
  const suppressHold = event => event.preventDefault();
  for (const type of ["contextmenu", "selectstart", "dragstart", "gesturestart"]) {
    document.addEventListener(type, suppressHold, { capture: true, passive: false });
  }

  if (!window.RufflePlayer) {
    shell.textContent = "The game player could not load. Refresh to try again.";
    return;
  }

  const ruffle = window.RufflePlayer.newest();
  const player = ruffle.createPlayer();
  const touchMode = matchMedia("(pointer: coarse)").matches || navigator.maxTouchPoints > 0 || new URLSearchParams(location.search).has("touch");
  document.documentElement.classList.toggle("touch", touchMode);
  player.setAttribute("aria-label", "ERROR 9 TO 5 Flash game");
  shell.replaceChildren(player);

  player.ruffle().load({
    url: "./game.swf?v=mobile-static-4",
    autoplay: "on",
    unmuteOverlay: "hidden",
    letterbox: "on",
    contextMenu: "off",
    parameters: { mobile: touchMode ? "1" : "0" }
  }).then(() => player.focus()).catch(() => {
    shell.textContent = "The game could not start. Refresh to try again.";
  });

  player.addEventListener("pointerdown", () => player.focus());
  player.addEventListener("contextmenu", suppressHold, { capture: true });
})();
