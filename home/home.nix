{ config, pkgs, ... }:

{
  imports = [
    ./modules/apps.nix
    ./modules/themes.nix
    ./modules/plasma.nix
    #./modules/wm
  ];

  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    userName = "Benzenec6h6";
    userEmail = "aconitinec34h47no11@gmail.com";
  };

  # シェル設定例 (zsh を使う場合)
  programs.zsh.enable = true;
}
