{ config, lib, pkgs, vars, ... }:

{
  boot.loader = {
    # EFI変数の操作許可（共通）
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = lib.mkForce false;

    # --- Limine の設定 ---
    limine = lib.mkIf (vars.bootloader == "limine") {
      enable = true;
      efiSupport = true;
      # 世代（バックアップ）の保持数
      maxGenerations = 5;
      
      # セキュアブート対応
      secureBoot = {
        enable = true;
        sbctl = pkgs.sbctl;
      };
    };
  };

  boot.lanzaboote = lib.mkIf (vars.bootloader == "systemd-boot") {
    enable = true;
    pkiBundle = "/var/lib/sbctl"; # すでに作成した鍵の場所を指定
  };
}
