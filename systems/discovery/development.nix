{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fabric-ai
  ];
}
