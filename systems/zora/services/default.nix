{ ... }:
{
  imports = [
    ./web-infra
    ./media
    ./smart-home
    ./monitoring
    ./pkm.nix
    ./expose-holodeck-services.nix
    ./ntfy.nix
  ];

  system.stateVersion = "23.11";
}
