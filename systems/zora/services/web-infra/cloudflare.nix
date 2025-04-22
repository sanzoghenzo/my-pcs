{
  config,
  lib,
  ...
}: let
  cfg = config.webInfra;
in {
  config = lib.mkIf cfg.enable {
    services.traefik.staticConfigOptions = {
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
    };
    age.secrets.cloudflare-dns-api-token = {
      file = ../../../../secrets/cloudflare-dns-api-token.age;
      owner = "traefik";
      group = "traefik";
      mode = "440";
    };
    systemd.services.traefik.environment.CF_DNS_API_TOKEN_FILE =
      config.age.secrets.cloudflare-dns-api-token.path;
  };
}
