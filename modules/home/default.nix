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
    ./git.nix
    ./hypridle.nix
    ./impermanence.nix
    ./keepassxc.nix
    ./kitty.nix
    ./neovim.nix
    ./stylix.nix
    ./swaync.nix
    #./themes.nix
    ./xdg.nix
    ./yazi.nix
    ./zsh.nix
  ];

  programs.home-manager.enable = true;

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
