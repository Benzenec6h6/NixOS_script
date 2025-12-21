{ pkgs, ... }:

{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # WirePlumber policy
  /*
  environment.etc."wireplumber/main.lua.d/60-headphones-unmute.lua".text =
    builtins.readFile ./wireplumber/60-headphones-unmute.lua;
  */
}
