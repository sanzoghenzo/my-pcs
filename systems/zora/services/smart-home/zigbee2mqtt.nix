{ config, ... }:
{
  age.secrets.z2m-mqtt-secrets = {
    file = ../../../../secrets/z2m-mqtt-secrets.age;
    name = "z2m-mqtt-secrets.yaml";
    owner = "zigbee2mqtt";
    group = "zigbee2mqtt";
    mode = "440";
  };
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      permit_join = true;
      mqtt = {
        server = "mqtt://localhost:1883";
        user = "root";
        password = "!${config.age.secrets.z2m-mqtt-secrets.path} password";
      };
      advanced = {
        network_key = "GENERATE";
        log_output = [ "console" ];
        log_namespaced_levels."z2m:mqtt" = "warning";
      };
      serial.port = "/dev/ttyACM0";
      frontend.port = 1884;
      homeassistant.enabled = true; # for the transition phase
    };
  };

  proxiedServices.z2m.port = 1884;
}
