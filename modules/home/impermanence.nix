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
      ".local/share/containers"
      ".local/share/distrobox"
      ".local/share/applications"
      ".local/share/direnv"
      ".config/zen-browser"
      ".mozilla/native-messaging-hosts"
      #".mozilla/firefox"
      ".config/keepassxc"
      ".local/share/keepassxc"
    ];

    files = [
      ".config/gh/hosts.yml"
    ];
  };
}
