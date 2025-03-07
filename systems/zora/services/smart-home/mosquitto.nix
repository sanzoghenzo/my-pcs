{config, ...}:
# let
#   domain = "mqtt.sanzoghenzo.com";
#   certDir = config.security.acme.certs."${domain}".directory;
# in
{
  age.secrets.mosquitto-root-password.file = ../../../../secrets/mosquitto-root-password.age;

  # TSL needed only for meross power strip, ignoring
  # this is to acess the cloudflare secret
  # users.groups.traefik.members = [ "acme" ];
  # security.acme = {
  #   acceptTerms = true;
  #   defaults = {
  #     email = "andrea.ghensi@gmail.com";
  #     dnsProvider = "cloudflare";
  #     dnsResolver = "1.1.1.1:53";
  #     credentialFiles = {
  #       CF_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-dns-api-token.path;
  #     };
  #   };
  #   certs."${domain}".keyType = "rsa2048";
  # };

  users.groups.acme.members = ["mosquitto"];
  services.mosquitto = {
    enable = true;
    persistence = true;
    listeners = [
      {
        users.root = {
          acl = ["readwrite #"];
          passwordFile = config.age.secrets.mosquitto-root-password.path;
        };
      }
      # {
      #   # for meross strip
      #   acl = [
      #     "topic readwrite /appliance/#"
      #     "topic readwrite /app/#"
      #   ];
      #   port = 8883;
      #   omitPasswordAuth = true;
      #   settings = {
      #     allow_anonymous = true;
      #     require_certificate = false;
      #     keyfile = "${certDir}/key.pem";
      #     certfile = "${certDir}/cert.pem";
      #     cafile = "${certDir}/chain.pem";
      #     # TODO: test like this
      #     # tls_version = "tlsv1.1";
      #     # ciphers = "ALL:@SECLEVEL=0";
      #     use_username_as_clientid = true;
      #   };
      # }
    ];
  };
  networking.firewall = {
    allowedTCPPorts = [
      1883
      # 8883
    ];
  };

  services.adguardhome.settings.filtering.rewrites = [
    {
      domain = "mqtt.sanzoghenzo.com";
      answer = "192.168.1.225";
    }
  ];
}
