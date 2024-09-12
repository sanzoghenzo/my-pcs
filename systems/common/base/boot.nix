{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    loader.efi.canTouchEfiVariables = false;
    kernelPackages = pkgs.linuxKernel.packages.linux_hardened;
  };
}
