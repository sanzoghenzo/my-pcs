# basic user configuration for headless systems
{ pkgs, ... }:
{
  imports = [ ./default.nix ];

  user.enable = true;
}
