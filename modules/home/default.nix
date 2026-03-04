{ pkgs, vars, config, ... }:
{
  imports = [
    ./fastfetch
    ./mpv
    ./neovim
    ./rofi
    ./scripts
    ./starship
    ./waybar
    #./waybar/waybar-JaKooLit.nix
    ./wlogout
    ./hyprland.nix
    ./apps.nix
    #./brave.nix
    ./cava.nix
    ./cli-tools.nix
    #./firefox.nix
    ./fonts.nix
    ./gh.nix
    ./git.nix
    ./hypridle.nix
    ./impermanence.nix
    ./keepassxc.nix
    ./kitty.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;

  home.file.".config/hypr/hyprlock".source = ./hyprlock;
  home.file.".config/quickshell".source = ./quickshell;
}
