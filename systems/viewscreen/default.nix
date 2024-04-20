{ inputs, lib, config, pkgs, ...}:
{
  imports = [ ./hardware-configuration.nix ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  boot = {
    loader.systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    loader.efi.canTouchEfiVariables = false;
    kernelPackages = pkgs.linuxKernel.packages.linux_hardened;
  };

  # TODO: create autoclean module
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-1w";
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
    ];
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  # };

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
    firewall = {
      allowedTCPPorts = [ 8080 ];
      allowedUDPPorts = [ 8080 ];
    };
  };
  
  users = {
    users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0F+u3b7vu0bxtVSbRHDsIjAa1UjgDTCe/9tIN5uGXhouZMqL+nuMWptEdcygev6fXAupXDntUypZ21vUBVmVcUsxv/Vwpf7gjyTUmlSAaLPPq0R0TPzgL7HEEKsiXVOAKbuHoZlXvjGjupASlnNE3shw7GO/Wb80jjXP+PgoqvpqPud1bl2kGadD6VrgUneplx480ibMLG6CGIw30aEXisbq2N5HbkWYIzpSU8ZqJPCWMnMQ5dvPj9RYtbGh0irlOUcUtEyDcLXZ3kbbNb5pZY2FqUqay9nf5f2K2r66eRXQEHi3JNbg5lanJkvvfriACNtYM9dtRVsfyIuOSETP"
    ];
    groups.multimedia = { };
    extraUsers.kodi = {
      isNormalUser = true;
      extraGroups = [ "multimedia" "audio" ];
    };
  };
  services.openssh.enable = true;
  services.cage = {
    enable = true;
    user = "kodi";
    program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
    environment = { WLR_LIBINPUT_NO_DEVICES = "1"; };
  };

  system.stateVersion = "23.11";
}
