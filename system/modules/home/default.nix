{ inputs, username, ... }:
{
  imports = [
    #./modules/waybar/waybar-curved.nix
    #./modules/waybar/waybar-nekodyke.nix
    ./modules/waybar/waybar-JaKooLit.nix
    ./modules/wlogout/wlogout.nix
    ./modules/cava.nix
    ./modules/rofi.nix
    ./modules/apps.nix
    ./modules/fonts.nix
    #./modules/themes.nix
    ./modules/wm/hyprland.nix
    ./modules/stylix.nix
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
      path = "${config.home.homeDirectory}/.zsh_history";
    };
    initExtra = ''
      export EDITOR=nvim
      alias ll="ls -la"
    '';
  };

  home.packages = [
    inputs.zen-browser.packages.${pkgs.system}.default
  ];
}
