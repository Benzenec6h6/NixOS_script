{ pkgs }:

pkgs.writeShellApplication {
  name = "Dropterminal";
  runtimeInputs = [ 
    pkgs.hyprland 
    pkgs.jq 
    pkgs.bc 
    pkgs.procps 
    pkgs.coreutils 
    pkgs.gnused
    pkgs.kitty # ← あなたが使っているターミナルをここに追加してください
  ];
  # スクリプトを呼び出す際、引数がなければ "kitty" を使うようにラップ
  text = ''
    # もし引数が空なら、デフォルトのターミナルを指定する
    if [ $# -eq 0 ]; then
        ${builtins.readFile ./Dropterminal.sh} "kitty"
    else
        ${builtins.readFile ./Dropterminal.sh} "$@"
    fi
  '';
}