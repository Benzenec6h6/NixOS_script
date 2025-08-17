{ config, pkgs, ... }:

{
  # ---------------------------------
  # X11 / Wayland
  # ---------------------------------
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.xserver.windowManager.i3.enable = true;

  services.xserver.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.plasma5.enable = false;

  services.xserver.desktopManager.default = "i3"; # LightDM でデフォルト WM

  # Wayland / wlroots / Common Applications
  environment.systemPackages = with pkgs; [
    xorg.xorgserver xorg.xorgxinit xorg.xorgapp xorg.xorgxmessage
    wayland wayland-protocols xorg.xorgxwayland libxkbcommon
    wlr-randr xdg-desktop-portal xdg-desktop-portal-wlr
    # Terminal / Utilities
    alacritty foot wezterm tmux starship htop btop nvtop fzf ripgrep unzip unrar p7zip

    # Browsers / GUI apps
    firefox chromium vscode discord qbittorrent steam

    # Wine
    wineWowPackages.full

    # Virtualization
    qemu_full libvirt edk2-ovmf dnsmasq swtpm libosinfo virt-viewer virt-install

    # Containers
    docker

    # Dotfile management
    stow

    # Audio / video
    pipewire pipewire-alsa pipewire-pulse wireplumber
  ];

  # ---------------------------------
  # GPU / Microcode
  # ---------------------------------
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # NVIDIA
  hardware.nvidia.enable = lib.mkDefault (builtins.any (l: l == "nvidia") (builtins.attrNames pkgs));

  # CPU microcode
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages.intel_ucode.enable = true;
  boot.kernelPackages.amd_ucode.enable = false;

  # ---------------------------------
  # Power management & services
  # ---------------------------------
  services.tlp.enable = true;
  services.printing.enable = true;
  services.blueman.enable = true;

  # ---------------------------------
  # Input Method / Fonts
  # ---------------------------------
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ];

  fonts = {
    enableDefaultFonts = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      hack-font
      ttf-cascadia-code
      adobe-source-han-sans-otc-fonts
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = [ "Noto Sans CJK JP" ];
        serif     = [ "Noto Serif CJK JP" ];
        monospace = [ "JetBrains Mono" "Fira Code" "Hack" "Cascadia Code" ];
      };
    };
  };

  # ---------------------------------
  # Docker
  # ---------------------------------
  virtualisation.docker.enable = true;

  # ---------------------------------
  # Extra startup
  # ---------------------------------
  services.xserver.displayManager.sessionCommands = ''
    nm-applet &
    fcitx5 -d &
  '';
}
