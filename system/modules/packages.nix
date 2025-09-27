{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  environment.systemPackages = with pkgs; [
    vim nano
    pciutils usbutils
    git fastfetch
    wget curl
    gnutar gzip unzip zip
    htop btop
    gcc gnumake pkg-config
    dnsutils inetutils iproute2 netcat
    mesa vulkan-tools
    networkmanager bluez #networkmanagerapplet bluemanはユーザ側
    #kdePackages.sddm 
    kdePackages.sddm-kcm
    /*
    catppuccin-sddm
    sddm-astronaut
    sddm-sugar-dark
    sddm-chili-theme
    elegant-sddm
    where-is-my-sddm-theme
    catppuccin-sddm-corners
    */
  ];
}
