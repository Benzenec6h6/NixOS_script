{ pkgs, inputs, username, ... }:
{
  imports = [
    #./waybar/waybar-curved.nix
    #./waybar/waybar-nekodyke.nix
    ./waybar/waybar-JaKooLit.nix
    ./wlogout/wlogout.nix
    ./cava.nix
    ./quickshell/theme.nix
    ./rofi
    ./wm/hyprland.nix
    ./apps.nix
    ./fonts.nix
    ./kitty.nix
    ./starship.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
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

  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  home.file.".config/quickshell/overview.qml".source = ./quickshell/overview.qml;
}
