{ config, pkgs, ... }: {
  programs.cava = {
    enable = true;

    settings = {
      general = {
        # 見た目のチューニング
        bar_width = 2;
        bar_spacing = 1;
        frame_rate = 60;
        autosens = 1;  # 自動感度調整
        sleep_timer = 0;
        # Hyprland や sway で透過を有効にする
        # cava側では"background = "none""で透過を指定
        # (ただしターミナル側が透過対応している必要あり)
        background = "none";
        # FFT処理設定 (より滑らかな表示)
        smoothing = "monstercat";
      };

      color = {
        gradient = 1;

        # Stylix の Base16 カラーパレットを自動参照
        gradient_color_1 = config.lib.stylix.colors.base00;
        gradient_color_2 = config.lib.stylix.colors.base01;
        gradient_color_3 = config.lib.stylix.colors.base02;
        gradient_color_4 = config.lib.stylix.colors.base03;
        gradient_color_5 = config.lib.stylix.colors.base04;
        gradient_color_6 = config.lib.stylix.colors.base05;
        gradient_color_7 = config.lib.stylix.colors.base06;
        gradient_color_8 = config.lib.stylix.colors.base07;
      };

      output = {
        method = "ncurses";  # ターミナル出力 (最も安定)
        channels = "stereo";
      };

      # PipeWire / PulseAudio 環境に自動対応
      input = {
        method = "pulse";
        source = "auto";
      };
    };
  };
}
