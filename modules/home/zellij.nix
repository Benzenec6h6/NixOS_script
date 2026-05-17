{ ... }:
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true; # Zsh起動時に自動でZellijの世界へ
  
    # 快適なシェル連携のための2種の神器
    attachExistingSession = true; # 既存のセッションがあれば自動復帰
    exitShellOnExit = true;       # Zellij終了時にターミナルも閉じる

    settings = {
      default_mode = "locked";    # 最初はNeovimの邪魔をしないロックモード
      mouse_mode = true;          # マウスでの直感操作も一応許可
    
      # 既存のテーマを使う場合は指定（テーマ名は文字列で）
      #theme = "nord"; 
    };
  };
}
