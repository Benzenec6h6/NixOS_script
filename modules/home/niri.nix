{
  pkgs,
  vars,
  ...
}: {
  # niri-flake の home-manager モジュールを使用することを前提としています
  programs.niri.settings = {
    # 1. 入力設定（JIS配列 & Caps->Ctrl を死守）
    input = {
      keyboard.xkb = {
        layout = "jp";
        options = "caps:ctrl_modifier"; # ユーザーさんのこだわり設定
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
      mouse.natural-scroll = true;
      focus-follows-mouse.enable = true;
    };

    # 2. 起動設定 (spawn-at-startup)
    # ※ UWSMを使っている場合、これらは uwsm 側で管理するのも手ですが
    # ここに書いておけば niri-session 起動時に実行されます。
    spawn-at-startup = [
      {argv = ["waybar"];}
      {argv = ["fcitx5"];}
      {argv = ["swaync"];}
    ];

    # 3. レイアウト設定
    layout = {
      gaps = 8;
      # カラム幅のプリセット (Mod+R で切り替え)
      preset-column-widths = [
        {proportion = 1.0 / 2.0;} # 0.5
        {proportion = 1.0;} # 全画面
      ];
      default-column-width = {proportion = 0.5;};

      focus-ring = {
        enable = true;
        width = 4;
        active.color = "#7aa2f7"; # TokyoNight風の青（お好みで）
      };
    };

    # 4. キーバインド (binds)
    binds = {
      # ターミナル・ブラウザ・ランチャー
      "Mod+Return".action.spawn = ["${vars.user.terminal}"];
      "Mod+B".action.spawn = ["zen"];
      "Mod+D".action.spawn = ["rofi" "-show" "drun"]; # または fuzzel
      "Mod+Q".action.close-window = {};

      # --- 基本操作 ---
      # カラム間移動
      "Mod+Left".action.focus-column-left = {};
      "Mod+Right".action.focus-column-right = {};
      "Mod+H".action.focus-column-left = {}; # Vim風も追加
      "Mod+L".action.focus-column-right = {};

      # カラム内の上下移動（ウィンドウをスタックした時用）
      "Mod+Up".action.focus-window-or-monitor-up = {};
      "Mod+Down".action.focus-window-or-monitor-down = {};

      # 旧 switcher の代わり：Tabでの切り替え
      # Niri native では focus-column-right (or next) が一般的
      "Mod+Tab".action.focus-column-right = {};
      "Mod+Shift+Tab".action.focus-column-left = {};

      # カラム幅のプリセット切り替え
      "Mod+R".action.switch-preset-column-width = {};

      # フルスクリーン・最大化
      "Mod+F".action.maximize-column = {};
      "Mod+Shift+F".action.fullscreen-window = {};

      # カラムの結合・分離 (スタック操作)
      "Mod+Comma".action.consume-window-into-column = {};
      "Mod+Period".action.expel-window-from-column = {};

      # ワークスペース切り替え
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;

      # ワークスペースへの移動
      "Mod+Shift+1".action.move-window-to-workspace = 1;
      "Mod+Shift+2".action.move-window-to-workspace = 2;
      "Mod+Shift+3".action.move-window-to-workspace = 3;

      # Niriの終了（確認ダイアログ付き）
      "Mod+Shift+E".action.quit = {};
    };
  };
}
