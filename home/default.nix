{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.user;
in
{
  options.user = {
    enable = lib.mkEnableOption "user";
    name = lib.mkOption {
      type = lib.types.str;
      default = "sanzo";
      description = "User login name.";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Andrea Ghensi";
      description = "Full name of the user.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "andrea.ghensi@gmail.com";
      description = "User email.";
    };
    publicKey = lib.mkOption {
      type = lib.types.str;
      default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs0F+u3b7vu0bxtVSbRHDsIjAa1UjgDTCe/9tIN5uGXhouZMqL+nuMWptEdcygev6fXAupXDntUypZ21vUBVmVcUsxv/Vwpf7gjyTUmlSAaLPPq0R0TPzgL7HEEKsiXVOAKbuHoZlXvjGjupASlnNE3shw7GO/Wb80jjXP+PgoqvpqPud1bl2kGadD6VrgUneplx480ibMLG6CGIw30aEXisbq2N5HbkWYIzpSU8ZqJPCWMnMQ5dvPj9RYtbGh0irlOUcUtEyDcLXZ3kbbNb5pZY2FqUqay9nf5f2K2r66eRXQEHi3JNbg5lanJkvvfriACNtYM9dtRVsfyIuOSETP";
      description = "public SSH key";
    };
    identityFile = lib.mkOption {
      type = lib.types.path;
      default = "/home/${cfg.name}/.ssh/id_rsa";
      description = "Path to the private SSH key";
    };
    desktop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to include desktop apps.
      '';
    };
    development = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to include development apps.
      '';
    };
    virtualisation = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to add access to system virt manager.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      username = cfg.name;
      stateVersion = "24.05";
      packages =
        with pkgs;
        lib.optionals cfg.development [
          devbox
          yq-go
        ]
        ++ lib.optionals cfg.desktop [
          anytype
          blender
          kdrive
          qbittorrent
          onlyoffice-bin
          spotify
        ];
    };

    programs = {
      home-manager.enable = true;
      helix = {
        enable = true;
        defaultEditor = true;
        settings = {
          editor.line-number = "relative";
        };
        # languages = {};
        # themes = {};
        # ignores = [];
      };
      # TODO: https://mynixos.com/home-manager/options/programs.nushell
      nushell.enable = true;
      zellij = {
        enable = true;
        enableBashIntegration = true;
        # settings = {};
      };
      ssh = {
        enable = true;
        matchBlocks = {
          holodeck = {
            hostname = "192.168.1.220";
            identityFile = cfg.identityFile;
          };
          viewscreen = {
            hostname = "192.168.1.224";
            identityFile = cfg.identityFile;
          };
          zora = {
            hostname = "192.168.1.225";
            identityFile = cfg.identityFile;
          };
          "gitlab.com" = {
            identityFile = cfg.identityFile;
          };
          sveglia = {
            hostname = "192.168.1.209";
            identityFile = cfg.identityFile;
            port = 8022;
          };
        };
      };
      direnv = {
        enable = cfg.development;
        enableBashIntegration = true;
        silent = true;
      };
      git = {
        enable = cfg.development;
        userName = cfg.fullName;
        userEmail = cfg.email;
        extraConfig.push.autoSetupRemote = true;
      };
      lazygit.enable = cfg.development;
      vscode.enable = cfg.desktop && cfg.development;
      mpv.enable = cfg.desktop;
      chromium.enable = cfg.desktop;
    };
    services.keybase.enable = cfg.desktop;
    services.kbfs.enable = true;

    dconf.settings = lib.mkIf cfg.virtualisation {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}
