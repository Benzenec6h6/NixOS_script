{ config, pkgs, ... }:

{
  security = {
    # sudo 設定
    sudo = {
      enable = true;
      wheelNeedsPassword = true; # wheel グループのユーザーにパスワード要求
    };

    # polkit (GUI アプリの権限昇格)
    polkit.enable = true;

    # パスワード認証の強化 (libpam)
    pam.services ={
      sshd.showMotd = true; # SSH接続時にmotd表示
      login.enableGnomeKeyring = true;
      sddm.enableGnomeKeyring = true;   # SDDM を使う場合
      #greetd.enableGnomeKeyring = true; # greetd を使う場合
    };

    tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };

  # 追加: AppArmor (使いたければ)
  # security.apparmor.enable = true;

  # 追加: SELinux (実験的)
  # security.selinux.enable = true;
}
