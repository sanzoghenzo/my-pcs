{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.radarr = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };
  };

  # services.radarr.dataDir + config.xml
  # <Config>
  #   <BindAddress>*</BindAddress>
  #   <Port>7878</Port>
  #   <SslPort>9898</SslPort>
  #   <EnableSsl>False</EnableSsl>
  #   <LaunchBrowser>False</LaunchBrowser>
  #   <ApiKey></ApiKey>
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
