{
  description = "NixOS system + Home Manager integrated configuration";

  inputs = {
    # 🧱 ベース: 安定版チャンネル
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    #flake-utils.url = "github:numtide/flake-utils";

    # 🏠 Home Manager 統合
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 🎨 Stylix (テーマ管理)
    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 🌐 Zen Browser (flake対応)
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, stylix, zen-browser, ... }:
    let
      system = "x86_64-linux";
      username = "teto";
      zenPkg = zen-browser.packages.${system}.default;
    in {
      nixosConfigurations = {
        # 💻 実機用（laptop）
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username stylix; };
          modules = [
            ./system/hosts/laptop.nix

            # ---- Home Manager統合 ----
            home-manager.nixosModules.home-manager

            # ---- Home設定 ----
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} = {
                imports = [
                  ./home/home.nix
                ];

                home.username = username;
                home.homeDirectory = "/home/${username}";

                home.packages = [
                  zenPkg
                ];
              };
            }
          ];
        };

        # 🧪 仮想マシン用（vm）
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username stylix; };
          modules = [
            ./system/hosts/vm.nix

            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} = {
                imports = [
                  ./home/home.nix
                ];

                home.username = username;
                home.homeDirectory = "/home/${username}";

                home.packages = [
                  zenPkg
                ];
              };
            }
          ];
        };
      };
    };
}
