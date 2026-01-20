{ pkgs, ... }:

pkgs.writeShellScriptBin "networkmanager_rofi" ''
  export PATH=${pkgs.networkmanager}/bin:${pkgs.rofi}/bin:${pkgs.networkmanager_dmenu}/bin:${pkgs.gnugrep}/bin:$PATH

  ${builtins.readFile ./networkmanager_rofi.sh}
''
