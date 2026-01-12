{ config, pkgs, ... }:

let
  # 自前スクリプトのパッケージ。適宜インポートパスを合わせてください
  brightness = pkgs.callPackage ./scripts/Brightness.nix {}; 
  hyprlockConf = "${config.home.homeDirectory}/.config/hypr/hyprlock/hyprlock.conf";
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock --config ${hyprlockConf}";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # --- 1. 暗転（Dimming） ---
        {
          timeout = 150;
          # 復帰のために現在の輝度を保存し、10%まで下げる
          on-timeout = "brightnessctl --save && brightnessctl set 10%";
          # 復帰時に保存した輝度に戻す
          on-resume = "brightnessctl --restore";
        }

        # --- 2. ロック（Lock） ---
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }

        # --- 3. 画面OFF（DPMS） ---
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # --- 4. サスペンド（Suspend） ---
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}