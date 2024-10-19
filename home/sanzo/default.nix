{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
  ];

  home = {
    username = "sanzo";
    # homeDirectory = "/home/sanzo";
    stateVersion = "24.05";
  };
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    devbox
    anytype
    blender
    qbittorrent
  ];
  programs.vscode.enable = true;
  programs.direnv.enable = true;
  programs.git = {
    enable = true;
    userName = "Andrea Ghensi";
    userEmail = "andrea.ghensi@gmail.com";
    extraConfig.push.autoSetupRemote = true;
  };
  programs.lazygit.enable = true;
  programs.helix = {
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
  programs.nushell.enable = true;
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    # settings = {};
  };

  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs.mpv = {
    enable = true;
  };

}
