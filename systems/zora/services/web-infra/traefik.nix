{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.webInfra;
in {
  config = lib.mkIf cfg.enable {
    services.traefik = {
      enable = true;
      staticConfigOptions = {
        # tracing.otlp.grpc.insecure = true;
        # metrics.prometheus = true;
        entryPoints = {
          http = {
            address = ":80";
            http.redirections.entryPoint = {
              to = "https";
              scheme = "https";
            };
          };
          https = {
            address = ":443";
          };
        };
        api.dashboard = true;
        api.insecure = true;
        global = {
          checknewversion = false;
          sendanonymoususage = false;
        };
        # This enables self-signed certs between traefik and the services
        serversTransport.insecureSkipVerify = true;
        # log.level = "DEBUG";
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
      8080
    ];
  };
}
