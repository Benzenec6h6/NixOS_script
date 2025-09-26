{ config, pkgs, username, ... }:

{
  users.users = {
    # メインユーザ
    "${username}" = {
      isNormalUser = true;
      description = "Main user";
      extraGroups = [ "networkmanager" "wheel" "libvirtd" "scanner" "lp" "video" "input"  "audio" "docker" "libvirtd" "kvm" ];
      hashedPassword = "$6$qPo6ahBPqNC7mMim$WupFSLamdZfSEoafxSoE1ODgtaHS8gmUayQ2dTiW4vDBAVVJDcuj1yMYAHq.tz5mmZW7aqb44KnMacSq12xpO1";
      shell = pkgs.zsh;
    };
  };

  # root の設定を明示することもできる
  users.users.root = {
    shell = pkgs.bashInteractive;
  };
}
