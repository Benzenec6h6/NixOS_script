{ pkgs
, username
, profile
, ...
}: {
  home.packages = [
    (import ./Brightness.nix { inherit pkgs; })
    (import ./KeyBinds.nix { inherit pkgs; })
    (import ./toggle-waybar.nix { inherit pkgs; })
    (import ./Volume.nix { inherit pkgs; })
    (import ./WaybarCava.nix { inherit pkgs; })
    (import ./WaybarScripts.nix { inherit pkgs; })
    (import ./Weather.nix { inherit pkgs; })
  ];
}
