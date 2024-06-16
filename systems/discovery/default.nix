{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common
      ../common/podman.nix
      ../common/libvirt.nix
      ./sanzo.nix
    ];

  networking.hostName = "discovery";
  networking.networkmanager.enable = true;
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "extd";
  };

  # nvidia/opengl
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # firmware updates
  services.fwupd.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    libsmbios  # dell fan control
    onlyoffice-bin
    chromium
    kdrive
    htop
  ];
  security.chromiumSuidSandbox.enable = true;
  # needed for kDrive appimage
  security.unprivilegedUsernsClone = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
