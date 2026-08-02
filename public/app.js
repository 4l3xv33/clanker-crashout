(() => {
  const shell = document.querySelector("#player");
  const start = document.querySelector("#start-game");
  const status = document.querySelector("#status");
  const focus = document.querySelector("#focus-game");
  const fullscreen = document.querySelector("#fullscreen-game");
  let player;

  function launch() {
    if (player) { player.focus(); return; }
    if (!window.RufflePlayer) {
      status.textContent = "Ruffle did not load. Check the connection and retry.";
      return;
    }
    status.textContent = "Loading the SWF…";
    const ruffle = window.RufflePlayer.newest();
    player = ruffle.createPlayer();
    player.setAttribute("aria-label", "ERROR 9 TO 5 Flash game");
    shell.replaceChildren(player);
    player.ruffle().load({ url: "./game.swf", autoplay: "on", unmuteOverlay: "hidden", letterbox: "on" })
      .then(() => { status.textContent = "Game loaded · click inside, then press Space"; player.focus(); })
      .catch(() => { status.textContent = "The game could not start. Reload the page and try again."; });
  }

  start?.addEventListener("click", launch);
  document.querySelectorAll("[data-play]").forEach(link => link.addEventListener("click", () => setTimeout(launch, 350)));
  focus?.addEventListener("click", () => player?.focus());
  fullscreen?.addEventListener("click", async () => {
    if (!player) launch();
    try { await shell.requestFullscreen(); } catch { status.textContent = "Fullscreen was blocked by the browser."; }
  });
})();
