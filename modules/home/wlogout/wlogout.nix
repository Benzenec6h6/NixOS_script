{ config, lib, ... }:

{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "shutdown";
        action = "sleep 1; loginctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "sleep 1; loginctl reboot";
        text = "Reboot";
        keybind = "r";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "loginctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "loginctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono NF", FontAwesome, sans-serif;
        background-image: none;
        transition: 20ms;
      }

      window {
        background-color: rgba(12, 12, 12, 0.15);
      }

      button {
        color: #${config.lib.stylix.colors.base05};
        font-size: 20px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-style: solid;
        background-color: rgba(12, 12, 12, 0.3);
        border: 3px solid #${config.lib.stylix.colors.base05};
        border-radius: 20px;
        margin: 10px;
        padding: 30px;
        box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
      }

      button:hover {
        color: #${config.lib.stylix.colors.base0B};
        background-color: rgba(12, 12, 12, 0.5);
        border: 3px solid #${config.lib.stylix.colors.base0B};
      }

      #shutdown {
        background-image: image(url("icons/shutdown.png"));
      }

      #reboot {
        background-image: image(url("icons/reboot.png"));
      }

      #logout {
        background-image: image(url("icons/logout.png"));
      }

      #suspend {
        background-image: image(url("icons/suspend.png"));
      }

      #lock {
        background-image: image(url("icons/lock.png"));
      }

      #hibernate {
        background-image: image(url("icons/hibernate.png"));
      }
    '';
  };

  # アイコンフォルダを ~/.config/wlogout/icons に配置
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };
}
