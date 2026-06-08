{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    cycle = true;
    package = pkgs.rofi;

    plugins = [
      pkgs.rofi-calc
      pkgs.rofi-mpd
      pkgs.rofi-screenshot
      #pkgs.rofi-network-manager
      pkgs.rofi-bluetooth
      pkgs.todofi-sh
    ];

    extraConfig = {
      modi = "drun,run,window,calc";
      show-icons = true;

      run-command = "uwsm app -- {cmd}";
      run-shell-command = "uwsm app -- {terminal} -e {cmd}";
      drun-use-desktop-cache = false;
    };
  };

  #home.file.".config/rofi/myconf".source = ./rasi;
}
