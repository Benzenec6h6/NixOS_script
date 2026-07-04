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
    [ -f "$ENV_FILE" ] && source "$ENV_FILE"

    exec weather-fetcher "$@"
  '';
}
