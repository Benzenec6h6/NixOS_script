{
  description = "TetoOS - NixOS + Home Manager + Stylix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    #nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

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

    zen-browser.url = "github:Benzenec6h6/zen-browser-flake";
  };

  outputs = { nixpkgs, home-manager, stylix, zen-browser, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "teto";
      userPassword = "$6$qPo6ahBPqNC7mMim$WupFSLamdZfSEoafxSoE1ODgtaHS8gmUayQ2dTiW4vDBAVVJDcuj1yMYAHq.tz5mmZW7aqb44KnMacSq12xpO1";

      mkNixosConfig = profile: nixpkgs.lib.nixosSystem {
        pkgs = import nixpkgs {
          hostPlatform = system;
          config.allowUnfree = true;
          overlays = [
            nur.overlays.default
          ];
        };

        specialArgs = {
          inherit inputs username profile userPassword;
        };

        modules = [
          ./hosts/${profile}
        ];
      };
    in {
      nixosConfigurations = {
        laptop = mkNixosConfig "laptop";
        vm = mkNixosConfig "vm";
      };
    };
}
