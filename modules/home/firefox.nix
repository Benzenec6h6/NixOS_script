{ config, pkgs, ... }:

{
    programs.firefox ={
        enable=true;

        profiles.main = {
            isDefault = true;

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
        };
    };
}
