{ pkgs, inputs, vars, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs pkgs vars; }; 
    users.${vars.user.name} = {
      imports = [ ./../home ];
      home.username = vars.user.name;
      home.homeDirectory = "/home/${vars.user.name}";
      home.stateVersion = "25.11";
    };
  };

  users.mutableUsers = true;
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "scanner" "lp" "video" "input"  "audio" "docker" "libvirtd" "kvm" ];
    hashedPassword = vars.user.password;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${vars.user.name}" ];
}
