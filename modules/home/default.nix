{ pkgs, vars, config, lib, ... }:
{
  imports = [
    ./fastfetch
    ./hyprland
    ./mpv
    ./neovim
    ./rofi
    ./scripts
    ./starship
    ./waybar
    #./waybar/waybar-JaKooLit.nix
    ./wlogout
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
    ./niri.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
  ] ++ (lib.optionals (vars.host == "laptop") [
    ./ollama.nix
  ]);

  programs.home-manager.enable = true;

  home.file.".config/hypr/hyprlock".source = ./hyprlock;
  home.file.".config/quickshell".source = ./quickshell;
}
