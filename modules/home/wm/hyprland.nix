{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # モニタ設定
      monitor = [
        "eDP-1,1920x1080,0x0,1"
        #"Virtual-1,1280x720@60,0x0,1"
      ];

      # 起動時に実行するコマンド
      exec-once = [
        "gnome-keyring-daemon --daemonize --components=pkcs11,secrets,ssh"
        "swaync"
        "waybar"
        "fcitx5"
        "qs" # quickshell AGS Desktop Overview alternative
      ];

      # キーバインド例
      bind = [
        "SUPER,Return,exec,kitty"
        "SUPER,B,exec,zen"  
        "SUPER,Q,killactive"
        "SUPER,P,exec,wlogout -p layer-shell"
        "SUPER,E,exec,thunar"
        "SUPER SHIFT, F, fullscreen" # whole full screen
        "SUPER CTRL, F, fullscreen, 1" # fake full screen
        "SUPER, SPACE, togglefloating," #Float Mode
        "SUPER ALT, SPACE, exec, hyprctl dispatch workspaceopt allfloat" #All Float Mode
        "SUPER SHIFT, Return, exec, Dropterminal $term" # Dropdown terminal
        "SUPER CTRL ALT, B, exec, pkill -SIGUSR1 waybar" # Toggle hide/show waybar
        "SUPER,H,exec,KeyBinds"
        "SUPER,D,exec,rofi -show drun"
        "SUPER, A, global, quickshell:overviewToggle" # desktop overview (if installed)

        ",XF86AudioRaiseVolume,exec,volume --inc"
        ",XF86AudioLowerVolume,exec,volume --dec"
        "SHIFT,XF86AudioRaiseVolume,exec,volume --inc-fine"
        "SHIFT,XF86AudioLowerVolume,exec,volume --dec-fine"

        ",XF86AudioMute,exec,volume --toggle"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl play-pause"
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPrev,exec,playerctl previous"

        ",XF86MonBrightnessDown,exec,brightness --dec"
        ",XF86MonBrightnessUp,exec,brightness --inc"
        "SHIFT,XF86MonBrightnessDown,exec,brightness --dec-fine"
        "SHIFT,XF86MonBrightnessUp,exec,brightness --inc-fine"

        "SUPER,left,movefocus,l"
        "SUPER,right,movefocus,r"
        "SUPER,up,movefocus,u"
        "SUPER,down,movefocus,d"

        "SUPER ALT, left, swapwindow,l"
        "SUPER ALT, right, swapwindow,r"
        "SUPER ALT, up, swapwindow,u"
        "SUPER ALT, down, swapwindow,d"

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

        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.0;
        };
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
    waybar eww #ags
    blueman
    swww mpvpaper
    pavucontrol #playerctl
    grim slurp wf-recorder wl-clipboard
    swappy sound-theme-freedesktop
  ];

}
