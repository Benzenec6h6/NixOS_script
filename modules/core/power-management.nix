{ config, lib, pkgs, ... }:

{
  # ---------- S2idle Deep Sleep ----------
  boot.kernelParams = [
    "mem_sleep_default=deep"
    "pcie_aspm=force"
    "nvme.noacpi=1"
    "nvme_core.default_ps_max_latency_us=200000"
    "intel_pstate=passive"
  ];

  # ---------- Wi-Fi & Bluetooth ----------
  networking.networkmanager.wifi.powersave = true;
  hardware.bluetooth.powerOnBoot = false;

  # ---------- Realtek NIC ----------
  networking.usePredictableInterfaceNames = true;
  hardware.realtek.r8169.enable = true;

  # ---------- USB autosuspend ----------
  services.udev.extraRules = ''
    # 全USBデバイス autosuspend
    ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"

    # HP Wide Vision WebCam
    ATTR{idVendor}=="30c9", ATTR{idProduct}=="0069", ATTR{power/control}="auto"

    # Intel AX211 Bluetooth
    ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", ATTR{power/control}="auto"
  '';

  # ---------- Thunderbolt / TLP ----------
  services.tlp = {
    enable = true;
    settings = {
      USB_AUTOSUSPEND = 1;
      PCIE_ASPM_ON_BAT = "powersupersave";
      RUNTIME_PM_ON_BAT = "auto";
      RUNTIME_PM_DRIVER_BLACKLIST = "mei_me i2c_i801";
    };
  };
}
