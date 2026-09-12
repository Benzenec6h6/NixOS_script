{
  pkgs,
  inputs,
  ...
}: let
  # nixpkgs-unstable から Ladybird 用にインスタンス化
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      # Ladybird の脆弱性警告をバイパスする設定を追加
      permittedInsecurePackages = [
        "ladybird-0-unstable-2026-05-04"
      ];
    };
  };
in {
  # Home Manager で入れる場合
  home.packages = [
    pkgs-unstable.ladybird
  ];
}
