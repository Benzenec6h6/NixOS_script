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
      tabs.width = "10%"; # 幅はお好みで（ピクセル指定 "200" も可能）
      tabs.show = "always"; # 初期状態は表示

      # 垂直タブを見やすくするための微調整
      tabs.favicons.show = "always";
      tabs.title.format = "{index}: {audio}{current_title}";

      # ミニマル化（任意）
      statusbar.show = "in-mode"; # 入力時のみステータスバーを表示
      scrolling.bar = "never"; # スクロールバーを隠す
    };

    extraConfig = ''
      # 2. タブの表示/非表示を切り替えるキーバインド
      config.bind('<Alt-Tab>', 'config-cycle tabs.show always never')

      # 参考：ステータスバーも切り替えたい場合
      config.bind('<Tab>s', 'config-cycle statusbar.show always in-mode')

      # 動画のフルスクリーン対応など
      config.set('content.notifications.enabled', True, 'https://www.youtube.com')
    '';
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    DISABLE_QT_COMPAT = "1";
  };
}
