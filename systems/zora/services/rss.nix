{config, ...}: let
  port = 4255;
  svcName = "news";
  cfg = config.webInfra;
  baseUrl = "https://${svcName}.${cfg.domain}/";
  secrets = config.age.secrets;
in {
  age.secrets.miniflux-oauth-secret = {
    file = ../../../secrets/miniflux-oauth-secret.age;
    owner = "miniflux";
    group = "miniflux";
  };

  services.miniflux = {
    enable = true;
    config = {
      PORT = port;
      BASE_URL = baseUrl;
      CREATE_ADMIN = 0;
      DISABLE_LOCAL_AUTH = "true";
      OAUTH2_PROVIDER = "oidc";
      OAUTH2_REDIRECT_URL = "${baseUrl}oauth2/oidc/callback";
      OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.${cfg.domain}";
      OAUTH2_OIDC_PROVIDER_NAME = "Pocket ID";
      OAUTH2_USER_CREATION = 1;
      OAUTH2_CLIENT_ID = "fac48796-39b2-4744-81da-f979be779bca";
      OAUTH2_CLIENT_SECRET_FILE = secrets.miniflux-oauth-secret.path;
    };
  };

  proxiedServices."${svcName}" = {
    port = port;
  };

  # TODO: backup database
}
