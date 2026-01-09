{ pkgs, ... }:

let
  batteryMonitor = pkgs.writeShellApplication {
    name = "battery-monitor";
    # 依存するパッケージを明示（これでスクリプト内でフルパスを書かなくて済む）
    runtimeInputs = [ pkgs.libnotify pkgs.coreutils pkgs.bash ];
    text = builtins.readFile ./battery.sh;
  };
in
{
  home.packages = [ batteryMonitor ];

  systemd.user.services.battery-monitor = {
    Unit = {
      Description = "Battery monitor notifications";
    };

    Service = {
      Type = "oneshot";
      # 修正：環境によってはDISPLAYやDBUS_SESSION_BUS_ADDRESSが必要
      # notify-sendをsystemdから飛ばすための一般的な設定
      Environment = "PATH=/run/current-system/sw/bin";
      ExecStart = "${batteryMonitor}/bin/battery-monitor";
    };
  };

  systemd.user.timers.battery-monitor = {
    Unit = {
      Description = "Periodic battery check";
    };

    Timer = {
      OnBootSec = "10s";
      OnUnitActiveSec = "30s";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}