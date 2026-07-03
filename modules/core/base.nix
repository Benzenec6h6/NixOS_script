{
  config,
  pkgs,
  vars,
  ...
}: {
  time.timeZone = vars.locale.timeZone;
  i18n.defaultLocale = vars.locale.default;
  i18n.extraLocales = vars.locale.extra;

  console.keyMap = vars.locale.keyMap;

  nix = {
    #package = pkgs.lixPackageSets.stable.lix;
    package = pkgs.nix;
    gc = {
      automatic = true;
      dates = "monthly";
      options = "--delete-older-than 30d";
    };
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://attic.xuyh0120.win/lantian"
        "https://cache.lix.systems"
        "https://cache.tvl.fyi/"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
        "cache.tvl.su:kjc6KOMupXc1vHVufJUoDUYeLzbwSr9abcAKdn/U1Jk="
      ];
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
    };
    optimise = {
      automatic = true;
      dates = ["monthly"];
    };
  };

  boot = {
    initrd.systemd = {
      enable = true;
      tpm2.enable = true;
    };
    tmp.cleanOnBoot = true;
  };

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
    fileSystems = ["/"];
  };

  environment.variables = {
    NIXOS_OZONE_WL = "1";
  };
}
