{ config, pkgs, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # 必要なら greeter ユーザーを自動で追加
  users.users.greeter = {
    isSystemUser = true;
    shell = pkgs.bashInteractive;
  };
}
