{ ... }:
{
  services.sonarr = {
    enable = true;
    group = "multimedia";
  };

  imports = [
    (import ../expose-service.nix {
      name = "sonarr";
      port = 8989;
      cert = "staging";
    })
  ];
  # TODO: dns

  # services.sonarr.dataDir + config.xml
  # <Config>
  #   <LogLevel>info</LogLevel>
  #   <EnableSsl>False</EnableSsl>
  #   <Port>8989</Port>
  #   <SslPort>9898</SslPort>
  #   <UrlBase></UrlBase>
  #   <BindAddress>*</BindAddress>
  #   <ApiKey>2e52e7edc21d4f9084b05807c81eaae9</ApiKey>
  #   <AuthenticationMethod>External</AuthenticationMethod>
  #   <UpdateMechanism>BuiltIn</UpdateMechanism>
  #   <Branch>main</Branch>
  #   <InstanceName>Sonarr</InstanceName>
  #   <LaunchBrowser>False</LaunchBrowser>
  #   <SslCertHash></SslCertHash>
  # </Config>
}
