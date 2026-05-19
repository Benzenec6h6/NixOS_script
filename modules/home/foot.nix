{ pkgs, ... }:

{
  programs.foot = {
    enable = true;
    server.enable = true;
    # UWSMが制御する標準的なグラフィカルセッションに紐付ける
    server.systemdTarget = "graphical-session.target";

    settings = {
      main = {
        term = "xterm-256color";
        #font = "FiraCode Nerd Font:size=11"; # お好みのフォント
        dpi-aware = "yes";
      };
      scrollback = {
        lines = 10000;
      };
      #colors = {
      #  alpha = 0.9; # 透過設定など
      #};
    };
  };
}
