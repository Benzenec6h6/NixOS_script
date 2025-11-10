{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.brave;
    commandLineArgs = [
      "--password-store=gnome"
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
    ];
    nativeMessagingHosts = [
      pkgs.keepassxc
      pkgs.tridactyl-native
      pkgs.passff-host
    ];
    extensions = [
      { id = "nfmmmhanepmpifddlkkmihkalkoekpfd"; }
    ];
  };
}