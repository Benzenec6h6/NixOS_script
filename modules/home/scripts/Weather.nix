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
    ENV_FILE="${osConfig.sops.templates."weather-env".path}"

    if [ -f "$ENV_FILE" ]; then
      # shellcheck source=/dev/null
      source "$ENV_FILE"
    else
      echo "Error: Weather config file not found at $ENV_FILE" >&2
      exit 1
    fi

    # apps.nix によって $PATH に入っている `weather-fetcher` をそのまま呼び出す
    exec weather-fetcher
  '';
}
