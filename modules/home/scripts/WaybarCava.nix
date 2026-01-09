{ pkgs, ... }:

let
  # 同一ディレクトリにあるファイルを Nix ストアにコピーしてパスを取得
  cavaConfig = ./waybar-cava.conf;

  waybarCava = pkgs.writeShellApplication {
    name = "WaybarCava";
    runtimeInputs = [ pkgs.cava pkgs.gnused pkgs.procps pkgs.coreutils ];
    text = ''
      # Nix ストア上の設定ファイルパスを環境変数にセット
      export CAVA_CONFIG_PATH="${cavaConfig}"
      ${builtins.readFile ./WaybarCava.sh}
    '';
  };
in
waybarCava