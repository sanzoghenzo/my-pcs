{ pkgs, username, ... }:
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
  
  users.users.${username}.extraGroups = [ "libvirtd" ];
  home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
  
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice 
    spice-gtk
    spice-protocol
  ];

  services.spice-vdagentd.enable = true;
}
