{ pkgs, inputs, username, ... }:
{
  imports = [
    #./waybar/waybar-curved.nix
    #./waybar/waybar-nekodyke.nix
    ./waybar/waybar-JaKooLit.nix
    ./wlogout/wlogout.nix
    ./cava.nix
    ./rofi.nix
    ./apps.nix
    ./fonts.nix
    #./themes.nix
    ./wm/hyprland.nix
    ./stylix.nix
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Benzenec6h6";
    userEmail = "aconitinec34h47no11@gmail.com";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    history = {
      size = 10000;
      save = 10000;
    };
    initContent = ''
      export EDITOR=nvim
      alias ll="ls -la"
    '';
  };

  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
