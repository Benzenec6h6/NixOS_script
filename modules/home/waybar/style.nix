{ config, ... }:
{
  programs.waybar.style = ''
    * {
        font-family: "${config.stylix.fonts.monospace.name}";
        font-weight: bold;
        min-height: 0;
        font-size: 97%;
        font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
    }

    window#waybar {
        background-color: transparent;
    }

    /* ツールチップ：Stylixカラーを活用 */
    tooltip {
        background: #${config.lib.stylix.colors.base01};
        border-radius: 12px;
        border: 1px solid #${config.lib.stylix.colors.base03};
        color: #${config.lib.stylix.colors.base07};
    }

    /* センターモジュールのカプセル状デザイン */
    .modules-center {
        background-color: #${config.lib.stylix.colors.base00};
        border-radius: 0px 0px 45px 45px;
        padding: 8px 6px 8px 10px;
    }

    /* 各種モジュールの共通テキスト色 */
    #custom-cava_mviz, #custom-playerctl, #window, #hyprland-window, 
    #custom-swaync, #workspaces, #hyprland-workspaces, #clock, 
    #custom-weather, #idle_inhibitor, #custom-hint, #tray, 
    #network.speed, #network, #group-audio, #group-mobo_drawer, #custom-wlogout {
        color: #${config.lib.stylix.colors.base06};
        padding: 0 6px;
    }

    /* --- 個別カラー設定（アクセント） --- */
    #group-mobo_drawer #temperature.warning,
    #group-mobo_drawer #temperature.critical {
        margin-top: 7px;
        margin-bottom: 7px;
        padding-left: 2px;
        padding-right: 2px;
    }

    #group-mobo_drawer #temperature.warning {
        background-color: #${config.lib.stylix.colors.base0A}; /* Gold */
    }

    #group-mobo_drawer #temperature.critical {
        background-color: #${config.lib.stylix.colors.base08}; /* Red */
    }

    #clock {
        color: #${config.lib.stylix.colors.base0D}; /* Sapphire */
    }

    #idle_inhibitor {
        color: #${config.lib.stylix.colors.base0B}; /* Teal */
    }

    #custom-hint {
        color: #${config.lib.stylix.colors.base09}; /* Peach */
    }

    #custom-swaync {
        color: #${config.lib.stylix.colors.base0A}; /* Gold */
    }

    /* 天気モジュール：動的な色変化 */
    #custom-weather {
        color: #${config.lib.stylix.colors.base0C}; /* デフォルト：Lavender */
    }

    #custom-weather.sunny {
        color: #${config.lib.stylix.colors.base0A}; /* 晴れ：Gold */
    }

    #custom-weather.rain {
        color: #${config.lib.stylix.colors.base0D}; /* 雨：Sapphire */
    }

    #custom-weather.clear-night {
        color: #${config.lib.stylix.colors.base0E}; /* 夜：Purple */
    }

    /* タスクバー & ワークスペース（アニメーション維持） */
    #taskbar button, #workspaces button {
        padding: 0 3px;
        margin: 3px 2px;
        border-radius: 4px;
        color: #${config.lib.stylix.colors.base05};
        background-color: #${config.lib.stylix.colors.base01};
        transition: all 0.2s ease;
        opacity: 0.4;
    }

    #taskbar button.active, #workspaces button.active {
        background: #${config.lib.stylix.colors.base02};
        opacity: 1.0;
        min-width: 30px;
    }

    #taskbar button:hover, #workspaces button:hover {
        color: #${config.lib.stylix.colors.base08};
        background: #${config.lib.stylix.colors.base02};
        opacity: 0.7;
    }
  '';
}