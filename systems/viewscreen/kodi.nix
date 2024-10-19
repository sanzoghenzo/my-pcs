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
        # send audio to normalizer
        audiodevice = "PIPEWIRE:effect_input.normalizer|Normalizer Sink";
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

  environment.systemPackages = [ pkgs.ladspaPlugins ];

  imports = [ ../common/services/pipewire.nix ];
  services.pipewire = {
    extraConfig.pipewire."91-normalizer" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "Normalizer Sink";
            "media.name" = "Normalizer Sink";
            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "compressor";
                  plugin = "${pkgs.ladspaPlugins}/lib/ladspa/sc4_1882.so";
                  label = "sc4";
                  control = {
                    # see this page for info on tweaking these settings 
                    # https://gitlab.com/echoa/pipewire-guides/-/tree/Pipewire-Filter-Chains_Normalize-Audio-and-Noise-Suppression?ref_type=heads#compressor-settings
                    "RMS/peak" = 0;
                    "Attack time (ms)" = 60;
                    "Release time (ms)" = 600;
                    "Threshold level (dB)" = -12;
                    "Ratio (1:n)" = 12;
                    "Knee radius (dB)" = 2;
                    "Makeup gain (dB)" = 12;
                  };
                }
                {
                  type = "ladspa";
                  name = "limiter";
                  plugin = "${pkgs.ladspaPlugins}/lib/ladspa/fast_lookahead_limiter_1913.so";
                  label = "fastLookaheadLimiter";
                  control = {
                    "Input gain (dB)" = 6;
                    "Limit (dB)" = -6;
                    "Release time (s)" = 0.8;
                  };
                }
              ];
              inputs = [
                "compressor:Left input"
                "compressor:Right input"
              ];
              links = [
                {
                  output = "compressor:Left output";
                  input = "limiter:Input 1";
                }
                {
                  output = "compressor:Right output";
                  input = "limiter:Input 2";
                }
              ];
              outputs = [
                "limiter:Output 1"
                "limiter:Output 2"
              ];
            };
            "capture.props" = {
              "node.name" = "effect_input.normalizer";
              "media.class" = "Audio/Sink";
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
            "playback.props" = {
              "node.name" = "effect_output.normalizer";
              "node.passive" = true;
              "audio.channels" = 2;
              "audio.position" = [
                "FL"
                "FR"
              ];
              "node.target" = "alsa_output.target";
            };
          };
        }
      ];
    };
  };
}
