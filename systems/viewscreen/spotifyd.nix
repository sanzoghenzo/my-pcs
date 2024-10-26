{ lib, pkgs, ... }:
let
  zeroconf_port = 10001;
  globalCfg = {
    backend = "pulseaudio";
    device = "effect_input.normalizer";
    device_name = "viewscreen";
    audio_format = "S32"; # F32, S32, S24, S24_3, S16.
    bitrate = 320;
    device_type = "s_t_b";
    zeroconf_port = zeroconf_port;
    autoplay = true;
    volume_normalisation = false;
    use_mpris = false;
    use_keyring = false;
    initial_volume = "50";
  };
  toml = pkgs.formats.toml { };
  spotifydConf = toml.generate "spotify.conf" {
    global = globalCfg;
  };
in
{
  systemd.user.services.spotifyd = {
    description = "spotifyd, a Spotify playing daemon";
    wantedBy = [ "default.target" ];
    wants = [
      "network-online.target"
      "sound.target"
    ];
    after = [
      "network-online.target"
      "sound.target"
    ];
    environment.SHELL = "/bin/sh";
    serviceConfig = {
      ExecStart = "${pkgs.spotifyd}/bin/spotifyd --no-daemon --cache-path $CACHE_DIRECTORY --config-path ${spotifydConf}";
      Restart = "always";
      RestartSec = 12;
      CacheDirectory = "spotifyd";
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 5353 ]; # mDNS
    allowedTCPPorts = [ zeroconf_port ];
  };
}
