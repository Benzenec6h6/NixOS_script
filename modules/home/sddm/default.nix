{ pkgs, config, ... }:

let
  themeName = "sddm-astronaut-theme";
in {
  home.file.".local/share/sddm/themes/${themeName}".source = ./.;
  
}
