(() => {
  const shell = document.querySelector("#player");

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
    url: "./game.swf?v=mobile-dpad-2",
    autoplay: "on",
    unmuteOverlay: "hidden",
    letterbox: "on",
    parameters: { mobile: touchMode ? "1" : "0" }
  }).then(() => player.focus()).catch(() => {
    shell.textContent = "The game could not start. Refresh to try again.";
  });

  async function enterLandscape() {
    player.focus();
    if (!touchMode) return;
    try {
      if (!document.fullscreenElement && player.requestFullscreen) await player.requestFullscreen();
    } catch {}
    try {
      if (screen.orientation?.lock) await screen.orientation.lock("landscape");
    } catch {}
  }

  player.addEventListener("pointerdown", enterLandscape, { once: true });
  player.addEventListener("pointerdown", () => player.focus());
})();
