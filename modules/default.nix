{ ... }:
{
  imports = [
    ./base-system
    ./base-server.nix
    ./main-user.nix
    ./kodi.nix
    ./home-row-mod.nix
  ];
}
