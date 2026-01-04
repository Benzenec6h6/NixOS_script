{ config, pkgs, ... }:

{
  programs.floorp = {
    enable = true;

    profiles.main = {
      isDefault = true;

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Floorp Vertical Tab
        "floorp.browser.sidebar.enable" = true;
        "floorp.browser.sidebar.position" = "left";
        "floorp.browser.verticalTab.enabled" = true;
      };

      extensions.packages =
        with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          tridactyl
          darkreader
          simple-translate
          multi-account-containers
          #cookies-txt 一応保留,yt-dlpと相性が良さそう
          #enhancer-for-youtube
          #improved-tube
          #pockettube 検索でヒットしない。
        ];

      userChrome = ''
        #TabsToolbar {
          visibility: collapse;
        }
        /* サイドバーをタブ用に最適化 */
        #sidebar-box {
            min-width: 200px;
            max-width: 280px;
        }
        #nav-bar {
          min-height: 24px !important;
        }
      '';

      userContent = ''
        body {
          background-color: #111 !important;
        }
      '';
    };
  };
}
