{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "recorder";
  runtimeInputs = [ 
    pkgs.wf-recorder 
    pkgs.slurp 
    pkgs.ffmpeg-full 
    pkgs.jq 
    pkgs.pulseaudio 
    pkgs.libnotify 
    pkgs.procps 
    pkgs.coreutils 
    pkgs.papirus-icon-theme # アイコンテーマを明示的にパスに含める
  ];
  text = builtins.readFile ./recorder.sh;
}