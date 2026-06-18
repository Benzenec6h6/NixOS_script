{
  pkgs,
  osConfig,
  ...
}:
pkgs.writeShellApplication {
  name = "Weather";
  runtimeInputs = []; # すでに apps.nix 側で PATH が通っているため空でOK

  checkPhase = "true";
  text = ''
    # 秘密情報のパスを取得
    ENV_FILE="${osConfig.sops.templates."weather-env".path}"

    if [ -f "$ENV_FILE" ]; then
      # shellcheck source=/dev/null
      source "$ENV_FILE"
    else
      # エラーメッセージを JSON 形式で出力（Waybar用）
      echo '{"text":"󰤭 ", "tooltip":"Secret file not found"}'
      exit 0
    fi

    exec weather-fetcher
  '';
}
