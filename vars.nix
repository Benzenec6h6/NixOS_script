{
  system = "x86_64-linux";
  version = "25.11";
  host = "laptop";
  disk = "/dev/nvme0n1";
  user = {
    name = "teto";
    terminal = "kitty";
    gitName = "Benzenec6h6";
    gitEmail = "aconitinec34h47no11@gmail.com";
  };
  locale = {
    timeZone = "Asia/Tokyo";
    default = "en_US.UTF-8";
    extra = [ "ja_JP.UTF-8/UTF-8" ];
    keyMap = "jp106";
    kbLayout = "jp";
  };
  busId = { intel = "PCI:0:2:0"; nvidia = "PCI:1:0:0"; };
}
