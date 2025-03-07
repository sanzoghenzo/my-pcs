{config, ...}: {
  dailyBackup = {
    enable = true;
    paths = [
      "/var/lib/bazarr"
      "/var/lib/deluge" # declarative setup isn't working
      "/var/lib/jackett"
      "/var/lib/jellyfin"
      "/var/lib/lidarr"
      "/var/lib/radarr"
      "/var/lib/readarr"
      "/var/lib/sonarr"
      # "/var/lib/private/prowlarr"  # not installed
      "/var/lib/private/jellyseerr"
    ];
    exclude = [
      "*/MediaCover/"
      "*/Sentry"
    ];
  };
}
