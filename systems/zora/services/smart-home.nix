{ pkgs, ... }:
{
  services.home-assistant = {
    enable = true;
    openFirewall = true;
    extraComponents = [
      # "cloudflare"
      "default_config"
      "esphome"
      "jellyfin"
      "kodi"
      "mqtt"
      "netatmo"
      "otbr"
      "radarr"
      "roborock"
      "shelly"
      "snmp"
      "sonarr"
      "spotify"
      "zha"
    ];
    config = {
      default_config = { };
    };
  };

  services.mosquitto.enable = true;
  # TODO: b2un0/silabs-multipan-docker
  # TODO: flobz/psa_car_controller da docker

  # environment.systemPackages = [ pkgs.appdaemon ];
}
