{
  description = "TetoOS - NixOS + Home Manager + Stylix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = { nixpkgs, home-manager, stylix, zen-browser, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "teto";

      mkNixosConfig = profile: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs username profile;
        };
        modules = [
          ./system/hosts/${profile}.nix
        ];
      };
    in {
      nixosConfigurations = {
        laptop = mkNixosConfig "laptop";
        vm = mkNixosConfig "vm";
      };
    };
}
