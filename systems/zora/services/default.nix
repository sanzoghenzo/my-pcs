{...}: {
  imports = [
    ./web-infra
    ./smart-home
    ./monitoring
    ./pkm.nix
    ./expose-services.nix
    ./ntfy.nix
    ./todo.nix
  ];

  system.stateVersion = "23.11";
}
