{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.mediaServer;
in {
  options.mediaServer = {
    enable = lib.mkEnableOption "mediaServer";

    mediaDir = lib.mkOption {
      type = lib.types.path;
      default = "/data/media";
      description = "Location of the base multimedia folder.";
    };
    moviesDir = lib.mkOption {
      type = lib.types.path;
      description = "Location of the movies folder.";
      default = "${cfg.mediaDir}/movies";
    };
    seriesDir = lib.mkOption {
      type = lib.types.path;
      description = "Location of the series folder.";
      default = "${cfg.mediaDir}/series";
    };
    musicDir = lib.mkOption {
      type = lib.types.path;
      description = "Location of the music folder.";
      default = "${cfg.mediaDir}/music";
    };
    booksDir = lib.mkOption {
      type = lib.types.path;
      description = "Location of the books folder.";
      default = "${cfg.mediaDir}/books";
    };
    downloadsDir = lib.mkOption {
      type = lib.types.path;
      description = "Location of the downloads folder.";
      default = "${cfg.mediaDir}/downloads";
    };
    openPorts = lib.mkOption {
      type = lib.types.bool;
      description = "Whether to open the ports to the lan.";
      default = false;
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "multimedia";
      description = ''
        Group for the media library.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.mkIf (cfg.group == "multimedia") {
      multimedia = {};
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.mediaDir} 0770 - ${cfg.group} - -"
      "d ${cfg.moviesDir} 0770 - ${cfg.group} - -"
      "d ${cfg.seriesDir} 0770 - ${cfg.group} - -"
      "d ${cfg.musicDir} 0770 - ${cfg.group} - -"
      "d ${cfg.downloadsDir} 0770 - ${cfg.group} - -"
      "d ${cfg.booksDir} 0770 - ${cfg.group} - -"
    ];
  };

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
