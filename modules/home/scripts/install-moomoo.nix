{ pkgs, inputs, ... }:

pkgs.writeShellApplication {
  name = "moomoo-install";
  runtimeInputs = [ pkgs.distrobox pkgs.nix ];

  # 外部の .sh ファイルを読み込み、中身を置換する
  text = builtins.readFile (pkgs.replaceVars ./install-moomoo.sh {
    # スクリプト内の @moomooDeb@ を置換
    moomooDeb = "${inputs.moomoo.packages.${pkgs.system}.default}/share/moomoo/moomoo.deb";
  });
}
