{ config, pkgs, ... }:
{
    services.ollama = {
        enable = true;
        acceleration = "cuda";
        
        # 最新のエンジンを使う（unstableチャンネルを設定している前提）
        package = pkgs.unstable.ollama;

        # VRAM 6GBを効率よく使うためのチューニング
        environmentVariables = {
            OLLAMA_KEEP_ALIVE = "30m"; # 30分間はVRAMに保持（ロード待ち解消）
            OLLAMA_FLASH_ATTENTION = "1"; # 推論の高速化とメモリ節約
        };
        #以下optionはdesktop購入後に検討
        #host = "0.0.0.0";
        #16 bit unsigned integer; between 0 and 65535 (both inclusive) default=11434
        #port = 11434;
    };
}