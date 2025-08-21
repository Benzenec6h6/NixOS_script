{
  description = "NixOS 25.05 + Home Manager 25.05";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      homeConfigurations.teto = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        username = "teto";
        homeDirectory = "/home/teto";
        configuration = ./home/teto.nix;
      };
    };
}
