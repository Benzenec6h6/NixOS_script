{pkgs, ...}: {
  programs.qutebrowser = {
    enable = true;
    enableDefaultBindings = true;

    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?q={}";
    };

    extraConfig = ''
      # ツールバーなどを非表示にして究極のミニマルにする設定（後でお好みで）
      # c.tabs.show = 'never'
      # c.statusbar.show = 'in-mode'
    '';
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    DISABLE_QT_COMPAT = "1";
  };
}
