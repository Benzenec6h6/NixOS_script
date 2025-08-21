{
  description = "My NixOS config with Home Manager (NixOS 25.05)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      # nixpkgs のインスタンスを作成する時に unfree の設定を入れる
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;

          # 必要な unfree パッケージだけを許可
          allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [
            "steam"
            "nvidia-x11"
            "nvidia-settings"
            "cudatoolkit"
            "cuda-merged"
            "cuda-merged-12.8"
          ];
        };
      };
    in {
      nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs; };
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };
}
