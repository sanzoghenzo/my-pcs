{
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  cfg = config.monitoring;
in {
  config = lib.mkIf cfg.enable {
    services.netdata = {
      enable = true;
      package = pkgs.netdata.override {
        withCloudUi = true;
      };
      config.global = {
        "update every" = 15;
      };
    };

    networking.firewall.allowedTCPPorts = [19999];
  };

  options = {
    monitoring = {
      enable = lib.mkEnableOption "monitor the system";
    };
  };
}
