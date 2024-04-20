{ config, pkgs, ... }: let 
  kodiAndPlugins = pkgs.kodi-gbm.withPackages (kodiPkgs: with kodiPkgs; [
    trakt
    youtube
    libretro
    inputstream-ffmpegdirect
    inputstream-adaptive
    pvr-iptvsimple
    netflix
    jellycon
  ]);
in {
  home = {
    username = "kodi";
    homeDirectory = "/home/kodi";
    stateVersion = "24.05";
  };

  # Kodi GBM service
  systemd.user.enable = true;
  systemd.user.services.kodi = {
    Unit.Description = "Kodi media center";
    Install = {
      WantedBy = ["default.target"];
    };
    Service = {
      Type = "simple";
      ExecStart = "${kodiAndPlugins}/bin/kodi-standalone";
      Restart = "always";
      TimeoutStopSec = "15s";
      TimeoutStopFailureMode = "kill";
    };
  };

  programs.kodi = {
    enable = true;
    package = kodiAndPlugins;
    # addonSettings = {};
    settings = {
      services = {
        devicename = "viewscreen";
        esallinterfaces = "true";
        webserver = "true";
        webserverport = "8080";
        webserverauthentication = "false";
        zeroconf = "true";
      };
    };
  };

  programs.home-manager.enable = true;
}
