{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./mosquitto.nix
    ./node-red.nix
    ./zigbee2mqtt.nix
    ./home-assistant.nix
    ./psa-car-controller.nix
  ];
}
