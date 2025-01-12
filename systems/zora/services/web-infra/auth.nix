{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.webInfra;
  fqdname = "auth.${cfg.domain}";
  url = "https://${fqdname}";
in
{
  config = lib.mkIf cfg.enable {
    # rauthy.cfg should have user and group 10001, mode 0600
    # data dir should have user and group 10001, mode 0700
    virtualisation.oci-containers.containers.rauthy = {
      image = "ghcr.io/sebadob/rauthy:0.27.2";
      autoStart = true;
      ports = [ "9080:8080" ];
      environment = {
        MAX_HASH_THREADS = "1";
        RP_ID = fqdname;
        RP_ORIGIN = "${url}:443";
        LISTEN_SCHEME = "https";
        PUB_URL = fqdname;
        RP_NAME = "Sanzo Auth";
        PROXY_MODE = "true";
        TRUSTED_PROXIES = "10.88.0.1/32";
        PEER_IP_HEADER_NAME = "CF-Connecting-IP";
        # TODO ENC_KEYS con chiave, quando voglio cambiarla aggiungo newline e mantengo vecchia chiave
        # ENC_KEY_ACTIVE per segnare la chiave da usare tra quelle di cui sopra (codice fino a /)
        # AUTH_HEADERS_ENABLE = "true";
        BOOTSTRAP_ADMIN_EMAIL = "andrea.ghensi@gmail.com";
        LOG_LEVEL = "debug";
      };
      volumes = [
        "rauthy:/app/data"
      ];
      # BOOTSTRAP_ADMIN_PASSWORD_ARGON2ID='$argon2id$...';
      # environmentFiles = [ age.secrets.rauthy.path ];
    };

    services.traefik.dynamicConfigOptions = {
      http.middlewares.auth.forwardAuth = {
        address = "http://localhost:9080/auth/v1/oidc/forward_auth";
        trustForwardHeader = true;
      };
    };

    proxiedServices.auth = {
      port = 9080;
    };
  };
}
