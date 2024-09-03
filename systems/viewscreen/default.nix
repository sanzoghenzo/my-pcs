{ inputs, lib, config, pkgs, ...}:
{
  imports = [ 
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ./kodi.nix
    ./acestream.nix
    ./hyperion.nix
    ../common/base
    ../common/root-ssh.nix
    ../common/vm.nix
    # ./disk-config.nix
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
      pkgs.mesa.drivers
    ];
  };

  hardware.alsa.enablePersistence = true;
  environment.systemPackages = [ pkgs.alsa-utils ]; 

  services.upower.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.user == "kodi" && (
        action.id.indexOf("org.freedesktop.upower.") == 0 ||
        action.id.indexOf("org.freedesktop.login1.") == 0 ||
        action.id.indexOf("org.freedesktop.udisks.") == 0
      )) {
        return polkit.Result.YES;
      }
    });
  '';

  networking = {
    interfaces.enp3s0 = {
      wakeOnLan.enable = true;
    };
    nat = {
      enable = true;
      externalInterface = "enp3s0";
    };
    iproute2.enable = true;
  };
  system.stateVersion = "23.11";
}
