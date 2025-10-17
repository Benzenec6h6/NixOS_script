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
        background = mkLiteral "#${config.lib.stylix.colors.base00}";
        foreground = mkLiteral "#${config.lib.stylix.colors.base05}";
      };

      "window" = {
        border-radius = mkLiteral "15px";
        background-color = mkLiteral "#${config.lib.stylix.colors.base00}";
      };

      "element selected" = {
        background-color = mkLiteral "#${config.lib.stylix.colors.base08}";
        text-color = mkLiteral "#${config.lib.stylix.colors.base00}";
      };
    };
  };
}
