{ pkgs }:

pkgs.writeShellScriptBin "hibernate-dynamic" ''
  #!/usr/bin/env bash
  export PATH=${pkgs.coreutils}/bin:${pkgs.util-linux}/bin:${pkgs.systemd}/bin:$PATH
  ${builtins.readFile ./hibernate-dynamic.sh}
''
