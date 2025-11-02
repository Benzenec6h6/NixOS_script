{ pkgs }:

pkgs.writeShellScriptBin "WaybarCava" (builtins.readFile ./WaybarCava.sh)
