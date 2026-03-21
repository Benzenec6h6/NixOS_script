{ pkgs, vars, ... }:

{
  programs.niri = {
    enable = true;
    settings = {
      # 入力設定（JIS配列とCaps->Ctrlは死守）
      input = {
        keyboard.xkb = {
          layout = "jp";
          options = "caps:ctrl_modifier";
        };
        touchpad.natural-scroll = true;
      };

      # 起動時に最低限必要なもの
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "fcitx5" ]; }
        { command = [ "swaync" ]; }
      ];

      # レイアウト（niriの肝：カラムの幅）
      layout = {
        gaps = 8;
        preset-column-widths = [
          { proportion = 0.5; } # 半分
          { proportion = 1.0; } # 全画面（横いっぱい）
        ];
        default-column-width = { proportion = 0.5; };
      };

      # 最小限のキーバインド（ModはSUPER想定）
      binds = let
        sh = cmd: { spawn = [ "sh" "-c" cmd ]; };
      in {
        "Mod+Return".action = { spawn = [ "${vars.user.terminal}" ]; };
        "Mod+B".action = { spawn = [ "zen" ]; };
        "Mod+D".action = { spawn = [ "rofi" "-show" "drun" ]; };
        "Mod+Q".action = { close-window = null; };

        # --- niriの基本操作：ここを指に叩き込む ---
        # 1. カラム（ウィンドウ）間の移動
        "Mod+Left".action = { focus-column-left = null; };
        "Mod+Right".action = { focus-column-right = null; };
        
        # 2. カラムの幅を変える（preset-column-widthsを回る）
        "Mod+R".action = { switch-preset-column-width = null; };
        
        # 3. ウィンドウを「一つの列」にまとめる（上下に並ぶ）
        "Mod+Comma".action = { consume-window-into-column = null; };
        "Mod+Period".action = { expel-window-from-column = null; };

        # 4. ワークスペース切り替え（1〜3程度で試す）
        "Mod+1".action = { focus-workspace = 1; };
        "Mod+2".action = { focus-workspace = 2; };
        "Mod+3".action = { focus-workspace = 3; };
      };
    };
  };
}
