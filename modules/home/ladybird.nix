{
  pkgs,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config = {
      allowUnfree = true;
      # パッケージ名が "ladybird-" から始まるものは日付を問わず全て許可
      permittedInsecurePackages = [];
      whitelistInsecurePackages = []; # システムによっては predicate を利用

      # 名前判定でワイルドカード的に許可する関数
      permittedInsecurePackagePredicates = [
        (pkg: pkgs.lib.hasPrefix "ladybird-" (pkgs.lib.getName pkg))
      ];
    };
  };
in {
  home.packages = [
    pkgs-unstable.ladybird
  ];
}
