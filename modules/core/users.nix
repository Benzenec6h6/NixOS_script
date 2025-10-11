{ pkgs, inputs, username, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "scanner" "lp" "video" "input"  "audio" "docker" "libvirtd" "kvm" ];
    hashedPassword = "$6$qPo6ahBPqNC7mMim$WupFSLamdZfSEoafxSoE1ODgtaHS8gmUayQ2dTiW4vDBAVVJDcuj1yMYAHq.tz5mmZW7aqb44KnMacSq12xpO1";
    shell = pkgs.zsh;
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs username; };
    users.${username} = {
      imports = [ ./../home ];
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.05";
    };
  };
}
