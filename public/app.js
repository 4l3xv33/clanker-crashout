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
    url: "./game.swf?v=mobile-landscape-5",
    autoplay: "on",
    unmuteOverlay: "hidden",
    letterbox: "on",
    contextMenu: "off",
    allowFullscreen: true,
    parameters: { mobile: touchMode ? "1" : "0" }
  }).then(() => player.focus()).catch(() => {
    shell.textContent = "The game could not start. Refresh to try again.";
  });

  async function lockLandscape() {
    player.focus();
    if (!touchMode) return;
    try {
      if (!document.fullscreenElement) await player.requestFullscreen({ navigationUI: "hide" });
    } catch {}
    try {
      if (screen.orientation?.lock) await screen.orientation.lock("landscape");
    } catch {}
  }

  player.addEventListener("pointerdown", lockLandscape, { once: true });
  player.addEventListener("pointerdown", () => player.focus());
  screen.orientation?.addEventListener?.("change", () => {
    if (touchMode && document.fullscreenElement && !screen.orientation.type.startsWith("landscape")) {
      screen.orientation.lock("landscape").catch(() => {});
    }
  });
  player.addEventListener("contextmenu", suppressHold, { capture: true });
})();
