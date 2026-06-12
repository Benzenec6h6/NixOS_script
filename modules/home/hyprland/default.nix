{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  keybindData = import ./keybinddata.nix {inherit lib vars;};

  mkBind = list:
    map (
      b: let
        # tty属性がある場合は専用のchvt命令を作る
        isTty = b ? tty;

        isPassthrough = !(b ? dispatcher) && !isTty;

        finalDispatcher =
          if isTty
          then "execr"
          else if isPassthrough
          then "exec"
          else if b.dispatcher == "exec"
          then "execr"
          else b.dispatcher;

        finalArg =
          if isTty
          then "sudo chvt ${b.tty}" # ← ここで chvt X に変換する
          else if isPassthrough
          then "true"
          else if b.dispatcher == "exec" && !(lib.hasPrefix "uwsm app --" b.arg)
          then "uwsm app -- ${b.arg}"
          else b.arg;

        cmdPart =
          if finalArg == ""
          then finalDispatcher
          else "${finalDispatcher}, ${finalArg}";
      in "${b.mod}, ${b.key}, ${cmdPart}"
    )
    list;

  # (オプション) ヘルパー用にJSON等を出力する仕組みを作っておくと後が楽です
  keybindsJson = pkgs.writeText "keybinds.json" (builtins.toJSON keybindData);

  hostConfig = {
    laptop.monitor = ["eDP-1,1920x1080,0x0,1"];
    vm.monitor = ["Virtual-1,1280x720@60,0x0,1"];
  };

  nvidiaEnv = [
    "LIBVA_DRIVER_NAME,nvidia" # ハードウェア動画再生支援用
    "__GLX_VENDOR_LIBRARY_NAME,nvidia" # OpenGLアプリをNVIDIAで動かすため
    "NIXOS_OZONE_WL,1" # Electron/Chrome系をWayland対応させる
  ];
in {
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "hyprlang";
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
        #"swaync"
        "waybar"
        "fcitx5"
        "qs" # quickshell AGS Desktop Overview alternative
      ];

      # キーバインド例
      bind = mkBind keybindData.main;
      bindl = (mkBind keybindData.locked) ++ (mkBind keybindData.ttySwitch);

      # キーボードレイアウトの設定
      input = {
        kb_layout = vars.locale.kbLayout; # JISキーボード
        kb_variant = "";
        kb_model = "";
        kb_options = "ctrl:nocaps"; # CapsをCtrlに割り当て例
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

      windowrule = [
        "match:class ^(Alacritty|kitty|kitty-dropterm|ghostty|ghostty-dropterm)$, tag +terminal"

        # 2. 電卓用
        "match:class ^(.*[Cc]alc.*|speedcrunch)$, float 1"
        "match:class ^(.*[Cc]alc.*|speedcrunch)$, size 400 600"
        "match:class ^(.*[Cc]alc.*|speedcrunch)$, center 1"

        # 3. 動画壁紙用 mpv
        "match:class ^(mpv-wallpaper)$, float 1"
        "match:class ^(mpv-wallpaper)$, fullscreen 1"
        "match:class ^(mpv-wallpaper)$, no_focus 1"
        "match:class ^(mpv-wallpaper)$, no_initial_focus 1"
        "match:class ^(mpv-wallpaper)$, no_blur 1"
        "match:class ^(mpv-wallpaper)$, opacity 1.0 1.0"
      ];
    };
  };
}
