{config, ...}: let
  holodeckIp = config.hostInventory.holodeck.ipAddress;
in {
  proxiedServices = {
    bazarr = {
      port = config.services.bazarr.listenPort;
      cert = "staging";
    };
    books = {
      port = config.services.calibre-web.listen.port;
    };
    torrent = {
      port = config.services.deluge.web.port;
    };
    jackett = {
      port = 9117;
    };
    media = {
      port = 8096;
    };
    wanted = {
      port = config.services.jellyseerr.port;
    };
    lidarr = {
      port = 8686;
    };
    # prowlarr = {
    #   port = 9696;
    # };
    radarr = {
      port = 7878;
    };
    readarr = {
      port = 8787;
    };
    sonarr = {
      port = 8989;
    };
  };
}
