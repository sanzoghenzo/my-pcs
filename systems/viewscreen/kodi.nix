{ config, pkgs, ... }:
{
  services.kodi = {
    enable = true;
    openFirewall = true;
    package = pkgs.kodi-gbm.withPackages (p: [
      # video
      p.a4ksubtitles
      p.formula1
      pkgs.horus
      p.inputstream-ffmpegdirect
      p.inputstream-adaptive
      p.jellyfin
      p.netflix
      p.pvr-iptvsimple
      p.raiplay
      p.skyvideoitalia
      p.trakt
      p.upnext
      p.youtube

      # audio
      p.radioparadise

      # gaming
      p.iagl
      p.infotagger # missing dep for iagl
      p.joystick
      p.libretro-genplus
      p.libretro-mgba
      p.libretro-snes9x
      p.libretro-fuse
      p.libretro-nestopia
      p.controller-topology-project

      # misc
      pkgs.hyperion-kodi
    ]);

    settings = {
      # addons managed by nix
      general = {
        addonupdates = 2;
        addonnotifications = false;
      };
      locale = {
        conutry = "Central Europe";
        timezonecountry = "Italy";
        timezone = "Europe/Rome";
        subtitlelanguage = "default";
      };
      # lookandfeel = {
      #   # some kids media requires CJK font
      #   font = "CJK - Spoqa + Inter";
      # };
      services = {
        devicename = config.networking.hostName;
        webserver = true;
        webserverport = 8080;
        webserverauthentication = false;
        webserverusername = "kodi";
        webserverpassword = "";
        webserverssl = false;
        zeroconf = true;
        esallinterfaces = true;
      };
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

  hardware.graphics = {
    enable = true;
    extraPackages = [
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
      pkgs.mesa.drivers
    ];
  };

  hardware.alsa.enablePersistence = true;
  environment.systemPackages = [ pkgs.alsa-utils ];

  services.upower.enable = true;
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
}
