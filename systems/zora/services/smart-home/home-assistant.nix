{config, ...}: let
  dataDir = "/var/lib/homeassistant";
in {
  users.users.hass = {
    home = dataDir;
    createHome = true;
    group = "hass";
    uid = config.ids.uids.hass;
  };

  users.groups.hass.gid = config.ids.gids.hass;

  virtualisation.oci-containers.containers.homeassistant = {
    image = "linuxserver/homeassistant:2024.12.5";
    environment = {
      TZ = "Europe/Rome";
      PUID = toString config.ids.uids.hass;
      PGID = toString config.ids.gids.hass;
    };
    volumes = ["${dataDir}:/config"];
    extraOptions = [
      "--network=host"
    ];
    # ports 5683 tcp/udp, 8123
  };

  networking.firewall.allowedTCPPorts = [
    # 8123 this should't be needed, we'll use the proxy
    5683 # shelly CoIoT
    3483 # slimproto
  ];

  networking.firewall.allowedUDPPorts = [
    5683 # shelly CoIoT
    3483 # slimproto
  ];

  proxiedServices.ha = {
    port = 8123;
  };
}
