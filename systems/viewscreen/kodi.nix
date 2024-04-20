{ config, pkgs, lib, ... }:
{
  users.extraUsers.kodi ={
    isNormalUser = true;
    extraGroups = [ "audio" "video" "input" ];
    linger = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 8080 ];
    allowedUDPPorts = [ 8080 ];
  };
}
