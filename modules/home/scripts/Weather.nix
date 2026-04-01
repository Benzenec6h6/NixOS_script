{ pkgs, osconfig, ... }:

pkgs.writeShellApplication {
  name = "Weather";
  runtimeInputs = [ 
    pkgs.curl 
    pkgs.gnused 
    pkgs.coreutils 
    pkgs.gnugrep
    pkgs.jq # JSONの検証と整形にあると便利
  ];
  checkPhase = "true";
  text = ''
    if [ -f "${osconfig.sops.templates."weather-env".path}" ]; then
      # shellcheck source=/dev/null
      source "${osconfig.sops.templates."weather-env".path}"
    else
      echo "Error: Weather config not found" >&2
      exit 1
    fi

    # 変数名をスクリプト内の期待値に合わせる
    city="$CITY_NAME"
    latitude="$LAT"
    longitude="$LON"
    api_key="$OWM_KEY"
    
    # 元のシェルスクリプトを読み込む
    ${builtins.readFile ./Weather.sh}
  '';
}
