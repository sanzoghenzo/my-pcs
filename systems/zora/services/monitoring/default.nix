{
  config,
  lib,
  ...
}: let
  cfg = config.monitoring;
in {
  options.monitoring = {
    enable = lib.mkEnableOption "monitoring";
  };

  imports = [
    ./prometheus.nix
    ./grafana.nix
    ./loki.nix
    ./influxdb.nix
  ];
}
