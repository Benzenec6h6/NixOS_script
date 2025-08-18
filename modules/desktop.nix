{ config, pkgs, lib, ... }:

{
  # ---------------------------------
  # X11 / Wayland
  # ---------------------------------
  services.xserver.enable = true;

  # ログインマネージャ（LightDM）を有効化
  services.xserver.displayManager.lightdm.enable = true;

  # i3 ウィンドウマネージャを有効化
  services.xserver.windowManager.i3.enable = true;

  # KDE Plasma 6 を有効化
  services.xserver.desktopManager.plasma6.enable = true;

  # Wayland / wlroots / Common Applications
  environment.systemPackages = with pkgs; [
     # --- Xorg 必須 ---
    xorg.xorgserver xorg.xmessage xorg.xrandr xorg.xev

    # --- Wayland 関連 ---
    wayland wayland-protocols libxkbcommon

    # --- wlroots/i3 用 ---
    wlr-randr

    # --- XDG portals (DE/WM 統合用) ---
    xdg-desktop-portal kdePackages.xdg-desktop-portal-kde xdg-desktop-portal-wlr

    # Terminal / Utilities
    alacritty foot wezterm tmux starship htop btop nvtopPackages.nvidia fzf ripgrep unzip unrar p7zip

    # Browsers / GUI apps
    firefox chromium vscode discord qbittorrent steam

    # Wine
    wineWowPackages.full

    # Virtualization
    qemu_full libvirt OVMF dnsmasq swtpm libosinfo virt-viewer

    # Containers
    docker

    # Dotfile management
    stow

    # Audio / video
    pipewire pipewire-pulse wireplumber
  ];

  # ---------------------------------
  # GPU / Microcode
  # ---------------------------------
  hardware.opengl.enable = true;

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;  # RTX 3060 Laptop → open ドライバを使う
  };

  # CPU microcode
  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.cpu.amd.updateMicrocode = false;

  # ---------------------------------
  # Power management & services
  # ---------------------------------
  services.power-profiles-daemon.enable = false;
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
