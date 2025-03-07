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
  ];

  # virtualisation.oci-containers.containers = {
  #   psa-car-controller = {
  #     image = "flobz/psa_car_controller";
  #     autoStart = true;
  #     ports = [ "5000:5000" ];
  #     # TODO: bind mount to /config
  #   };
  # };

  # environment.systemPackages = [ pkgs.appdaemon ];
}
