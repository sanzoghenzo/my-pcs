{ pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      # "cloudflare"
      "default_config"
      # "deluge"
      "esphome"
      "jellyfin"
      "kodi"
      "mqtt"
      "netatmo"
      # "otbr" # open thread border router
      "radarr"
      "roborock"
      "shelly"
      "snmp"
      "sonarr"
      "spotify"
      "zha"
      # "google_assistant"
    ];
    config = {
      default_config = { };
    };
  };
}
