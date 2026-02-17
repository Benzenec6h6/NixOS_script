{ pkgs, inputs, vars, config, ... }:
{
  imports = [
    ./fastfetch
    ./mpv
    ./rofi
    ./scripts
    ./starship
    ./waybar
    #./waybar/waybar-JaKooLit.nix
    ./wlogout
    ./wm/hyprland.nix
    ./apps.nix
    #./brave.nix
    ./cava.nix
    ./firefox.nix
    ./fonts.nix
    ./gh.nix
    ./hypridle.nix
    ./impermanence.nix
    ./keepassxc.nix
    ./kitty.nix
    ./neovim.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./yazi.nix
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
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http"  = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];

      "x-scheme-handler/magnet" = [ "transmission-gtk.desktop" ];
      "application/x-bittorrent" = [ "transmission-gtk.desktop" ];
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = vars.user.gitName;
      email = vars.user.gitEmail;
    };
    config = {
      credential.helper = "keepassxc";
      # SSH鍵の署名を検証する場合などに備えて
      # gpg.format = "ssh"; 
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
  ];
}
