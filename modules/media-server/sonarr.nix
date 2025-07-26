{
  config,
  lib,
  ...
}: let
  cfg = config.mediaServer;
in {
  config = lib.mkIf cfg.enable {
    services.sonarr = {
      enable = cfg.enable;
      group = cfg.group;
      openFirewall = cfg.openPorts;
    };

    dailyBackup.paths = [config.services.sonarr.dataDir];
  };

  # services.sonarr.dataDir + config.xml
  # <Config>
  #   <LogLevel>info</LogLevel>
  #   <EnableSsl>False</EnableSsl>
  #   <Port>8989</Port>
  #   <SslPort>9898</SslPort>
  #   <UrlBase></UrlBase>
  #   <BindAddress>*</BindAddress>
  #   <ApiKey></ApiKey>
  #   <AuthenticationMethod>External</AuthenticationMethod>
  #   <UpdateMechanism>BuiltIn</UpdateMechanism>
  #   <Branch>main</Branch>
  #   <InstanceName>Sonarr</InstanceName>
  #   <LaunchBrowser>False</LaunchBrowser>
  #   <SslCertHash></SslCertHash>
  # </Config>
}
