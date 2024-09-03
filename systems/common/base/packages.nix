{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    agenix
    bat
    curl
    eza
    fzf
    neovim
    yq-go
  ];
}
