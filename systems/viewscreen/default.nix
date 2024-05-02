{ inputs, lib, config, pkgs, ...}:
{
  imports = [ 
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ./kodi.nix
    ../common
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
      pkgs.mesa.drivers
    ];
  };

  # using ALSA, we might need pulseaudio/pipewire for libretro
  sound.enable = true;

  services.upower.enable = true;
  security.polkit.enable = true;
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
    hostName = "viewscreen";
    enableIPv6 = false;
    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
    nat = {
      enable = true;
      externalInterface = "eth0";
    };
    iproute2.enable = true;
  };
  system.stateVersion = "23.11";
}
