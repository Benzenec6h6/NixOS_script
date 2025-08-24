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

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = pkg: builtins.elem (pkg.pname or pkg.name) [
            "steam"
            "nvidia-x11"
            "nvidia-settings"
            "cudatoolkit"
            "cuda-merged"
          ];
        };
      };

      baseModules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      # Home Manager ユーザー設定を specialArgs に渡す関数
      addHomeManagerUser = user: homeManagerFile: {
        home-manager.users.${user} = import homeManagerFile {
          inherit pkgs;
          # 必要に応じて config も渡す
          inherit system;
        };
      };
    in
    {
      nixosConfigurations = {
        # VM 用 (QEMU / modesetting)
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs; };
          modules = baseModules ++ [
            ./modules/desktop_vm.nix
            (addHomeManagerUser "teto" ./home/teto.nix)
          ];
        };

        # 実機用 (NVIDIA)
        real = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs; };
          modules = baseModules ++ [
            ./modules/desktop_real.nix
            (addHomeManagerUser "teto" ./home/teto.nix)
          ];
        };
      };
    };
}
