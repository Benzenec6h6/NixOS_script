{ device, ... }:

{
  disko.devices.disk.main = {
    device = device;
    type = "disk";

    content = {
      type = "gpt";
      partitions = {
        esp = {
          size = "256M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        root = {
          size = "100%";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ]; # 上書きを許可
            subvolumes = {
              "@root" = { 
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@nix"  = { 
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@home" = { 
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@persist" = { 
                mountpoint = "/persist";
                mountOptions = [ "compress=zstd" "noatime" ];
              };
              "@swap" = {
                mountpoint = "/.swapvol";
                swap.swapfile.size = "4G"; # スワップファイルが必要な場合
              };
            };
          };
        };
      };
    };
  };
}
