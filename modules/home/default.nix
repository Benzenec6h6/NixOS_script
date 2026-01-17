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
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
