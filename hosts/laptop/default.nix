{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ../../modules/core
  ];

  #boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  chaotic.nyx.cache.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      #intel-media-driver
    ];
  };
  
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    dynamicBoost.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    prime = {
      intelBusId = vars.busId.intel;
      nvidiaBusId = vars.busId.nvidia;
      #offload.enable = true;
      sync.enable = true;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };
  
  boot.initrd.systemd.services.rollback = {
    description = "Rollback Btrfs root subvolume to a pristine state";
    wantedBy = [ "initrd.target" ];
    # rootパーティションが出現した後、かつマウントされる前に実行
    after = [ "dev-disk-by\x2dpartlabel-root.device" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      # 必要なバイナリ(bash, btrfs-progs, coreutils)を確実にパスに通して実行
      ExecStart = let
        script = pkgs.writeShellScript "rollback" (builtins.readFile ./rollback.sh);
      in "${script}";
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="hwmon", ATTR{name}=="coretemp", RUN+="${pkgs.bash}/bin/bash -c 'ln -sfn /sys%p /run/hwmon-coretemp'"
  '';

  networking.hostName = vars.host;
  system.stateVersion = "25.11";
}
