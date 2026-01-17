{
  # システム基本情報
  host = ;
  disk = ; # install.shで取得
  
  # ユーザー情報
  user = {
    name = ;
    password = ; # ハッシュ化したものを入れる
  };

  # 地域・言語設定
  locale = {
    timeZone = ;
    default = ;
    extra = [  ];
    keyMap = ;
    kbLayout = ;  # X11/Wayland (Hyprland) 用 ★追加
    # 天気予報用
    location = {
      city = ;
      lat = ;
      lon = ;
    };
  };

  # ハードウェア固有設定
  busId = {
    intel = ;
    nvidia = ;
  };

  # 外部APIキー（取り扱いに注意）
  apiKeys = {
    owm = ""; # OpenWeatherMap Key
  };
}