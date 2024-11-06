{
  lib,
  config,
  pkgs,
  ...
}:
{
  # TODO: evaluate nixvirt
  # https://flakehub.com/flake/AshleyYakeley/NixVirt

  imports = [
    ../common/services/podman.nix
    ../common/services/libvirt.nix
  ];

  # VMs will be started manually
  virtualisation.libvirtd = {
    onBoot = "ignore";
    onShutdown = "shutdown";
  };

  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    distrobox
  ];

  services.spice-vdagentd.enable = true;
}
