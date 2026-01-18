{ vars, ... }:

{
  imports = [ inputs.impermanence.homeManagerModules.impermanence ];

  home.persistence."/persist/home/${vars.user.name}" = {
    directories = [
      "Downloads"
      "Desktop"
      "Documents"
      "Music"
      "Pictures"
      "Videos"
      ".ssh"
      ".local/share/direnv"
      ".config/zen-browser"
      ".mozilla/firefox"
    ];
    allowOther = true;
  };
}