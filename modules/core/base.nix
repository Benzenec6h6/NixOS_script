{ config, pkgs, vars, ... }:

{
  time.timeZone = vars.locale.timeZone;
  i18n.defaultLocale = vars.locale.default;
  i18n.extraLocales = vars.locale.extra;
  
  console.keyMap = vars.locale.keyMap;

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

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };
}
