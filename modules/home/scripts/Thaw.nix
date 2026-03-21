{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "thaw";

  runtimeInputs = with pkgs; [
    bash
    coreutils   # test, echo など
    gnutar         # .tar, .tar.gz, .tar.xz, .tar.bz2 用
    zstd
    pixz        # .xz 用
    pbzip2      # .bz2 用
    pigz        # .gz 用
    unar        # .zip, .7z, .rar およびその他多くの形式の解凍・文字化け対策用
  ];

  text = builtins.readFile ./Thaw.sh;
}
