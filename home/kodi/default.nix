{ config, pkgs, ... }:
{
  home = {
    username = "kodi";
    homeDirectory = "/home/kodi";
    stateVersion = "24.05";
  };

  programs.kodi = {
    enable = true;
    package = pkgs.kodi-wayland.passthru.withPackages (kodiPkgs: with kodiPkgs; [
      trakt
      youtube # or invidious?
      netflix
      libretro
      inputstream-ffmpegdirect
      inputstream-adaptive
      pvr-iptvsimple
      jellycon
    ]);
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
