{
  config,
  pkgs,
  ...
}: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/start-hyprland";
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
