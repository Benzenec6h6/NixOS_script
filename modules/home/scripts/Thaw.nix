{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "thaw";

  runtimeInputs = with pkgs; [
    bash
    coreutils   # test, echo など
    gnutar         # .tar, .tar.gz, .tar.xz, .tar.bz2 用
    gzip        # .gz 用
    xz          # .xz 用
    bzip2       # .bz2 用
    unar        # .zip, .7z, .rar およびその他多くの形式の解凍・文字化け対策用
  ];

  text = builtins.readFile ./Thaw.sh;
}