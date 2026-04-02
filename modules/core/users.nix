{ config, pkgs, inputs, vars, ... }:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  sops = {
    # 秘密情報ファイルの場所（Flakeルートからの相対パスなど）
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # 復号したファイルをどこに置くか
    secrets = {
      "password" = {
        neededForUsers = true;
      };
      "location/city" = { owner = vars.user.name; };
      "location/lat" = { owner = vars.user.name; };
      "location/lon" = { owner = vars.user.name; };
      "api-key" = { owner = vars.user.name; };
    };
    templates."weather-env" = {
      path = "/run/secrets/weather-env";
      owner = vars.user.name;
      mode = "0444";
      content = ''
        CITY_NAME="${config.sops.placeholder."location/city"}"
        LAT="${config.sops.placeholder."location/lat"}"
        LON="${config.sops.placeholder."location/lon"}"
        OWM_KEY="${config.sops.placeholder."api-key"}"
      '';
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs pkgs vars; }; 
    users.${vars.user.name} = {
      imports = [ ./../home ];
      home.username = vars.user.name;
      home.homeDirectory = "/home/${vars.user.name}";
      home.stateVersion = vars.version;
    };
  };

  users.mutableUsers = true;
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "scanner" "lp" "video" "input"  "audio" "docker" "libvirtd" "kvm" ];
    hashedPasswordFile = config.sops.secrets.password.path;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${vars.user.name}" ];
}
