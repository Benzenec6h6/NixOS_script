{
  config,
  pkgs,
  ...
}: {
  # Tailscaleの土台を起動
  services.tailscale.enable = true;

  # 自分自身のファイアウォール防衛（お父様のPCからのパケットを通す）
  networking.firewall = {
    enable = true;
    trustedInterfaces = ["tailscale0"];
  };
}
