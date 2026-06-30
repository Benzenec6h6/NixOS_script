{vars, ...}: {
  home.persistence."/persist" = {
    directories = [
      "Downloads"
      "Desktop"
      "Documents"
      "Music"
      "Pictures"
      "Videos"
      "MEGA"
      ".cache/rclone"
      ".ssh"
      ".local/share/containers"
      ".local/share/distrobox"
      ".local/share/applications"
      ".local/share/direnv"
      ".config/zen"
      ".config/moomoo"
      ".config/Futu-Linux"
      ".config/keepassxc"
      ".config/gh"
      ".config/gh-dash"
      ".mozilla/native-messaging-hosts"
      #".megaCmd"
      #".mozilla/firefox"
      ".local/share/keepassxc"
    ];

    files = [
      ".config/sops/age/keys.txt"
    ];
  };
}
