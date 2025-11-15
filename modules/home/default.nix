{ pkgs, inputs, username, config, ... }:
{
  imports = [
    ./fastfetch
    ./mpv
    ./rofi
    ./scripts
    ./sddm
    ./starship
    #./waybar/waybar-curved.nix
    #./waybar/waybar-nekodyke.nix
    ./waybar/waybar-JaKooLit.nix
    ./wlogout/wlogout.nix
    ./wm/hyprland.nix
    ./apps.nix
    ./brave.nix
    ./cava.nix
    ./fonts.nix
    ./hypridle.nix
    ./kitty.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./zsh.nix
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop   = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download  = "${config.home.homeDirectory}/Downloads";
    music     = "${config.home.homeDirectory}/Music";
    pictures  = "${config.home.homeDirectory}/Pictures";
    videos    = "${config.home.homeDirectory}/Videos";
  };

  programs.git = {
    enable = true;
    userName = "Benzenec6h6";
    userEmail = "aconitinec34h47no11@gmail.com";
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

  services.swaync.enable = true;
  services.playerctld.enable = true;
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;

  home.file.".config/hypr/hyprlock".source = ./hyprlock;
  home.file.".config/quickshell".source = ./quickshell;

  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
