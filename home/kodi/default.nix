{ pkgs, ... }:
let
  kodiAndPlugins = pkgs.kodi-gbm.withPackages (
    kodiPkgs: with kodiPkgs; [
      trakt
      youtube
      libretro
      libretro-2048
      libretro-fuse
      libretro-genplus
      libretro-mgba
      libretro-nestopia
      libretro-snes9x
      controller-topology-project
      iagl
      inputstream-ffmpegdirect
      inputstream-adaptive
      pvr-iptvsimple
      netflix
      jellyfin
      a4ksubtitles
      pkgs.horus
      upnext
      raiplay
      formula1
      skyvideoitalia
      radioparadise
      pkgs.hyperion-kodi
    ]
  );
in
{
  home = {
    username = "kodi";
    homeDirectory = "/home/kodi";
    stateVersion = "23.11";
  };

  # Kodi GBM service
  systemd.user.enable = true;
  systemd.user.services.kodi = {
    Unit.Description = "Kodi media center";
    Install = {
      WantedBy = [ "default.target" ];
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
      # enable webserver and remote control
      services = {
        devicename = "viewscreen";
        esallinterfaces = "true";
        webserver = "true";
        webserverport = "8080";
        webserverauthentication = "false";
        zeroconf = "true";
      };
      # set locale
      locale.country = "Central Europe";
      locale.timezonecountry = "Italy";
      locale.timezone = "Europe/Rome";
      locale.subtitlelanguage = "default";
      audiooutput = {
        # set audio device to hdmi
        audiodevice = "ALSA:@|Default (HDA Intel PCH ALC255 Analog)";
        # don't play sounds
        guisoundmode = "0";
        streamnoise = "false";
      };
      powermanagement = {
        shutdowntime = "120";
      };
      # autoplay next episodes
      videoplayer.autoplaynextitem = "1,2";
      # videoscreen.resolution = "17";
    };
  };

  programs.home-manager.enable = true;
}
