{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    enableDefaultBindings = true;

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
      g = "https://www.google.com/search?q={}";
      y = "https://www.youtube.com/results?search_query={}";
      nw = "https://nixos.wiki/index.php?search={}";
    };

    # 各種詳細設定
    settings = {
      qt.args = [
        # Intel iGPU環境で重くなりやすいMSAA(アンチエイリアス)を0にして描画を高速・安定化
        "gpu-rasterization-msaa-sample-count=0"

        # ドライバのブロックリストを無視し、WebGPU等のアクセラレーション機能を強制解放
        "ignore-gpu-blocklist"
        "enable-features=WebGPU"

        "disable-accelerated-video-decode"
      ];

      # (任意) WebGLやアクセラレーションの安定性を高めるための追加設定
      content.webgl = true;
      # 1. 垂直タブの設定
      tabs.position = "left";
      tabs.width = "10%";
      tabs.show = "always";

      # 垂直タブを見やすくするための微調整
      tabs.favicons.show = "always";
      tabs.title.format = "{index}: {audio}{current_title}";

      # ミニマル化
      statusbar.show = "in-mode";
      scrolling.bar = "never";

      # Webサイト側の余計なキー入力をカット
      input.forward_unbound_keys = "none";
      input.insert_mode.auto_load = false;
    };

    # ドメインごとの個別設定（YouTubeの通知設定などをここに集約）
    perDomainSettings = {
      "www.youtube.com" = {
        content.notifications.enabled = true;
      };
    };

    # キーバインドの設定（qutebrowser由来以外の余計な挙動を抑止・変更）
    keyBindings = {
      normal = {
        "<Alt-Tab>" = "config-cycle tabs.show always never";

        "<Tab>s" = "config-cycle statusbar.show always in-mode";
      };
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    DISABLE_QT_COMPAT = "1";
  };
}
