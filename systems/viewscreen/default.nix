{ inputs, lib, config, pkgs, ...}:
{
  imports = [ 
    # inputs.nixos-hardware.nixosModules.common-cpu-intel
    ./hardware-configuration.nix
    ./kodi.nix
    ./vm.nix
  ];
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = "nix-command flakes";
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

  # TODO: create reusable autoclean module
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

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
  
  users = {
    users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0F+u3b7vu0bxtVSbRHDsIjAa1UjgDTCe/9tIN5uGXhouZMqL+nuMWptEdcygev6fXAupXDntUypZ21vUBVmVcUsxv/Vwpf7gjyTUmlSAaLPPq0R0TPzgL7HEEKsiXVOAKbuHoZlXvjGjupASlnNE3shw7GO/Wb80jjXP+PgoqvpqPud1bl2kGadD6VrgUneplx480ibMLG6CGIw30aEXisbq2N5HbkWYIzpSU8ZqJPCWMnMQ5dvPj9RYtbGh0irlOUcUtEyDcLXZ3kbbNb5pZY2FqUqay9nf5f2K2r66eRXQEHi3JNbg5lanJkvvfriACNtYM9dtRVsfyIuOSETP"
    ];
  };
  services.openssh.enable = true;

  system.stateVersion = "23.11";
}
