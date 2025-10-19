{ config, pkgs, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.starship;
    settings = {
      add_newline = false;
      format = "$all$character";

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      
      git_branch = {
        symbol = "🌱 ";
        truncation_length = 24;
      };

      nix_shell = {
        symbol = " ";
        format = "[$symbol$state( $name)]($style) ";
      };

      directory = {
        truncation_length = 3;
        style = "bold blue";
      };

      cmd_duration = {
        disabled = false;
        format = "took [$duration]($style) ";
      };
      
      python = {
        symbol = " ";
        format = "[$symbol$version]($style) ";
      };
    };
  };
}