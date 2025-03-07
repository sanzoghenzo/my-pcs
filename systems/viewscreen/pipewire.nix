{pkgs, ...}: {
  imports = [../common/services/pipewire.nix];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        DiscoverableTimeout = 0;
        # FastConnectable = "true";
        # Experimental = "true";
        JustWorksRepairing = "always";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  environment.systemPackages = [pkgs.ladspaPlugins];
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
    wireplumber.extraConfig.bluetoothEnhancements."monitor.bluez.properties" = {
      "bluez5.enable-sbc-xq" = true;
      "bluez5.enable-msbc" = false;
      "bluez5.enable-hw-volume" = true;
      "bluez5.auto-connect" = ["a2dp_sink"];
      "bluez5.roles" = [
        "a2dp_sink"
        "a2dp_source"
      ];
    };
  };
}
