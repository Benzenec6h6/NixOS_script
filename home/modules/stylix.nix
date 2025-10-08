{ pkgs, ... }:
{
  stylix = {
    enable = true;

    # 壁紙など Stylix に任せたくないなら image は指定しない
    # image = null; ← 書かなくてもOK

    # テーマの基本方向（dark / light）
    polarity = "dark";

    # 透明度設定（ターミナルなどで有効）
    opacity.terminal = 1.0;

    # カーソルテーマ
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    # フォント設定
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
