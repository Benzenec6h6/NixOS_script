{ config, pkgs, ... }:

{ 
  environment.systemPackages = with pkgs; [
    vim nano
    pciutils usbutils
    git jq psmisc glib
    wget curl yt-dlp animdl
    ripgrep dust tree
    gcc gnumake pkg-config
    dnsutils inetutils iproute2 netcat
    mesa vulkan-tools

    hyprland hyprlock hypridle
    kitty
    polkit_gnome libsecret
    udiskie
    networkmanager_dmenu
    ffmpegthumbnailer

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
