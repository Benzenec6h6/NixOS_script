{ ... }: {
  programs.git = {
    enable = true;
    settings.user = {
      name = vars.user.gitName;
      email = vars.user.gitEmail;
    };
    config = {
      credential.helper = "keepassxc";
      # SSH鍵の署名を検証する場合などに備えて
      # gpg.format = "ssh"; 
    };
  };
}