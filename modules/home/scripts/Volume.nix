{ pkgs }:

pkgs.writeShellScriptBin "volume" (builtins.readFile ./Volume.sh)
