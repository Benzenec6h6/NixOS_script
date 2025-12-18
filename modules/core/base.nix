{ config, pkgs, ... }:

{
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
  
  console.keyMap = "jp106";

  boot.loader.grub.configurationLimit = 5;

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };

  nix.settings = {
    max-jobs = "auto";
    cores = 0;
    auto-optimise-store = false; # optimiseと二重にしない
  };

  services.tmpfiles.clean.enable = true;

  services.journald.extraConfig = ''
    SystemMaxUse=512M
    SystemMaxFiles=200
    MaxRetentionSec=14day
  '';

  services.fstrim.enable = true;

}
