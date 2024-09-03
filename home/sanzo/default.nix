{ pkgs, ... }:
let
  identityFile = "/home/sanzo/.ssh/id_rsa";
in
{
  home = {
    username = "sanzo";
    # homeDirectory = "/home/sanzo";
    stateVersion = "24.05";
  };
  home.packages = with pkgs; [
    zed-editor
    devbox
    direnv
    lazygit
    anytype
    blender
    qbittorrent
  ];
  programs.vscode.enable = true;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Andrea Ghensi";
    userEmail = "andrea.ghensi@gmail.com";
    extraConfig.push.autoSetupRemote = true;
  };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      holodeck = {
        hostname = "192.168.1.220";
        inherit identityFile;
      };
      viewscreen = {
        hostname = "192.168.1.224";
        inherit identityFile;
      };
      zora = {
        hostname = "192.168.1.225";
        inherit identityFile;
      };
      "gitlab.com" = {
        inherit identityFile;
      };
    };
  };
  services.keybase.enable = true;
  services.kbfs.enable = true;

  programs.mpv = {
    enable = true;
  };

  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
  };
}
