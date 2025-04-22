{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.user;
  hosts = config.hostInventory;
in {
  imports = [./starship.nix ../modules/hosts.nix];

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
      packages = with pkgs;
        lib.optionals cfg.development [
          devbox
          yq-go
          uv
          ollama-cuda
        ]
        ++ lib.optionals cfg.desktop [
          anytype
          blender
          seafile-client
          qbittorrent
          onlyoffice-bin
          spotify
        ]
        ++ lib.optionals (cfg.desktop && cfg.development) [
          mqtt-explorer
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
      nushell = {
        enable = true;
        shellAliases = {
          vi = "hx";
          vim = "hx";
          nano = "hx";
        };
        configFile.source = ./config.nu;
        extraConfig = ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell $spans | from json
          }
          $env.config = {
            show_banner: false,
            completions: {
              case_sensitive: false
              quick: true  # set to false to prevent auto-selecting completions
              partial: true  # set to false to prevent partial filling of the prompt
              algorithm: "fuzzy"  # prefix or fuzzy
              external: {
                # set to false to prevent nushell looking into $env.PATH to find more suggestions
                enable: true
                # set to lower can improve completion performance at the cost of omitting some options
                max_results: 100
                completer: $carapace_completer # check 'carapace_completer'
              }
            }
          }
          $env.PATH = ($env.PATH |
            split row (char esep) |
            prepend /home/${cfg.name}/.apps |
            append /usr/bin/env
          )
          def frontmatter [] {
            lines |
            split list '---' |
            do { |lst|
              let fm = $lst.0 |
                to text | from yaml |
                into value | into record
              {
                frontmatter: $fm
                content: ($lst | skip 1 | to text | str trim)
              }
            } $in
          }
        '';
      };
      carapace.enable = true;
      carapace.enableNushellIntegration = true;

      zellij = {
        enable = true;
        enableBashIntegration = true;
        # settings = {};
      };
      ssh = {
        enable = true;
        matchBlocks = {
          holodeck = {
            hostname = hosts.holodeck.ipAddress;
            identityFile = cfg.identityFile;
          };
          viewscreen = {
            hostname = hosts.viewscreen.ipAddress;
            identityFile = cfg.identityFile;
          };
          zora = {
            hostname = hosts.zora.ipAddress;
            identityFile = cfg.identityFile;
          };
          modem = {
            hostname = hosts.modem.ipAddress;
            user = "root";
          };
          "gitlab.com" = {
            identityFile = cfg.identityFile;
          };
          sveglia = {
            hostname = hosts.sveglia-comodino.ipAddress;
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
      foot = {
        enable = cfg.desktop;
      };
    };
    services.keybase.enable = cfg.desktop;
    services.kbfs.enable = true;

    dconf.settings = lib.mkIf cfg.virtualisation {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
}
