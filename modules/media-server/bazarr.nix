{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.bazarr = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    # https://dietpi.com/forum/t/a-stop-job-is-running-for-bazarr-dietpi-when-shutting-down-the-system/19610/10
    systemd.services.bazarr.serviceConfig.KillSignal = "SIGINT";

    dailyBackup.paths = ["/var/lib/bazarr"];
  };

  # /var/lib/${config.systemd.services.bazarr.serviceConfig.StateDirectory} + config.ini
  # config.ini
}
