{ pkgs, ... }:

let
  script = pkgs.writeShellScriptBin "network-bluetooth-notify"
    (builtins.readFile ./network_bluetooth_notify.sh);
in
{
  environment.systemPackages = [ script ];

  systemd.user.services.network-bluetooth-notify = {
    description = "Network & Bluetooth Event Notify Script";
    serviceConfig = {
      ExecStart = "${script}/bin/network-bluetooth-notify";
    };
    wantedBy = [ "default.target" ];
  };
}
