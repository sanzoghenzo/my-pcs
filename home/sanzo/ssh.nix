{ ... }:
let
  identityFile = "/home/sanzo/.ssh/id_rsa";
in
{
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
      sveglia = {
        hostname = "192.168.1.209";
        inherit identityFile;
        port = 8022;
      };
    };
  };
}
