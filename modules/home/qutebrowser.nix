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
        # 1. ブラウザ標準のTab移動（暴走の原因）を完全に無効化
        "<Tab>" = null;
        "<Shift+Tab>" = null;

        # 2. タブの表示/非表示の切り替え（長押し対策として、キーを【離したとき】に実行）
        "<Tab-Alt>" = "config-cycle tabs.show always never";

        # 3. ステータスバーの切り替え（Tabキー無効化に伴い、Alt+s などに変更するのがおすすめです）
        "<Tab+s>" = "config-cycle statusbar.show always in-mode";
      };
    };
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    DISABLE_QT_COMPAT = "1";
  };
}
