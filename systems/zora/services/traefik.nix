{
  pkgs,
  lib,
  config,
  ...
}:
# let
#   domain = "sanzoghenzo.com";
#   tailnet = "alpine-crocodile.ts.net";
# in
{
  services.traefik = {
    enable = true;
    staticConfigOptions = {
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
      global = {
        checknewversion = false;
        sendanonymoususage = false;
      };
      # certificatesResolvers.tailscale.tailscale = {};
      certificatesResolvers = {
        staging.acme = {
          email = "andrea.ghensi@gmail.com";
          storage = "${config.services.traefik.dataDir}/acme.json";
          caserver = "https://acme-staging-v02.api.letsencrypt.org/directory";
          dnschallenge = {
            provider = "cloudflare";
            resolvers = [
              "1.1.1.1:53"
              "1.0.0.1:53"
            ];
          };
        };
        production.acme = {
          email = "andrea.ghensi@gmail.com";
          storage = "${config.services.traefik.dataDir}/acme.json";
          dnschallenge = {
            provider = "cloudflare";
            resolvers = [
              "1.1.1.1:53"
              "1.0.0.1:53"
            ];
          };
        };
      };
      log.level = "INFO";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];

  age.secrets.cloudflare-dns-api-token = {
    file = ../../../secrets/cloudflare-dns-api-token.age;
    owner = "traefik";
    group = "traefik";
    mode = "440";
  };
  systemd.services.traefik.environment = {
    CF_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-dns-api-token.path;
  };
}
