{
  pkgs,
  lib,
  config,
  ...
}:
let
  mediaDir = "/data/media";
  moviesDir = "${mediaDir}/movies";
  seriesDir = "${mediaDir}/series";
  musicDir = "${mediaDir}/music";
  # booksDir = "${mediaDir}/books";
  group = "multimedia";
in
{
  users.groups.${group} = { };

  systemd.tmpfiles.rules = [
    "d ${mediaDir} 0770 - ${group} - -"
    "d ${moviesDir} 0770 - ${group} - -"
    "d ${seriesDir} 0770 - ${group} - -"
    "d ${musicDir} 0770 - ${group} - -"
    # "d ${booksDir} 0770 - ${group} - -"
  ];

  imports = [
    ./bazarr.nix
    # ./calibre.nix
    ./deluge.nix
    ./jackett.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./lidarr.nix
    # ./prowlarr.nix
    ./radarr.nix
    # ./readarr.nix
    ./sonarr.nix
  ];
}
