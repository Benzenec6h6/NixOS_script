{ vars, ... }: {
  programs.git = {
    enable = true;
    settings.user = {
      name = vars.user.gitName;
      email = vars.user.gitEmail;
    };
  };
}

