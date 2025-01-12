{ config, ... }:
{
  age.secrets = {
    restic-env.file = ../../secrets/restic-env.age;
    restic-repo.file = ../../secrets/restic-repo.age;
    restic-password.file = ../../secrets/restic-password.age;
  };

  services.restic.backups = {
    daily = {
      initialize = true;

      environmentFile = config.age.secrets.restic-env.path;
      repositoryFile = config.age.secrets.restic-repo.path;
      passwordFile = config.age.secrets.restic-password.path;

      paths = [
        "/var/lib/bazarr"
        "/var/lib/containers/storage/volumes"
        "/var/lib/deluge" # declarative setup isn't working
        # "/var/lib/hass"  # if we decide to use it non-dockerized
        "/var/lib/jackett"
        "/var/lib/jellyfin"
        "/var/lib/lidarr"
        "/var/lib/radarr"
        "/var/lib/readarr"
        "/var/lib/silverbullet"
        "/var/lib/sonarr"
        # "/var/lib/private/prowlarr"  # not installed
        "/var/lib/private/jellyseerr"
        "/var/lib/node-red/"
      ];

      exclude = [
        ".git"
        "log.txt*"
        "*.log"
        "*.log.*"
        "logs.*"
        "*.backup"
        "*/logs/"
        "*/Backups/"
        "*/MediaCover/"
        "*/Sentry"
        "/var/lib/silverbullet/silverbullet.db*"
        "/var/lib/silverbullet/_plug"
        "/var/lib/node-red/node_modules"
        "/var/lib/node-red/.npm"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };
}
