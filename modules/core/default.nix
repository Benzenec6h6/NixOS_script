# modules/core/default.nix
{
  inputs,
  vars,
  lib,
  ...
}: {
  imports =
    [
      # --- 外部 Flake モジュール (inputsから直接インポート) ---
      inputs.niri.nixosModules.niri
      inputs.stylix.nixosModules.stylix
      inputs.home-manager.nixosModules.home-manager
      inputs.impermanence.nixosModules.impermanence
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.sops-nix.nixosModules.sops
      inputs.nix-index-database.nixosModules.default
      inputs.nix-flatpak.nixosModules.nix-flatpak

      # --- 内部モジュール ---
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
    ]
    ++ (lib.optionals (vars.displaymanager == "sddm") [./sddm.nix])
    ++ (lib.optionals (vars.displaymanager == "greetd") [./greetd.nix]);
}
