{ config, pkgs, inputs, ... }:

{
  # Firefox モジュールとして Zen Browser を設定
  programs.firefox = {
    enable = true;
    package = inputs.zen-browser.packages.${pkgs.system}.default;

    profiles.default = {
      id = 0;
      name = "default";
      isDefault = true;

      # Firefox の設定 (about:config 相当)
      settings = {
        "browser.startup.homepage" = "https://example.org";
        "browser.tabs.drawInTitlebar" = true;
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.wayland-dmabuf-vaapi.enabled" = true;
        "gfx.webrender.all" = true;
        "media.ffmpeg.vaapi.enabled" = true;
      };

      # 推奨拡張機能（NUR 経由で取得）
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        darkreader
        tridactyl
        to-deepl
        multi-account-containers
      ];

      # 検索エンジン設定
      search = {
        default = "DuckDuckGo";
        engines = {
          "DuckDuckGo" = {
            urls = [{ template = "https://duckduckgo.com/?q={searchTerms}"; }];
            icon = "https://duckduckgo.com/favicon.ico";
          };
          "Google" = {
            urls = [{ template = "https://www.google.com/search?q={searchTerms}"; }];
            icon = "https://www.google.com/favicon.ico";
          };
        };
      };
    };
  };
}
