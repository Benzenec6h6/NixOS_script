{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    xmonad
    xmonad-contrib
    xmobar
  ];

  xsession.enable = true;

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # ~/.xmonad/xmonad.hs にそのまま配置
  xdg.configFile."xmonad/xmonad.hs".source = ./xmonad.hs;

  # xmobar 設定（最低限、必要なら後で分離）
  xdg.configFile."xmobar/xmobarrc".text = ''
    Config
      { font = "xft:monospace:size=10"
      , bgColor = "#1e1e2e"
      , fgColor = "#cdd6f4"
      , position = Top
      , commands =
          [ Run Date "%Y-%m-%d %H:%M" "date" 10
          ]
      , sepChar = "%"
      , alignSep = "}{"
      , template = "%date%"
      }
  '';
}
