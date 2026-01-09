{ config, pkgs, ... }:

{
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
  
  console.keyMap = "jp106";

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [ "nix-command" "flakes" ];
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    settings = {
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
    };
    optimise ={
      automatic = true;
      dates = [ "monthly" ];
    };
  };

  boot.tmp.cleanOnBoot = true;

  services.journald.extraConfig = ''
    SystemMaxUse=512M
    SystemMaxFiles=200
    MaxRetentionSec=14day
  '';

  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5; # ここに移動
    efi.canTouchEfiVariables = true;
  };
}
