{
  description = "NixOS + Home Manager standalone configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
