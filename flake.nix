{
  description = "TetoOS - NixOS + Home Manager + Stylix";

  inputs = {
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser ={
      url = "github:Benzenec6h6/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, disko, impermanence, home-manager, stylix, zen-browser, nur, ... }@inputs:
    let
      vars = import ./vars.nix;
      system = vars.system;

      mkNixosConfig = host: nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          hostPlatform = system;
          config.allowUnfree = true;
          overlays = [
            nur.overlays.default
          ];
        };

        specialArgs = {
          inherit inputs vars host;
        };

        modules = [
          impermanence.nixosModules.impermanence
          disko.nixosModules.disko
          ./hosts/${host}
        ];
      };
    in {
      nixosConfigurations = {
        laptop = mkNixosConfig "laptop";
        vm = mkNixosConfig "vm";
      };

      diskoConfigurations = {
        laptop = import ./hosts/laptop/disko.nix { inherit vars; };
        vm     = import ./hosts/vm/disko.nix { inherit vars; };
      };
    };
}
