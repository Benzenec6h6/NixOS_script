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
      ".ssh"
      ".local/share/containers"
      ".local/share/distrobox"
      ".local/share/applications"
      ".local/share/direnv"
      ".config/zen-browser"
      ".config/moomoo"
      ".config/Futu-Linux"
      ".config/keepassxc"
      ".mozilla/native-messaging-hosts"
      ".megaCmd"
      #".mozilla/firefox"
      ".local/share/keepassxc"
    ];

    files = [
      ".config/gh/hosts.yml"
      ".config/sops/age/keys.txt"
    ];
  };
}
