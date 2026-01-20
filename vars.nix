{
  # 基本インフラ設定
  system = "";
  host = "HOST";
  disk = "DISK"; 
  
  # ユーザー情報
  user = {
    name = "";
    password = "HASH";
    gitName = "";
    gitEmail = "";
  };

  # 地域・言語・入力設定
  locale = {
    timeZone = "";
    default = "";
    extra = [ "" ];
    keyMap = "";
    kbLayout = "";
    
    location = {
      city = "";
      lat = "";
      lon = "";
    };
  };

  # GPU BusID
  busId = {
    intel = "INTEL_BUS";
    nvidia = "NVIDIA_BUS";
  };

  # 秘密鍵・APIキー
  apiKeys = {
    owm = ""; 
  };
}