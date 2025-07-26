{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.deluge = {
      enable = cfg.enable;
      group = cfg.group;
      web.enable = true;
      web.openFirewall = cfg.openPorts;
      declarative = true;
      config = {
        enabled_plugins = ["Label"];
        download_location = cfg.downloadsDir;
      };

      # TODO: this gets ignored
      authFile = config.age.secrets.deluge-auth.path;
    };

    age.secrets.deluge-auth = {
      file = ../../secrets/deluge-auth.age;
      owner = "deluge";
      group = cfg.group;
      mode = "440";
    };

    dailyBackup.paths = [config.services.deluge.dataDir];
  };
}
