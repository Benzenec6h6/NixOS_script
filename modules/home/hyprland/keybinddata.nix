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
    { mod = "SUPER"; key = "V";  dispatcher = "togglefloating"; arg = ""; desc = "Toggle float"; }
    { mod = "SUPER ALT"; key = "SPACE"; dispatcher = "exec"; arg = "hyprctl dispatch workspaceopt allfloat"; desc = "All Float Mode";}
    { mod = "SUPER SHIFT"; key = "Return"; dispatcher = "exec"; arg = "Dropterminal ${vars.user.terminal}"; desc = "Dropdown terminal";}
    { mod = "SUPER CTRL ALT"; key = "B"; dispatcher = "exec"; arg = "pkill -SIGUSR1 waybar"; desc = "Toggle hide/show waybar";}
    { mod = "SUPER"; key = "H";      dispatcher = "exec"; arg = "keybind-menu"; desc = "Show this help"; }
    { mod = "SUPER"; key = "D";      dispatcher = "exec"; arg = "rofi -show drun"; desc = "App launcher"; category = "Apps"; }
    { mod = "SUPER"; key = "A";      dispatcher = "global"; arg = "quickshell:overviewToggle"; desc = "Desktop overview"; }
    { mod = "";      key = "Print";  dispatcher = "exec"; arg = "screenshot --area"; desc = "Screenshot"; }
    { mod = ""; key = "XF86Calculator"; dispatcher = "exec"; arg = "qalculate-gtk"; desc = "Open calculator";}
    { mod = "SUPER CTRL"; key = "right"; dispatcher = "workspace"; arg = "e+1"; desc = "Next workspace";}
    { mod = "SUPER CTRL"; key = "left"; dispatcher = "workspace"; arg = "e-1"; desc = "Previous workspace";}
    { mod = "SUPER SHIFT"; key = "SPACE"; dispatcher = "movetoworkspace"; arg = "special"; desc ="Move window to scratchpad (special workspace)"; }
    { mod = "SUPER"; key = "SPACE"; dispatcher = "togglespecialworkspace"; arg = ""; desc ="Toggle scratchpad overlay"; }
  ] 
  ++ (builtins.concatMap (d: [
    { mod = "SUPER";     key = d.key; dispatcher = "movefocus"; arg = d.dir; desc = "Focus ${d.label}"; }
    { mod = "SUPER ALT"; key = d.key; dispatcher = "swapwindow"; arg = d.dir; desc = "Swap ${d.label}"; }
  ]) directions)
  ++ (builtins.concatMap (n: let 
       ws = toString n; 
       key = if n == 10 then "0" else ws;
     in [
       { mod = "SUPER";       key = key; dispatcher = "workspace";       arg = ws; desc = "Switch to WS ${ws}"; }
       { mod = "SUPER SHIFT"; key = key; dispatcher = "movetoworkspace"; arg = ws; desc = "Move window to WS ${ws}"; }
     ]) (lib.range 1 10));

  # リピート/ロック中でも有効なバインド（bindl）
  locked = [
    { mod = ""; key = "XF86AudioRaiseVolume"; dispatcher = "exec"; arg = "volume --inc"; desc = "Vol +5"; }
    { mod = ""; key = "XF86AudioLowerVolume"; dispatcher = "exec"; arg = "volume --dec"; desc = "Vol -5"; }
    { mod = "SHIFT"; key = "XF86AudioRaiseVolume"; dispatcher = "exec"; arg = "volume --inc-fine"; desc = "Vol +1"; }
    { mod = "SHIFT"; key = "XF86AudioLowerVolume"; dispatcher = "exec"; arg = "volume --dec-fine"; desc = "Vol -1"; }
    { mod = ""; key = "XF86MonBrightnessDown"; dispatcher = "exec"; arg = "brightness --dec"; desc = "Bright -5"; }
    { mod = ""; key = "XF86MonBrightnessUp"; dispatcher = "exec"; arg = "brightness --inc"; desc = "Bright +5"; }
    { mod = "SHIFT"; key = "XF86MonBrightnessDown"; dispatcher = "exec"; arg = "brightness --dec-fine"; desc = "Bright -1"; }
    { mod = "SHIFT"; key = "XF86MonBrightnessUp"; dispatcher = "exec"; arg = "brightness --inc-fine"; desc = "Bright +1"; }
    { mod = ""; key = "XF86AudioMute"; dispatcher = "exec"; arg = "volume --toggle"; desc = "Mute"; }
    { mod = ""; key = "XF86AudioPlay"; dispatcher = "exec"; arg = "playerctl play-pause"; desc = "Play/Pause"; }
    { mod = ""; key = "XF86AudioPause"; dispatcher = "exec"; arg = "playerctl play-pause"; desc = "Play/Pause";}
    { mod = ""; key = "XF86AudioNext"; dispatcher = "exec"; arg = "playerctl next"; desc = "Next";}
    { mod = ""; key = "XF86AudioPrev"; dispatcher = "exec"; arg = "playerctl previous"; desc = "Previous";}
  ];
}