{config, ...}: let
  port = 4255;
  svcName = "news";
  cfg = config.webInfra;
  baseUrl = "https://${svcName}.${cfg.domain}/";
  secrets = config.age.secrets;
in {
  age.secrets = {
    miniflux-oauth-id.file = ../../../secrets/miniflux-oauth-id.age;
    miniflux-oauth-secret.file = ../../../secrets/miniflux-oauth-secret.age;
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
      OAUTH2_OIDC_PROVIDER_NAME = "PocketID";
      OAUTH2_USER_CREATION = 1;
      OAUTH2_CLIENT_ID_FILE = secrets.miniflux-oauth-id.path;
      OAUTH2_CLIENT_SECRET_FILE = secrets.miniflux-oauth-secret.path;
    };
  };

  proxiedServices."${svcName}" = {
    port = port;
  };
}
