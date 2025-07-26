{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    # TODO: replace with prowlarr?
    services.jackett = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    dailyBackup.paths = [config.services.jackett.dataDir];
  };
}
