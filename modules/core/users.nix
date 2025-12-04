{ pkgs, inputs, username, userPassword, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit pkgs inputs username; };
    users.${username} = {
      imports = [ ./../home ];
      home.username = username;
      home.homeDirectory = "/home/${username}";
      home.stateVersion = "25.11";
    };
  };

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "scanner" "lp" "video" "input"  "audio" "docker" "libvirtd" "kvm" ];
    hashedPassword = userPassword;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${username}" ];
}
