{...}: {
  services.pipewire = {
    enable = true;
    wireplumber = {
      enable = true;
      configs = {
        "10-separate-volumes" = {
          "wireplumber.settings" = {
            "keep.routes.volume" = false;
          };
        };
      };
    };
  };
}
