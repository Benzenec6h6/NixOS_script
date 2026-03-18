{ config, pkgs, vars, ... }:

{
  time.timeZone = vars.locale.timeZone;
  i18n.defaultLocale = vars.locale.default;
  i18n.extraLocales = vars.locale.extra;
  
  console.keyMap = vars.locale.keyMap;

  nix = {
    #package = pkgs.nixVersions.stable;
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [ 
        "https://cache.lix.systems"
        "https://attic.xuyh0120.win/lantian"
        "https://cache.garnix.io"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      #download-buffer-size = 1000000000;
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
    };
    optimise ={
      automatic = true;
      dates = [ "monthly" ];
    };
  };

  boot.initrd.systemd.enable = true;
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
