{ config, pkgs, ... }:

{
    programs.rofi = {
        enable = true;
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
        };
    };

    home.file.".config/rofi/myconf".source = ./rasi;
}