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
      ".cache/zen"
      ".ssh"
      ".local/share/keyrings"
      ".local/share/containers"
      ".local/share/distrobox"
      ".local/share/applications"
      ".local/share/direnv"
      ".local/share/gh"
      ".config/zen"
      ".config/moomoo"
      ".config/Futu-Linux"
      ".config/keepassxc"
      ".config/gh"
      ".config/gh-dash"
      #".mozilla/native-messaging-hosts"
      #".megaCmd"
      #".mozilla/firefox"
      ".local/share/keepassxc"
      ".var/app"
    ];

    files = [
      ".config/sops/age/keys.txt"
    ];
  };
}
