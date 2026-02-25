{ config, pkgs, lib, vars, ... }:
let
  directions = [
    { key = "left";  dir = "l"; }
    { key = "right"; dir = "r"; }
    { key = "up";    dir = "u"; }
    { key = "down";  dir = "d"; }
  ];

  hostConfig = {
    laptop.monitor = [ "eDP-1,1920x1080,0x0,1" ];
    vm.monitor     = [ "Virtual-1,1280x720@60,0x0,1" ];
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$term" = "kitty";
      # モニタ設定
      monitor = hostConfig.${vars.host}.monitor;

      # 起動時に実行するコマンド
      exec-once = [
        "swaync"
        "waybar"
        "fcitx5"
        "qs" # quickshell AGS Desktop Overview alternative
      ];

      # キーバインド例
      bind = [
        "SUPER, Return, exec, $term" # Open terminal
        "SUPER,B,exec,zen"  # Open default browser
        "SUPER,Q,killactive" # kill freeze window
        "SUPER,P,exec,wlogout -p layer-shell" # Power / session menu
        "SUPER,E,exec,thunar" # open file manager
        "SUPER SHIFT, F, fullscreen" # whole full screen
        "SUPER CTRL, F, fullscreen, 1" # fake full screen
        "SUPER, SPACE, togglefloating," #Float Mode
        "SUPER ALT, SPACE, exec, hyprctl dispatch workspaceopt allfloat" #All Float Mode
        "SUPER SHIFT, Return, exec, Dropterminal $term" # Dropdown terminal
        "SUPER CTRL ALT, B, exec, pkill -SIGUSR1 waybar" # Toggle hide/show waybar
        "SUPER,H,exec,KeyBinds" # KeyBinds help
        "SUPER,D,exec,rofi -show drun" # App launcher
        "SUPER, A, global, quickshell:overviewToggle" # desktop overview
        ", Print, exec, screenshot --area"
        ", XF86Calculator, exec, qalculate-gtk" # Open calculator
      ]
        # --- Directional focus / swap ---
        ++ (builtins.concatMap (d: [
          "SUPER,${d.key},movefocus,${d.dir}"
          "SUPER ALT,${d.key},swapwindow,${d.dir}"
        ]) directions)

        # --- Numeric workspaces ---
        ++ (builtins.concatMap (n: 
          let
            ws = toString n;
            key = if n == 10 then "0" else toString n;
          in [
            "SUPER, ${key}, workspace, ${ws}"
            "SUPER SHIFT, ${key}, movetoworkspace, ${ws}"
          ]
        ) (lib.range 1 10)) 
      ++ [
      # --- Workspace cycling / special ---
        "SUPER CTRL,right,workspace,e+1"
        "SUPER CTRL,left,workspace,e-1"
        "SUPER SHIFT,SPACE,movetoworkspace,special"
        "SUPER,SPACE,togglespecialworkspace"
      ];

      bindl =[
        ",XF86AudioRaiseVolume,exec,volume --inc"
        ",XF86AudioLowerVolume,exec,volume --dec"
        "SHIFT,XF86AudioRaiseVolume,exec,volume --inc-fine"
        "SHIFT,XF86AudioLowerVolume,exec,volume --dec-fine"

        ",XF86MonBrightnessDown,exec,brightness --dec"
        ",XF86MonBrightnessUp,exec,brightness --inc"
        "SHIFT,XF86MonBrightnessDown,exec,brightness --dec-fine"
        "SHIFT,XF86MonBrightnessUp,exec,brightness --inc-fine"
        
        ",XF86AudioMute,exec,volume --toggle"
        ",XF86AudioPlay,exec,playerctl play-pause"
        ",XF86AudioPause,exec,playerctl play-pause"
        ",XF86AudioNext,exec,playerctl next"
        ",XF86AudioPrev,exec,playerctl previous"
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

      windowrulev2 = [
        "tag +terminal, class:^(Alacritty|kitty|kitty-dropterm)$"
        #電卓用
        "float, class:^(.*[Cc]alc.*|speedcrunch)$"
        "size 400 600, class:^(.*[Cc]alc.*|speedcrunch)$"
        "center, class:^(.*[Cc]alc.*|speedcrunch)$"

        # 動画壁紙用 mpv だけを対象にする
        "float, class:^(mpv-wallpaper)$"
        "fullscreen, class:^(mpv-wallpaper)$"
        "nofocus, class:^(mpv-wallpaper)$"
        "noinitialfocus, class:^(mpv-wallpaper)$"
        "noblur, class:^(mpv-wallpaper)$"
        "opacity 1.0 1.0, class:^(mpv-wallpaper)$"
      ];
    };
  };
}
