{ pkgs, config, lib, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    settings = [{
      layer = "top";
      position = "top";
      margin = "8px 10px 0px 10px";
      spacing = 10;

      # --- モジュール構成 (左右/中央/右)
      modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "pulseaudio" "network" "cpu" "memory" "tray" ];

      # --- 各モジュール設定
      "hyprland/workspaces" = {
        disable-scroll = true;
        all-outputs = true;
        format = "{icon}";
        format-icons = {
          active = "";
          default = "";
        };
        on-click = "activate";
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 60;
        tooltip = false;
      };

      "clock" = {
        format = "  {:%H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };

      "network" = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈁  {ifname}";
        format-disconnected = "";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      "cpu" = {
        format = "  {usage}%";
      };

      "memory" = {
        format = "  {used:0.1f}G";
      };

      "tray" = {
        spacing = 8;
      };
    }];

    style = ''
      /* === Stylix Waybar Theme === */
      @define-color base00 #${config.lib.stylix.colors.base00};
      @define-color base01 #${config.lib.stylix.colors.base01};
      @define-color base02 #${config.lib.stylix.colors.base02};
      @define-color base03 #${config.lib.stylix.colors.base03};
      @define-color base05 #${config.lib.stylix.colors.base05};
      @define-color accent #${config.lib.stylix.colors.base0D};
      @define-color red    #${config.lib.stylix.colors.base08};
      @define-color green  #${config.lib.stylix.colors.base0B};

      * {
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: 12pt;
        border: none;
        color: @base05;
      }

      window#waybar {
        background: rgba( @base00, 0.7 );
        border-radius: 16px;
        border: 1px solid @base02;
        margin: 6px 10px;
        padding: 4px 10px;
      }

      #workspaces {
        margin-left: 10px;
      }

      #workspaces button {
        padding: 6px 10px;
        margin: 2px;
        border-radius: 12px;
        background: @base01;
        color: @base05;
        transition: background 0.2s, color 0.2s;
      }

      #workspaces button.active {
        background: @accent;
        color: @base00;
      }

      #workspaces button:hover {
        background: @base02;
      }

      #clock, #cpu, #memory, #pulseaudio, #network {
        padding: 0 8px;
        border-radius: 10px;
      }

      #cpu:hover, #memory:hover, #network:hover, #pulseaudio:hover {
        background: @base02;
      }

      #tray {
        margin-right: 8px;
      }
    '';
  };
}
