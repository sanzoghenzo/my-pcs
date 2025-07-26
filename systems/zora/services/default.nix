{...}: {
  imports = [
    ./web-infra
    ./smart-home
    ./expose-services.nix
    ./ntfy.nix
    ./ups
    ./budget.nix
    ./rss.nix
    ./opencloud.nix
    ./immich.nix
  ];

  system.stateVersion = "23.11";
}
