{ pkgs, inputs, username, ... }:
{
  imports = [
    ./rofi
    ./scripts
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
    ./starship.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./zen-browser.nix
    ./zsh.nix
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

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
}
