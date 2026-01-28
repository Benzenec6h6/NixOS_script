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

  home.shellAliases = {
    moomoo-install = ''
      nix build github:Benzenec6h6/moomoo_flake
      
      distrobox create --name moomoo --image ubuntu:24.04 --yes
      
      distrobox enter moomoo -- bash -c "
        sudo apt update && \
        sudo apt install -y libnss3 libasound2t64 libxss1 libgbm1 libgtk-3-0t64 libsecret-1-0 \
        libxcb-render-util0 libxcb-xinerama0 libxcb-cursor0 libxcb-icccm4 \
        libxcb-image0 libxcb-keysyms1 libxcb-shape0 libxkbcommon-x11-0 && \
        sudo apt install -y ./result/share/moomoo/moomoo.deb
      "
    '';

    moomoo = "distrobox enter moomoo -- /opt/moomoo/moomoo --no-sandbox";
  };
}
