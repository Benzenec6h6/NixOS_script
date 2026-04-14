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
    ./niri.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
  ] 
  ++ (lib.optionals (vars.user.terminal == "kitty") [ ./kitty.nix ])
  ++ (lib.optionals (vars.user.terminal == "ghostty") [ ./ghostty.nix ])
  ++ (lib.optionals (vars.host == "laptop") [ ./ollama.nix ]);

  programs.home-manager.enable = true;

  home.file.".config/hypr/hyprlock".source = ./hyprlock;
  home.file.".config/quickshell".source = ./quickshell;
}
