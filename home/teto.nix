{ config, pkgs, ... }:

{
  home-manager.users.teto = {
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
      wineWowPackages.full

      # Dotfile management
      stow git
    ];

    programs.git = {
      enable = true;
      userName  = "Benzenec6h6";
      userEmail = "aconitinec34h47no11@gmail.com";
    };

    # ===============================
    # WM 設定 (i3)
    # ===============================
    xsession = {
      enable = true; # ← これが大事。i3をHome Managerで使えるようにする
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps; # gaps入りi3
        config = {
          modifier = "Mod4";     # SuperキーをModに
          terminal = "alacritty";
          keybindings = {
            "Mod4+Return" = "alacritty";
            "Mod4+d" = "dmenu_run";
            "Mod4+Shift+q" = "i3-msg kill";
          };
        };
      };
    };
  };
}
