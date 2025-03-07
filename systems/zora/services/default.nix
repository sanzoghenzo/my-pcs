{...}: {
  imports = [
    ./web-infra
    ./smart-home
    ./monitoring
    ./pkm.nix
    ./expose-services.nix
    ./ntfy.nix
  ];

  system.stateVersion = "23.11";
}
