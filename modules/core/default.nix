{
  inputs,
  vars,
  lib,
  ...
}: {
  imports =
    [
      ./fcitx5-mozc
      ./scripts
      ./audio.nix
      ./base.nix
      ./bootloader.nix
      ./flatpak.nix
      ./fwupd.nix
      ./hibernate.nix
      ./impermanence.nix
      ./networking.nix
      ./packages.nix
      ./power-management.nix
      ./quickshell.nix
      ./security.nix
      ./services.nix
      ./stylix.nix
      ./tailscale.nix
      ./thunar.nix
      ./update.nix
      ./users.nix
      ./virtualisation.nix
      inputs.stylix.nixosModules.stylix
    ]
    ++ (lib.optionals (vars.displaymanager == "sddm") [./sddm.nix])
    ++ (lib.optionals (vars.displaymanager == "greetd") [./greetd.nix]);
}
