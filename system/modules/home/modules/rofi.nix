{ pkgs, config, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      icon-theme = "Papirus";
      font = "JetBrainsMono Nerd Font Mono 12";
    };
    theme = let inherit (config.lib.formats.rasi) mkLiteral; in {
      "*" = {
        bg = mkLiteral "#${config.stylix.base16Scheme.base00}";
        fg = mkLiteral "#${config.stylix.base16Scheme.base05}";
        selected = mkLiteral "#${config.stylix.base16Scheme.base08}";
      };
      "window" = {
        border-radius = mkLiteral "15px";
        transparency = "real";
      };
    };
  };
}
