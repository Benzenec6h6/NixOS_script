{pkgs, ...}: {
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      xfce4-exo
      thunar-archive-plugin
      thunar-volman
      #tumbler
    ];
  };
}
