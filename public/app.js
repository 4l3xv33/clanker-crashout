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
  const query = new URLSearchParams(location.search);
  const touchMode = matchMedia("(pointer: coarse)").matches || navigator.maxTouchPoints > 0 || query.has("touch");
  const root = document.documentElement;
  const requestNativeFullscreen = root.requestFullscreen
    ? () => root.requestFullscreen({ navigationUI: "hide" })
    : root.webkitRequestFullscreen
      ? () => root.webkitRequestFullscreen()
      : null;
  const canNativeLock = !!requestNativeFullscreen && typeof screen.orientation?.lock === "function" && !query.has("orientation-fallback");
  document.documentElement.classList.toggle("touch", touchMode);
  document.documentElement.classList.toggle("orientation-fallback", touchMode && !canNativeLock);
  player.setAttribute("aria-label", "ERROR 9 TO 5 Flash game");
  shell.replaceChildren(player);

  player.ruffle().load({
    url: "./game.swf?v=mobile-landscape-6",
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
    var locked = false;
    try {
      if (!document.fullscreenElement && !document.webkitFullscreenElement && requestNativeFullscreen) await requestNativeFullscreen();
    } catch {}
    try {
      if (canNativeLock) {
        await screen.orientation.lock("landscape");
        locked = true;
      }
    } catch {}
    document.documentElement.classList.toggle("orientation-fallback", !locked);
  }

  document.addEventListener("pointerup", lockLandscape, { capture: true, once: true });
  player.addEventListener("pointerdown", () => player.focus());
  screen.orientation?.addEventListener?.("change", () => {
    if (touchMode && canNativeLock && (document.fullscreenElement || document.webkitFullscreenElement) && !screen.orientation.type.startsWith("landscape")) {
      screen.orientation.lock("landscape").catch(() => {});
    }
  });
  player.addEventListener("contextmenu", suppressHold, { capture: true });
})();
