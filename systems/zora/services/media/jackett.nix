{ config, lib, ... }:
let
  cfg = config.mediaServer;
in
{
  config = lib.mkIf cfg.enable {
    # TODO: replace with prowlarr?
    services.jackett = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    proxiedServices.jackett = {
      port = 9117;
      cert = "staging";
    };
  };
}
