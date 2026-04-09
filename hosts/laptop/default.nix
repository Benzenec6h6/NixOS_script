{ config, pkgs, lib, inputs, vars, ... }:

{
  imports = [
    ./hardware.nix
    ./disko.nix
    ./vhdx-mount.nix
    ../../modules/core
  ];

  #boot.kernelPackages = pkgs.linuxPackages_6_18;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-lts-x86_64-v3;
  services.ananicy = {
    enable = true;
    rulesProvider = pkgs.ananicy-rules-cachyos;
    package = pkgs.ananicy-cpp;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      intel-media-driver
      libvdpau-va-gl
      vpl-gpu-rt
    ];
  };
  
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    videoAcceleration = true;
    modesetting.enable = true;
    dynamicBoost.enable = false;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    prime = {
      intelBusId = vars.busId.intel;
      nvidiaBusId = vars.busId.nvidia;
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      #sync.enable = true;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  environment.variables = {
    #LIBVA_DRIVER_NAME = "nvidia";
    #NVD_BACKEND = "direct";
  };
  
  boot.initrd.systemd.services.rollback = {
    description = "Rollback Btrfs root subvolume to a pristine state";
    wantedBy = [ "initrd.target" ];
    # rootパーティションが出現した後、かつマウントされる前に実行
    after = [ "dev-disk-by\\x2dpartlabel-disk\\x2dmain\\x2droot.device" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    path = with pkgs; [ btrfs-progs coreutils gawk gnused ];
    serviceConfig = {
      Type = "oneshot";
      # 必要なバイナリ(bash, btrfs-progs, coreutils)を確実にパスに通して実行
      ExecStart = pkgs.writeShellScript "rollback" (builtins.readFile ./rollback.sh);
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="hwmon", ATTR{name}=="coretemp", RUN+="${pkgs.bash}/bin/bash -c 'ln -sfn /sys%p /run/hwmon-coretemp'"
  '';

  networking.hostName = vars.host;
  system.stateVersion = vars.version;
}
