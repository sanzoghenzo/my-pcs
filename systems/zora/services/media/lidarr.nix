{ config, lib, ... }:
let
  cfg = config.mediaServer;
in
{
  config = lib.mkIf cfg.enable {
    services.lidarr = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    proxiedServices.lidarr = {
      port = 8686;
      cert = "staging";
    };
  };
}
