{ inputs, ... }:

{
  imports = [
    ./fcitx5-mozc
    ./scripts
    ./sddm
    ./audio.nix
    ./base.nix
    #./greetd.nix
    ./hibernate.nix
    ./networking.nix
    ./packages.nix
    ./power-management.nix
    ./quickshell.nix
    ./security.nix
    ./services.nix
    ./stylix.nix
    ./users.nix
    inputs.stylix.nixosModules.stylix
  ];
}