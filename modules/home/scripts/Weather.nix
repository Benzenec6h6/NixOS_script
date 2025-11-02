{ pkgs }:

pkgs.writeShellScriptBin "Weather" (builtins.readFile ./Weather.sh)
