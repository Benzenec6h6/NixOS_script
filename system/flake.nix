{
  description = "NixOS system configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # 安定版
    # flake-utils があると便利（オプション）
    #flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      username = "teto";
    in {
      nixosConfigurations = {
        # 実機用
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/laptop.nix
            ({ ... }: { _module.args.username = username; })
          ];
        };

        # VM用
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/vm.nix
            ({ ... }: { _module.args.username = username; })
          ];
        };
      };
    };
}
