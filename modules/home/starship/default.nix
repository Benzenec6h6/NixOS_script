{ config, lib, ...}:

{
    programs.starship = {
        enable = true;

        # Stylix の base16 を無効化して自分のテーマを強制
        settings.palette = lib.mkForce "myth-orange-dark";
        # 外部 TOML ファイルを読み込む
        settings = builtins.fromTOML (builtins.readFile ./starship.toml);

        # 好みでシェル統合を設定
        enableZshIntegration = true;
        enableBashIntegration = true;
        enableFishIntegration = false;

        # ログイン時に Starship を確実にロードしたい場合
        # initExtraCommand = ''
        #   eval "$(starship init zsh)"
        # '';
    };
}