{ pkgs, osConfig, ... }:

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
    ENV_FILE="${osConfig.sops.templates."weather-env".path}"
  
    if [ -f "$ENV_FILE" ]; then
      # shellcheck source=/dev/null
      source "$ENV_FILE"
    else
      echo "Error: Weather config file not found at $ENV_FILE" >&2
      # ls -l /run/secrets などを実行して権限を確認するデバッグ文を入れても良い
      exit 1
    fi

    # デバッグ用：値が渡っているか確認（動作確認後は消してください）
    # echo "Debug: City is $CITY_NAME" >&2

    city="''${CITY_NAME:-}"
    latitude="''${LAT:-}"
    longitude="''${LON:-}"
    api_key="''${OWM_KEY:-}"
  
    if [ -z "$api_key" ]; then
      echo "Error: API Key is empty" >&2
      exit 1
    fi
    
    # 元のシェルスクリプトを読み込む
    ${builtins.readFile ./Weather.sh}
  '';
}
