{ vars, ... }:

{
  disko.devices.disk.main = {
    type = "disk";
    device = vars.disk;

    content = {
      type = "gpt";
      partitions = {
        esp = {
          size = "512M";
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
            extraArgs = [ "-f" ];
            subvolumes = {
              "@root" = {
                mountpoint = "/";
                mountOptions = [ "compress=zstd" "noatime" ];
              };

              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [ "compress=zstd" "noatime" ];
              };

              "@home" = {
                mountpoint = "/home";
                mountOptions = [ "compress=zstd" "noatime" ];
                neededForBoot = true;
              };

              "@persist" = {
                mountpoint = "/persist";
                mountOptions = [ "compress=zstd" "noatime" ];
              };

              "@swap" = {
                mountpoint = "/.swapvol";
                swap.swapfile.size = "8G";
              };
            };
          };
        };
      };
    };
  };
}
