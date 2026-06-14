{pkgs, ...}: let
  # 1. このファイルの中だけで使うローカルなパッケージとしてスクリプトを定義
  storageAlert = pkgs.writeShellApplication {
    name = "storage-alert";
    runtimeInputs = [pkgs.libnotify pkgs.coreutils pkgs.bash];
    text = builtins.readFile ./storage.sh;
  };
in {
  # 2. システム全体（environment.systemPackages）に登録
  environment.systemPackages = [storageAlert];

  # 3. この機能専用のudevルールをここで定義（${storageAlert} で直接パスを埋め込める！）
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", ENV{DEVTYPE}=="disk", ATTR{removable}=="1", RUN+="${storageAlert}/bin/storage-alert %k"
  '';
}
