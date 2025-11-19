{ config, lib, ... }:

{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "shutdown";
        action = "sleep 1; systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "reboot";
        action = "sleep 1; systemctl reboot";
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
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "lock";
        action = "hyprlock --config ~/.config/hypr/hyprlock/hyprlock.conf";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl start hibernate-dynamic";
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
        background-color: rgba(0, 0, 0, 0.40);  /* ←視認性向上の黒オーバーレイ */
        backdrop-filter: blur(6px);             /* ←背景ぼかしで見える */
      }

      button {
        color: #${config.lib.stylix.colors.base05};
        font-size: 20px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-style: solid;
        background-color: rgba(0, 0, 0, 0.35);  /* ←アイコンが沈まないよう少し暗め */
        border: 3px solid #${config.lib.stylix.colors.base05};
        border-radius: 20px;
        margin: 10px;
        padding: 30px;

        /* ←アイコンの視認性UP (白背景でも黒背景でもOK) */
        filter: drop-shadow(0px 0px 4px rgba(0,0,0,0.80));
      }

      button:hover {
        color: #${config.lib.stylix.colors.base0B};
        background-color: rgba(0, 0, 0, 0.55); /* ←hoverで濃くしてさらに見やすく */
        border: 3px solid #${config.lib.stylix.colors.base0B};
        filter: drop-shadow(0px 0px 6px rgba(0,0,0,1));
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
