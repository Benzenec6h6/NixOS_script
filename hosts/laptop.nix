{ inputs, username, profile, ... }:

{
  imports = [
    ./hardware.nix
    ../modules/core/fcitx5-mozc
    ../modules/core/scripts
    ../modules/core/sddm
    ../modules/core/base.nix
    #../modules/core/greetd.nix
    ../modules/core/hibernate.nix
    ../modules/core/networking.nix
    ../modules/core/packages.nix
    ../modules/core/power-management.nix
    ../modules/core/quickshell.nix
    ../modules/core/security.nix
    ../modules/core/services.nix
    ../modules/core/stylix.nix
    ../modules/core/users.nix
    inputs.stylix.nixosModules.stylix
  ];

  services.xserver.videoDrivers = [ "nvidia" "intel" ];
  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    prime = {
      intelBusId = ""; #"PCI:0:2:0"は固有の番号なのでpciutilsで調べる
      nvidiaBusId = ""; #ここも同様
      offload.enable = true;
    };
  };

  # 実機特有の設定
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
