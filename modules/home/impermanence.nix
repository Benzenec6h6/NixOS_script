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
      ".ollama"
      ".local/share/keepassxc"
      ".local/share/keyrings"
      ".local/share/containers"
      ".local/share/distrobox"
      ".local/share/applications"
      ".local/share/zsh"
      ".local/share/zoxide"
      ".local/share/direnv"
      ".local/share/gh"
      ".config/zen"
      ".config/moomoo"
      ".config/Futu-Linux"
      ".config/keepassxc"
      ".config/gh"
      ".config/gh-dash"
      ".config/git"
      ".var/app"
      "Library/Containers/moomoo/2.0/Data/Library/Application Support"
    ];

    files = [
      ".config/sops/age/keys.txt"
      ".local/state/wireplumber/default-routes"
      ".local/state/wireplumber/stream-properties"
    ];
  };
}
