{ self, config, pkgs, ... }:
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
  ];
  programs.vscode.enable = true;
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Andrea Ghensi";
    userEmail = "andrea.ghensi@gmail.com";
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
      "gitlab.com" = {
        inherit identityFile;
      };
    };
  };
  services.keybase.enable = true;
  services.kbfs.enable = true;
}
