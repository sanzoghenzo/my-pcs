{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common/services/tailscale.nix
    ../common/desktop/plasma.nix
    ./virtualization.nix
  ];

  hostname = "discovery";

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

  networking.networkmanager.enable = true;

  # spotify connect for kodi/viewscreen
  networking.firewall.allowedUDPPorts = [ 5353 ];

  homeRodMod = {
    enable = true;
    devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
  };

  # firmware updates
  services.fwupd.enable = true;

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    libsmbios # dell fan control
    qpwgraph
  ];
  security.chromiumSuidSandbox.enable = true;
  # needed for kDrive appimage if hardened kernel is used
  security.unprivilegedUsernsClone = true;

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
