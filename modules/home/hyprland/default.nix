{ config, pkgs, lib, vars, ... }:
let
  keybindData = import ./keybinddata.nix { inherit lib vars; };
  
  # ヘルパー関数: 定義リストをHyprlandの形式 "MOD, KEY, DISPATCHER, ARG" に変換
  mkBind = list: map (b: 
    let 
      cmdPart = if b.arg == "" then b.dispatcher else "${b.dispatcher}, ${b.arg}";
    in "${b.mod}, ${b.key}, ${cmdPart}"
  ) list;

  # (オプション) ヘルパー用にJSON等を出力する仕組みを作っておくと後が楽です
  keybindsJson = pkgs.writeText "keybinds.json" (builtins.toJSON keybindData);

  hostConfig = {
    laptop.monitor = [ "eDP-1,1920x1080,0x0,1" ];
    vm.monitor     = [ "Virtual-1,1280x720@60,0x0,1" ];
  };

  nvidiaEnv = [
    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "AQ_DRM_DEVICES,/dev/dri/card0"
    "NVD_BACKEND,direct"
  ];
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"]; 
    };
    settings = {
      env = lib.optionals (vars.host == "laptop") nvidiaEnv;
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
      bind = mkBind keybindData.main;
      bindl = mkBind keybindData.locked;

      # キーボードレイアウトの設定
      input = {
        kb_layout = vars.locale.kbLayout;        # JISキーボード
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
        gaps_out = 5;
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
