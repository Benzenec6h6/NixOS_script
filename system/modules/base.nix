{ config, pkgs, ... }:

{
  time.timeZone = "Asia/Tokyo";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
  
  console.keyMap = "jp106";

  nix = {
    package = pkgs.nixVersions.stable;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
}
