{ pkgs, inputs, vars, config, ... }:
{
  imports = [
    ./fastfetch
    ./mpv
    ./rofi
    ./scripts
    ./starship
    #./waybar/waybar-curved.nix
    #./waybar/waybar-nekodyke.nix
    ./waybar/waybar-JaKooLit.nix
    ./wlogout
    ./wm/hyprland.nix
    ./apps.nix
    #./brave.nix
    ./cava.nix
    ./firefox.nix
    ./fonts.nix
    ./hypridle.nix
    ./impermanence.nix
    ./kitty.nix
    ./neovim.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # 画像は qimgv
      "image/png"  = [ "qimgv.desktop" ];
      "image/jpeg" = [ "qimgv.desktop" ];
      "image/webp" = [ "qimgv.desktop" ];
      "image/gif"  = [ "qimgv.desktop" ];
      "image/bmp"  = [ "qimgv.desktop" ];

      # Web / URL は zen
      "text/html" = [ "firefox.desktop" ];
      "x-scheme-handler/http"  = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = vars.user.gitName;
      email = vars.user.gitEmail;
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.fd.enable = true;
  programs.distrobox.enable = true;
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  services.blueman-applet.enable = true;
  services.swaync.enable = true;
  services.playerctld.enable = true;
  services.megasync = {
    enable = true;
    forceWayland = true;
  };

  home.file.".config/hypr/hyprlock".source = ./hyprlock;
  home.file.".config/quickshell".source = ./quickshell;

  home.packages = [
    inputs.zen-browser.packages.${vars.system}.default
    inputs.moomoo.packages.${vars.system}.default
  ];

  home.sessionVariables = {
    MOOMOO_PKG_PATH = "${inputs.moomoo.packages.${vars.system}.default}";
    MOOMOO_DEB_PATH = "${inputs.moomoo.packages.${vars.system}.default}/share/moomoo/moomoo.deb";
  };

  home.shellAliases = {
    moomoo-install = ''
      # 1. コンテナの作成と基本ツールのインストール
      distrobox create --name moomoo --image docker.io/library/ubuntu:24.04 --yes && \
      distrobox enter moomoo -- sudo apt update && \
      distrobox enter moomoo -- sudo apt install -y desktop-file-utils libglib2.0-bin && \
      
      # 2. アプリ本体のインストール
      distrobox enter moomoo -- sudo apt install -y $MOOMOO_DEB_PATH && \
      
      # 3. デスクトップファイルとアイコンをホスト側（NixOS）に配置
      mkdir -p ~/.local/share/applications ~/.local/share/icons && \
      cp $MOOMOO_PKG_PATH/share/applications/moomoo.desktop ~/.local/share/applications/ && \
      # コンテナ内からアイコンを抜き出してホストに置く
      distrobox enter moomoo -- cp /opt/moomoo/app.png /home/${vars.user}/.local/share/icons/moomoo-icon.png
    '';
  };
}
