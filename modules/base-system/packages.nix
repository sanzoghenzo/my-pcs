{
  pkgs,
  system,
  ...
}: {
  environment.systemPackages = with pkgs; [
    agenix
    bat
    curl
    eza
    fzf
    zellij
  ];
  programs = {
    thefuck.enable = true;
    atop.enable = true;
  };
}
