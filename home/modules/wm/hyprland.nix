{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # モニタ設定
      monitor = [
        #"eDP-1,1920x1080,0x0,1"
        "Virtual-1, 1280x720@60, 0x0, 1"
      ];

      # 起動時に実行するコマンド
      exec-once = [
        "waybar"
        "fcitx5"
      ];

      # キーバインド例
      bind = [
        "SUPER,Return,exec,kitty"
        "SUPER,Q,killactive,"
        "SUPER,E,exec,thunar"
        "SUPER,F,fullscreen,"
        "SUPER,Space,exec,rofi --show drun"
      ];

      # キーボードレイアウトの設定
      input = {
        kb_layout = "jp";        # JISキーボード
        kb_variant = "";
        kb_model = "";
        kb_options = "caps:ctrl_modifier"; # CapsをCtrlに割り当て例
        follow_mouse = 1;
        sensitivity = 0;
      };

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 8;
          passes = 2;
        };
      };
    };
  };

  # 便利ツール
  home.packages = with pkgs; [
    waybar ags eww
    celluloid
    blueman
    swww mpvpaper
    pavucontrol #playerctl
    grim slurp wf-recorder wl-clipboard
    swappy
    #rofi-wayland #rofi
    #xdg-desktop-portal-hyprland
    #cava
    #xfce.thunar
    #swaynotificationcenter #swaync
  ];

  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    # ここでは config/style を特に書かずデフォルトに任せる
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland; 
    theme = "Arc-Dark";          # デフォルトテーマを指定
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
    };
  };

  programs.playerctl.enable = true;
  programs.cava.enable = true;
  services.swaync.enable = true;
}
