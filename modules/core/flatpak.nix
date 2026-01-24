{ config, pkgs, vars, ... }:

{
  services.flatpak = {
    enable = true;
    packages = [
      "com.usebottles.bottles"
      "com.github.tchx84.Flatseal"
      "io.github.dvlv.boxbuddyrs"
    ];
    update.onActivation = true;
  };
}