{ config, pkgs, ... }:

let
  # nixpkgsのsddm-astronautをベースに、引数だけを上書き
  astronautTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
    # 必要に応じて、ここでさらに詳細な設定（themeConfig）も可能です
  };
in
{
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;

      # テーマ名はnixpkgsの定義に従いこれを使います
      theme = "sddm-astronaut-theme";
      
      # 必要なQtパッケージは自動的に伝播（Propagate）されますが、
      # 明示的に追加しておく場合もこちらで大丈夫です
      extraPackages = with pkgs.kdePackages; [
        qtmultimedia
        qtvirtualkeyboard
        qtsvg
      ];
    };
  };

  environment.systemPackages = [
    pkgs.kdePackages.qtbase
    astronautTheme # 上記で定義したカスタムテーマ
  ];
}
