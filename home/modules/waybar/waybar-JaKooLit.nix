{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    # configFile / styleFile でそれぞれJSONとCSSを直接埋め込みます。
    settings = [{
      layer = "top";
      position = "top";
      exclusive = true;
      passthrough = false;
      "gtk-layer-shell" = true;

      margin-left = 6;
      margin-right = 6;
      margin-top = 2;

      modules-left = [
        "idle_inhibitor"
        "group/mobo_drawer"
        "hyprland/workspaces#rw"
        "tray"
        "mpris"
      ];

      modules-center = [
        "clock#2"
        "group/notify"
      ];

      modules-right = [
        "hyprland/window"
        "battery"
        "group/audio"
        "custom/wlogout"
      ];

      # モジュール設定例
      "custom/wlogout" = {
        format = "⏻";
        tooltip = false;
        on-click = "wlogout";
      };

      "hyprland/workspaces#rw" = {
        "disable-scroll" = true;
        "all-outputs" = true;
        "warp-on-scroll" = false;
        "sort-by-number" = true;
        "show-special" = false;
        "on-click" = "activate";
        "on-scroll-up" = "hyprctl dispatch workspace e+1";
        "on-scroll-down" = "hyprctl dispatch workspace e-1";
        "persistent-workspaces" = { "*" = 5; };
        "format" = "{icon} {windows}";
        "format-window-separator" = " ";
        "window-rewrite-default" = " ";
        "window-rewrite" = {
          "title<.*amazon.*>" = " ";
          "title<.*reddit.*>" = " ";
          "class<firefox|org.mozilla.firefox>" = " ";
        };
      };

      battery = {
        interval = 10;
        format = "{capacity}% {icon}";
        "format-icons" = [ "" "" "" "" "" ];
        tooltip = true;
        "on-click" = "gnome-power-statistics";
      };

      "clock#2" = {
        interval = 60;
        format = "{:%H:%M}";
        tooltip = false;
      };
    }];

    # CSS（Arch時代のものを適用）
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 12px;
        min-height: 0;
      }

      window#waybar {
        background: #${colors.base00};
        color: #${colors.base05};
      }

      #workspaces button {
        padding: 0 5px;
        color: #${colors.base05};
      }

      #workspaces button.active {
        background: #${colors.base02};
        color: #${colors.base0A};
        border-radius: 6px;
      }

      #custom-wlogout {
        padding-left: 6px;
        padding-right: 6px;
        margin-left: 3px;
        margin-right: 6px;
        color: #${colors.base08};
      }

      #clock {
        color: #${colors.base09};
      }
    '';
  };
}
