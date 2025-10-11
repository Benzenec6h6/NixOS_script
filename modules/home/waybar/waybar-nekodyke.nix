{ pkgs, config, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;  # Stylixと競合しない標準版

    settings = [{
      layer = "top";
      position = "top";
      margin = "6px 10px 0px 10px";
      spacing = 8;
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [
        "cpu"
        "memory"
        "temperature"
        "network"
        "battery"
        "pulseaudio"
        "tray"
        "custom/wlogout"
      ];

      "hyprland/workspaces" = {
        disable-scroll = true;
        format = "{icon}";
        on-click = "activate";
      };

      "hyprland/window" = {
        format = "{title}";
        max-length = 50;
        tooltip = false;
      };

      "clock" = {
        format = "  {:%H:%M}";
        tooltip-format = "{:%A, %B %d, %Y}";
      };

      "cpu" = {
        format = "  {usage}%";
        tooltip = false;
      };

      "memory" = {
        format = "  {used:0.1f}G";
        tooltip = false;
      };

      "temperature" = {
        critical-threshold = 80;
        format = "  {temperatureC}°C";
      };

      "network" = {
        format-wifi = "  {essid}";
        format-ethernet = "󰈁  {ifname}";
        format-disconnected = "";
        tooltip-format = "{ifname} via {gwaddr}";
      };

      "battery" = {
        format = "{icon} {capacity}%";
        format-icons = ["󰂎" "󰁿" "󰂁" "󰁹" "󰂄"];
        tooltip = false;
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-icons = {
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };

      "tray" = {
        spacing = 6;
      };

      "custom/wlogout" = {
        tooltip = false;
        format = "";
        on-click = "wlogout -p layer-shell";
        interval = "once";
        exec = "echo power";
      };
    }];

    style = ''
      * {
        font-family: ${config.stylix.fonts.monospace.name};
        font-size: 12pt;
        border: none;
        color: #${config.lib.stylix.colors.base05};
      }

      window#waybar {
        background: #${config.lib.stylix.colors.base00};
        border-radius: 12px;
        padding: 6px 10px;
      }

      #workspaces button {
        padding: 4px 8px;
        border-radius: 8px;
        background: transparent;
      }

      #workspaces button.active {
        background: #${config.lib.stylix.colors.base02};
      }

      #custom-wlogout {
        color: #${config.lib.stylix.colors.red};
        margin-left: 5px;
      }
    '';
  };
}
