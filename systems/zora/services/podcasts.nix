{config, ...}: {
  services.audiobookshelf = {
    enable = true;
    port = 6004;
    group = "multimedia";
  };

  proxiedServices.pod = {
    port = config.services.audiobookshelf.port;
  };

  systemd.tmpfiles.rules = [
    "d /data/media/podcasts 0770 - multimedia - -"
  ];
}
