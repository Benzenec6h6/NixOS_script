{
  pkgs,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  # package.nix 内で設定されている knownVulnerabilities を直接空にする
  ladybird-patched = pkgs-unstable.ladybird.overrideAttrs (oldAttrs: {
    meta =
      (oldAttrs.meta or {})
      // {
        knownVulnerabilities = [];
      };
  });
in {
  # Home Manager でも NixOS (environment.systemPackages) でもどちらでも通ります
  home.packages = [
    ladybird-patched
  ];
}
