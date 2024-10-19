{ pkgs, system, ... }:
{
  environment.systemPackages = with pkgs; [
    agenix
    bat
    curl
    eza
    fzf
    yq-go
  ];
}
