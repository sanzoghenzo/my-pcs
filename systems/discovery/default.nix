{ config, pkgs, ... }:

{
  imports = [
    ../common/base
    ../common/desktop/plasma.nix
    ../users/sanzo.nix
    ./hardware-configuration.nix
    ./virtualization.nix
  ];

  networking.networkmanager.enable = true;

  # nvidia/opengl
  hardware.nvidia.modesetting.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.libva
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
    ];
  };

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # firmware updates
  services.fwupd.enable = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    libsmbios  # dell fan control
    onlyoffice-bin
    chromium
    kdrive
    esphome
  ];
  security.chromiumSuidSandbox.enable = true;
  # needed for kDrive appimage
  security.unprivilegedUsernsClone = true;

  system.stateVersion = "24.05";
}
