{config, ...}: let
  holodeckIp = config.hostInventory.holodeck.ipAddress;
in {
  proxiedServices.bazarr = {
    port = config.services.bazarr.listenPort;
    cert = "staging";
  };
  proxiedServices.books = {
    port = config.services.calibre-web.listen.port;
  };
  proxiedServices.torrent = {
    port = config.services.deluge.web.port;
    cert = "staging";
  };
  proxiedServices.jackett = {
    port = 9117;
    cert = "staging";
  };
  proxiedServices.media = {
    port = 8096;
  };
  proxiedServices.wanted = {
    port = config.services.jellyseerr.port;
  };
  proxiedServices.lidarr = {
    port = 8686;
    cert = "staging";
  };
  proxiedServices.prowlarr = {
    port = 9696;
    cert = "staging";
  };
  proxiedServices.radarr = {
    port = 7878;
    cert = "staging";
  };
  proxiedServices.readarr = {
    port = 8787;
    cert = "staging";
  };
  proxiedServices.sonarr = {
    port = 8989;
    cert = "staging";
  };
}
