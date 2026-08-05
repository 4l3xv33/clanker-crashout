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
  // Render the very first Ruffle frame in landscape on every touch device.
  // Native fullscreen/orientation lock takes over after the first legal gesture.
  document.documentElement.classList.toggle("orientation-fallback", touchMode);
  player.setAttribute("aria-label", "CLANKER CRASHOUT Flash game");
  player.setAttribute("tabindex", "0");
  shell.replaceChildren(player);

  const focusPlayer = () => {
    const keyboardTarget = !touchMode ? player.shadowRoot?.querySelector("#virtual-keyboard") : null;
    (keyboardTarget || player).focus({ preventScroll: true });
  };
  focusPlayer();

  player.ruffle().load({
    url: "./game.swf?v=clanker-crashout-3",
    autoplay: "on",
    unmuteOverlay: "hidden",
    letterbox: "on",
    contextMenu: "off",
    allowFullscreen: true,
    allowScriptAccess: true,
    parameters: { mobile: touchMode ? "1" : "0" }
  }).then(() => {
    focusPlayer();
    requestAnimationFrame(focusPlayer);
  }).catch(() => {
    shell.textContent = "The game could not start. Refresh to try again.";
  });

  async function lockLandscape() {
    focusPlayer();
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
  player.addEventListener("pointerdown", focusPlayer);
  document.addEventListener("keydown", event => {
    if (event.key !== "Enter") return;
    event.preventDefault();
    event.stopImmediatePropagation();
    if (event.repeat) return;
    try {
      player.ruffle().callExternalInterface("activatePrimaryAction");
    } catch {}
    focusPlayer();
  }, { capture: true });
  screen.orientation?.addEventListener?.("change", () => {
    if (!touchMode) return;
    if (screen.orientation.type.startsWith("landscape")) {
      document.documentElement.classList.remove("orientation-fallback");
      return;
    }
    document.documentElement.classList.add("orientation-fallback");
    if (canNativeLock && (document.fullscreenElement || document.webkitFullscreenElement)) {
      screen.orientation.lock("landscape")
        .then(() => document.documentElement.classList.remove("orientation-fallback"))
        .catch(() => document.documentElement.classList.add("orientation-fallback"));
    }
  });
  player.addEventListener("contextmenu", suppressHold, { capture: true });
})();
