{
  name,
  port,
  hostname ? "zora",
  targetHost ? "localhost",
  domain ? "sanzoghenzo.com",
  cert ? "production",
}:
{
  services.traefik.dynamicConfigOptions.http = {
    routers.${name} = {
      rule = "Host(`${name}.${domain}`)";
      tls.certResolver = cert;
      service = name;
    };
    services.${name}.loadBalancer.servers = [
      { url = "http://${targetHost}:${builtins.toString port}"; }
    ];
  };
  services.adguardhome.settings.filtering.rewrites = [
    {
      domain = "${name}.${domain}";
      answer = "${hostname}.lan";
    }
  ];
}
