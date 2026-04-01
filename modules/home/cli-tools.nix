{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # --- 2. nh (Nix Helper) (最小構成) ---
  programs.nh = {
    enable = true;
    # OSかHome Manager、メインで使っているflakeのパスを指定（任意）
    flake = "/home/teto/Documents/nixproject/NixOS_script"; 
    
    #clean = {
    #  enable = true;
    #   毎週月曜日に、3日より古い世代を削除し、最低5世代は残す設定（例）
    #  extraArgs = "--keep-since 3d --keep 5";
    #};
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.bat.enable = true;
  programs.fd.enable = true;
  programs.nix-your-shell.nix-output-monitor.enable = true; 
}
