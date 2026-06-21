{
  config,
  pkgs,
  inputs,
  vars,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  sops = {
    # 秘密情報ファイルの場所（Flakeルートからの相対パスなど）
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
    # 復号したファイルをどこに置くか
    secrets = {
      "password" = {
        neededForUsers = true;
      };
      "location/city" = {owner = vars.user.name;};
      "location/lat" = {owner = vars.user.name;};
      "location/lon" = {owner = vars.user.name;};
      "api-key" = {owner = vars.user.name;};
      "gemini-api-key" = {owner = vars.user.name;};
      "mega-password" = {owner = vars.user.name;};
      "mega-email" = {owner = vars.user.name;};
    };
    templates."weather-env" = {
      owner = vars.user.name;
      mode = "0444";
      content = ''
        export CITY_NAME="${config.sops.placeholder."location/city"}"
        export LAT="${config.sops.placeholder."location/lat"}"
        export LON="${config.sops.placeholder."location/lon"}"
        export OWM_KEY="${config.sops.placeholder."api-key"}"
      '';
    };
    templates."ai-env" = {
      owner = vars.user.name;
      mode = "0444";
      content = ''
        GEMINI_API_KEY="${config.sops.placeholder."gemini-api-key"}"
      '';
    };
    templates."rclone-config" = {
      owner = vars.user.name;
      path = "/home/${vars.user.name}/.config/rclone/rclone.conf";
      mode = "0600";
      content = ''
        [mega-vault]
        type = mega
        user = ${config.sops.placeholder."mega-email"}
        pass = ${config.sops.placeholder."mega-password"}
      '';
    };
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs pkgs vars;};
    users.${vars.user.name} = {
      imports = [./../home];
      home.username = vars.user.name;
      home.homeDirectory = "/home/${vars.user.name}";
      home.stateVersion = vars.version;
    };
  };

  users.mutableUsers = true;
  users.users.${vars.user.name} = {
    isNormalUser = true;
    description = "Main user";
    extraGroups = ["wheel" "networkmanager" "scanner" "lp" "video" "input" "audio" "podman" "libvirtd" "kvm"];
    hashedPasswordFile = config.sops.secrets.password.path;
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = ["${vars.user.name}"];
}
