{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/base
    ../common/services/tailscale.nix
    ../common/desktop/plasma.nix
    ../users/sanzo
    ./hardware-configuration.nix
    ./virtualization.nix
  ];

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

  networking.networkmanager.enable = true;
  # firmware updates
  services.fwupd.enable = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    libsmbios # dell fan control
    onlyoffice-bin
    chromium
    kdrive
    esphome
  ];
  security.chromiumSuidSandbox.enable = true;
  # needed for kDrive appimage
  security.unprivilegedUsernsClone = true;

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
