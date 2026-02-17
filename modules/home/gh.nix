{ pkgs, ... }: {
  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-eco     # 依存関係グラフ表示
      gh-markdown-preview # READMEのプレビュー
    ];
    settings = {
      editor = "nvim"; # お好みのエディタ
      git_protocol = "ssh";
      prompt = "enabled";
    };
    gitCredentialHelper.enable = true;
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      # ここにgh-dash独自のビュー設定などを記述
      prSections = [
        { title = "My Pull Requests"; filters = "is:open author:@me"; }
      ];
    };
  };
}