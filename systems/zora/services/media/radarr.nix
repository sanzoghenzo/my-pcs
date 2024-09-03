{ ... }:
{
  services.radarr = {
    enable = true;
    group = "multimedia";
  };

  imports = [
    (import ../expose-service.nix {
      name = "radarr";
      port = 7878;
      cert = "staging";
    })
  ];
  # TODO: dns

  # services.radarr.dataDir + config.xml
  # <Config>
  #   <BindAddress>*</BindAddress>
  #   <Port>7878</Port>
  #   <SslPort>9898</SslPort>
  #   <EnableSsl>False</EnableSsl>
  #   <LaunchBrowser>False</LaunchBrowser>
  #   <ApiKey>c2960dcc88f149d782deb5e7207a7211</ApiKey>
  #   <AuthenticationMethod>External</AuthenticationMethod>
  #   <AuthenticationRequired>Enabled</AuthenticationRequired>
  #   <Branch>master</Branch>
  #   <LogLevel>info</LogLevel>
  #   <SslCertPath></SslCertPath>
  #   <SslCertPassword></SslCertPassword>
  #   <UrlBase></UrlBase>
  #   <InstanceName>Radarr</InstanceName>
  # </Config>
}
