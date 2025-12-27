{ pkgs, username, profile, inputs, ...}:
{
  imports = [
    ./battery-monitor.nix
    ./portal-monitor.nix
  ];

  home.packages = [
    (import ./Brightness.nix { inherit pkgs; })
    (import ./ClipManager.nix { inherit pkgs; })
    (import ./Dropterminal.nix { inherit pkgs; })
    (import ./KeyBinds.nix { inherit pkgs; })
    (import ./KillActive.nix { inherit pkgs; })
    (import ./networkmanager_rofi.nix { inherit pkgs; })
    (import ./recorder.nix { inherit pkgs inputs; })
    (import ./ScreenShot.nix { inherit pkgs inputs; })
    (import ./Volume.nix { inherit pkgs; })
    (import ./WaybarCava.nix { inherit pkgs; })
    (import ./WaybarScripts.nix { inherit pkgs; })
    (import ./Weather.nix { inherit pkgs; })
  ];
}
