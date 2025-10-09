{
  description = "NixOS system + Home Manager configuration (integrated)";

  inputs = {
    # 🧱 ベース: 安定版チャンネル
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    #flake-utils.url = "github:numtide/flake-utils";

    # 🏠 Home Manager 統合
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

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
    in {
      nixosConfigurations = {
        # 💻 実機用
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            # ---- NixOS 側 ----
            ./hosts/laptop.nix
            ({ ... }: { _module.args.username = username; })

            # ---- Home Manager 統合 ----
            home-manager.nixosModules.home-manager

            # Stylix テーマをHome Manager側で使用
            stylix.nixosModules.stylix

            # ---- Home設定の適用 ----
            {
              _module.args.username = username;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} = {
                imports = [
                  ./home.nix
                  ./modules/stylix.nix
                ];

                # Zen Browser を Home 環境に追加
                home.packages = [
                  zen-browser.packages.${system}.default
                ];

                # Home環境情報
                home.username = username;
                home.homeDirectory = "/home/${username}";
              };
            }
          ];
        };

        # 🧪 仮想マシン用
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/vm.nix
            ({ ... }: { _module.args.username = username; })

            home-manager.nixosModules.home-manager
            stylix.nixosModules.stylix

            {
              _module.args.username = username;

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.${username} = {
                imports = [
                  ./home.nix
                  ./modules/stylix.nix
                ];
                home.packages = [
                  zen-browser.packages.${system}.default
                ];
                home.username = username;
                home.homeDirectory = "/home/${username}";
              };
            }
          ];
        };
      };
    };
}
