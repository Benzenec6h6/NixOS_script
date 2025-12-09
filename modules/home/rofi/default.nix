{ config, pkgs, ... }:

{
    programs.rofi = {
        enable = true;
        package = pkgs.rofi;

        plugins = [
            pkgs.rofi-calc
            pkgs.rofi-mpd
            pkgs.rofi-screenshot
            pkgs.rofi-network-manager
            pkgs.rofi-bluetooth
            pkgs.todofi-sh
        ];

        extraConfig = {
            modi = "drun,run,window,calc,bluetooth";
            show-icons = true;
        };

    };

    home.file.".config/rofi".source = ./rasi;
}
