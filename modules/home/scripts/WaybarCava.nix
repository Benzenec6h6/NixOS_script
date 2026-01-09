{ pkgs, ... }:

let
  # cavaの設定ファイルをNix側で定義（型安全でクリーン）
  cavaConfig = pkgs.writeText "waybar-cava.conf" ''
    [general]
    framerate = 30
    bars = 10

    [input]
    method = pulse
    source = auto

    [output]
    method = raw
    raw_target = /dev/stdout
    data_format = ascii
    ascii_max_range = 7
  '';

  waybarCava = pkgs.writeShellApplication {
    name = "WaybarCava";
    runtimeInputs = [ pkgs.cava pkgs.gnused pkgs.procps pkgs.coreutils ];
    text = ''
      # Nixで作成した設定ファイルのパスを環境変数で渡す
      export CAVA_CONFIG_PATH="${cavaConfig}"
      ${builtins.readFile ./WaybarCava.sh}
    '';
  };
in
{
  # Waybarのカスタムモジュールから呼び出せるようにパッケージに追加
  home.packages = [ waybarCava ];
}