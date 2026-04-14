{ inputs, ... }:

{
  imports = [
    ./fcitx5-mozc
    ./scripts
    ./audio.nix
    ./base.nix
    ./bootloader.nix
    ./flatpak.nix
    #./greetd.nix
    ./hibernate.nix
    ./impermanence.nix
    ./networking.nix
    ./packages.nix
    ./power-management.nix
    ./quickshell.nix
    ./sddm.nix
    ./security.nix
    ./services.nix
    ./stylix.nix
    ./users.nix
    ./virtualisation.nix
    inputs.stylix.nixosModules.stylix
  ];
}
