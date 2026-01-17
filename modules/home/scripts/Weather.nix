{ pkgs, vars, ... }:

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
    city="${vars.locale.location.city}"
    latitude="${vars.locale.location.lat}"
    longitude="${vars.locale.location.lon}"
    OWM_KEY="${vars.apiKeys.owm}"
    
    # 元のシェルスクリプトを読み込む
    ${builtins.readFile ./Weather.sh}
  '';
}