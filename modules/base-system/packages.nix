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
  ];
  programs = {
    thefuck.enable = true;
    # TODO: starship
  };
}
