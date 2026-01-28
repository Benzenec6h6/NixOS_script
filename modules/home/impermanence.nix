{ vars, ... }:

{
  home.persistence."/persist" = {
    directories = [
      "Downloads"
      "Desktop"
      "Documents"
      "Music"
      "Pictures"
      "Videos"
      "MEGA"
      ".ssh"
      ".local/share/direnv"
      ".config/zen-browser"
      ".mozilla/firefox"
    ];
  };
}