{ lib, pkgs, config, ... }:
{
  virtualisation.libvirtd = {
    enable = true;
  };
}

