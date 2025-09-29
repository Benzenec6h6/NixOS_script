{
  description = "Home Manager configuration (standalone)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # system と同じチャンネルに合わせると吉
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = { self, nixpkgs, home-manager, zen-browser, ... }:
    let
      system = "x86_64-linux";
      username = "teto";
      homeDirectory = "/home/${username}";
    in {
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = homeDirectory;
            home.packages = [
              zen-browser.packages.${system}.default
            ];
          }
        ];
      };
    };
}
