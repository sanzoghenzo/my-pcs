{
  lib,
  config,
  ...
}: let
  cfg = config.user;
  codeFormat = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
  codeStyle = "bg:color_blue";
in {
  config.programs.starship = lib.mkIf cfg.enable {
    enable = true;
    settings = {
      add_newline = true;
      # TODO: https://starship.rs/presets/gruvbox-rainbow
      format = lib.concatStrings [
        "[](color_orange)"
        "$username"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_blue)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "[](fg:color_blue bg:color_bg3)"
        "$docker_context"
        "$conda"
        "[](fg:color_bg3 bg:color_bg1)"
        "$time"
        "[ ](fg:color_bg1)"
        "$line_break$character"
      ];
      palette = "gruvbox_dark";
      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };
      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[ $user ]($style)";
      };
      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          Documents = "󰈙 ";
          Downloads = " ";
          Music = "󰝚 ";
          Pictures = " ";
          Developer = "󰲋 ";
        };
      };
      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };
      git_status = {
        style = "bg:color_aqua";
        format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
      };
      nodejs = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      c = {
        symbol = " ";
        style = codeStyle;
        format = codeFormat;
      };
      rust = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      golang = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      php = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      java = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      kotlin = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      python = {
        symbol = "";
        style = codeStyle;
        format = codeFormat;
      };
      docker_context = {
        symbol = "";
        style = "bg:color_bg3";
        format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
      };
      time = {
        time_format = "%R";
        style = "bg:color_bg1";
        format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
      };
      character = {
        success_symbol = "[➜](bold fg:color_green)";
        error_symbol = "[➜](bold fg:color_red)";
      };
    };
  };
}
