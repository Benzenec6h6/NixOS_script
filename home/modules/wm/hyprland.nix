{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # モニタ設定
      monitor = [
        #"eDP-1,1920x1080,0x0,1"
        #"Virtual-1, 1280x720@60, 0x0, 1"
      ];

      # 起動時に実行するコマンド
      exec-once = [
        "waybar"
        "fcitx5"
      ];

      # キーバインド例
      bind = [
        "SUPER,Return,exec,kitty"
        "SUPER,B,exec,zen"  
        "SUPER,Q,killactive"
        "SUPER,E,exec,thunar"
        "SUPER,F,fullscreen"
        "SUPER SHIFT,F,togglefloating,"
        "SUPER,H,exec,~/.config/hypr/help_shortcuts.sh"
        "SUPER,D,exec,rofi -show drun"

        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "SHIFT,XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+"
        "SHIFT,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"

        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl play-pause"
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPrev,exec,playerctl previous"

        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86MonBrightnessUp,exec,brightnessctl set +5%"
        "SHIFT,XF86MonBrightnessDown,exec,brightnessctl set 1%-"
        "SHIFT,XF86MonBrightnessUp,exec,brightnessctl set +1%"

        "SUPER, left, swapwindow,l"
        "SUPER, right, swapwindow,r"
        "SUPER, up, swapwindow,u"
        "SUPER, down, swapwindow,d"

        "SUPER,1,workspace,1"
        "SUPER,2,workspace,2"
        "SUPER,3,workspace,3"
        "SUPER,4,workspace,4"
        "SUPER,5,workspace,5"
        "SUPER,6,workspace,6"
        "SUPER,7,workspace,7"
        "SUPER,8,workspace,8"
        "SUPER,9,workspace,9"
        "SUPER,0,workspace,10"

        "SUPER SHIFT,1,movetoworkspace,1"
        "SUPER SHIFT,2,movetoworkspace,2"
        "SUPER SHIFT,3,movetoworkspace,3"
        "SUPER SHIFT,4,movetoworkspace,4"
        "SUPER SHIFT,5,movetoworkspace,5"
        "SUPER SHIFT,6,movetoworkspace,6"
        "SUPER SHIFT,7,movetoworkspace,7"
        "SUPER SHIFT,8,movetoworkspace,8"
        "SUPER SHIFT,9,movetoworkspace,9"
        "SUPER SHIFT,0,movetoworkspace,10"

        "CTRL ALT,right,workspace,e+1"
        "CTRL ALT,left,workspace,e-1"
        "SUPER,mouse_down,workspace,e+1"
        "SUPER,mouse_up,workspace,e-1"
        "SUPER SHIFT,SPACE,movetoworkspace,special"
        "SUPER,SPACE,togglespecialworkspace"
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

  programs.cava.enable = true;
  programs.wlogout.enable = true;
  services.swaync.enable = true;
  services.playerctld.enable = true;
}
