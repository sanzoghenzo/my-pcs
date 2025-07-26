{...}: {
  imports = [
    ./base-system
    ./base-server.nix
    ./main-user.nix
    ./kodi.nix
    ./home-row-mod.nix
    ./hosts.nix
    ./media-server
    ./backup.nix
    ./monitoring.nix
    ./openthread-border-router.nix
  ];
}
