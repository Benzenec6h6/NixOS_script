{ config, pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
        background = "#${config.lib.stylix.colors.base00}";
        foreground = "#${config.lib.stylix.colors.base05}";
        cursor = "#${config.lib.stylix.colors.base05}";
        color0 = "#${config.lib.stylix.colors.base01}";
        color1 = "#${config.lib.stylix.colors.base08}";
        confirm_os_window_close = "0";
        font_family = "JetBrainsMono Nerd Font";
        font_size = "12.0";
        copy_on_select = "yes";
        scrollback_lines = "10000";
        hide_window_decorations = "yes";
        allow_remote_control = "yes";
    };
    keybindings = {
        "ctrl+shift+t" = "new_tab";
        "ctrl+shift+w" = "close_tab";
    };
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  home.file.".config/xfce4/helpers.rc".text = ''
  TerminalEmulator=kitty
  '';

}
