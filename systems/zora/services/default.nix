{...}: {
  imports = [
    ./web-infra
    ./smart-home
    ./pkm.nix
    ./expose-services.nix
    ./ntfy.nix
    ./todo.nix
    ./ups
    ./budget.nix
    ./rss.nix
    ./podcasts.nix
    ./seafile.nix
  ];

  system.stateVersion = "23.11";
}
