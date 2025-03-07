{
  config,
  lib,
  ...
}: let
  cfg = config.dailyBackup;
in {
  options.dailyBackup = {
    enable = lib.mkEnableOption "dailyBackup";
    paths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "paths to backup";
      default = [];
    };
    exclude = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "paths to exclude";
      default = [];
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets = {
      restic-env.file = ../secrets/restic-env.age;
      restic-repo.file = ../secrets/restic-repo.age;
      restic-password.file = ../secrets/restic-password.age;
    };

    services.restic.backups = {
      daily = {
        initialize = true;

        environmentFile = config.age.secrets.restic-env.path;
        repositoryFile = config.age.secrets.restic-repo.path;
        passwordFile = config.age.secrets.restic-password.path;

        paths = cfg.paths;

        exclude =
          [
            ".git"
            "log.txt*"
            "*.log"
            "*.log.*"
            "logs.*"
            "*.backup"
            "*/logs/"
            "*/Backups/"
            "*/Sentry"
            "*/node_modules"
            "*/.npm"
          ]
          ++ cfg.exclude;

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];
      };
    };
  };
}
