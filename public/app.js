(() => {
  const shell = document.querySelector("#player");

  if (!window.RufflePlayer) {
    shell.textContent = "The game player could not load. Refresh to try again.";
    return;
  }

  const ruffle = window.RufflePlayer.newest();
  const player = ruffle.createPlayer();
  player.setAttribute("aria-label", "ERROR 9 TO 5 Flash game");
  shell.replaceChildren(player);

  player.ruffle().load({
    url: "./game.swf",
    autoplay: "on",
    unmuteOverlay: "hidden",
    letterbox: "on"
  }).then(() => player.focus()).catch(() => {
    shell.textContent = "The game could not start. Refresh to try again.";
  });

  player.addEventListener("pointerdown", () => player.focus());
})();
