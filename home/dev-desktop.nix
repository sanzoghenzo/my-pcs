# user configuration for development desktop system 
{ pkgs, ... }:
{
  imports = [ ./default.nix ];

  user = {
    enable = true;
    development = true;
    desktop = true;
    virtualisation = true;
  };
}
