{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  # 基本ツール
  programs.zsh.enable = true;
  programs.starship.enable = true;

  home.packages = with pkgs; [
    # Terminal / Utilities
    alacritty foot wezterm tmux starship htop btop nvtopPackages.nvidia fzf ripgrep unzip unrar p7zip

    # Browsers / GUI apps
    firefox chromium vscode discord qbittorrent steam

    # Wine
    wineWowPackages.full winetricks

    # Dotfile management
    stow git
  ];

  programs.git = {
    enable = true;
    userName  = "Benzenec6h6";
    userEmail = "aconitinec34h47no11@gmail.com";
  };

  # Xsession を有効化して WM を管理
  xsession.enable = true;

  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = {
      modifier = "Mod4";
      terminal = "alacritty";
      keybindings = {
        "Mod4+Return" = "alacritty";
        "Mod4+d" = "dmenu_run";
        "Mod4+Shift+q" = "i3-msg kill";
      };
    };
  };
}
