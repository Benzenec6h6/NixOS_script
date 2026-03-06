{ lib, vars, ... }:
let
  # 方向キーの定義
  directions = [
    { key = "left";  dir = "l"; label = "Left"; }
    { key = "right"; dir = "r"; label = "Right"; }
    { key = "up";    dir = "u"; label = "Up"; }
    { key = "down";  dir = "d"; label = "Down"; }
  ];
in
{
  # メインのキーバインド（bind）
  main = [
    { mod = "SUPER"; key = "Return"; dispatcher = "exec"; arg = "${vars.user.terminal}"; desc = "Open terminal"; category = "Apps"; }
    { mod = "SUPER"; key = "B";      dispatcher = "exec"; arg = "zen";   desc = "Open browser"; category = "Apps"; }
    { mod = "SUPER"; key = "Q";      dispatcher = "killactive"; arg = ""; desc = "Kill active window"; }
    { mod = "SUPER"; key = "P";      dispatcher = "exec"; arg = "wlogout -p layer-shell"; desc = "Power menu"; category = "Apps"; }
    { mod = "SUPER"; key = "E";      dispatcher = "exec"; arg = "thunar"; desc = "File manager"; category = "Apps"; }
    { mod = "SUPER SHIFT"; key = "F"; dispatcher = "fullscreen"; arg = "0"; desc = "Fullscreen"; }
    { mod = "SUPER CTRL";  key = "F"; dispatcher = "fullscreen"; arg = "1"; desc = "Fake fullscreen"; }
    { mod = "SUPER"; key = "SPACE";  dispatcher = "togglefloating"; arg = ""; desc = "Toggle float"; }
    { mod = "SUPER"; key = "H";      dispatcher = "exec"; arg = "KeyBinds"; desc = "Show this help"; }
    { mod = "SUPER"; key = "D";      dispatcher = "exec"; arg = "rofi -show drun"; desc = "App launcher"; category = "Apps"; }
    { mod = "SUPER"; key = "A";      dispatcher = "global"; arg = "quickshell:overviewToggle"; desc = "Desktop overview"; }
    { mod = "";      key = "Print";  dispatcher = "exec"; arg = "screenshot --area"; desc = "Screenshot"; }
  ] 
  ++ (builtins.concatMap (d: [
    { mod = "SUPER";     key = d.key; dispatcher = "movefocus"; arg = d.dir; desc = "Focus ${d.label}"; }
    { mod = "SUPER ALT"; key = d.key; dispatcher = "swapwindow"; arg = d.dir; desc = "Swap ${d.label}"; }
  ]) directions)
  ++ (map (n: let 
       ws = toString n; 
       key = if n == 10 then "0" else ws;
     in { mod = "SUPER"; key = key; dispatcher = "workspace"; arg = ws; desc = "Switch to WS ${ws}"; }
     ) (lib.range 1 10));

  # リピート/ロック中でも有効なバインド（bindl）
  locked = [
    { mod = ""; key = "XF86AudioRaiseVolume"; dispatcher = "exec"; arg = "volume --inc"; desc = "Vol +"; }
    { mod = ""; key = "XF86AudioLowerVolume"; dispatcher = "exec"; arg = "volume --dec"; desc = "Vol -"; }
    { mod = ""; key = "XF86AudioMute";        dispatcher = "exec"; arg = "volume --toggle"; desc = "Mute"; }
    { mod = ""; key = "XF86AudioPlay";        dispatcher = "exec"; arg = "playerctl play-pause"; desc = "Play/Pause"; }
  ];
}