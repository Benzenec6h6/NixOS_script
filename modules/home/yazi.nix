{ config, ... }:

{
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y"; # "y" だけで起動

      settings = {
        manager = {
          show_hidden = true;
          sort_by = "alphabetical";
          ratio = [ 1 3 4 ]; # 左カラム:中央:右(プレビュー) の比率
        };
      };

      # プレビューに必要なツール群
      extraPackages = with pkgs; [
        ffmpegthumbnailer # 動画用
        imagemagick       # 画像用
        poppler           # PDF用
        fd                # 検索高速化
        ripgrep           # 内容検索高速化
        fzf               # フィルタリング
      ];
    };
}