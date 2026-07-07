{
  config,
  pkgs,
  lib,
  vars,
  ...
}: let
  # あなたの vars.nix から渡されたデータ（vars.user.terminal は "kitty" になります）が
  # そのまま keybinddata.nix に流し込まれます。
  rawKeybinds = import ./keybinddata.nix {inherit lib vars;};

  # --- 1. 修飾キー（Modifier）の変換マップ ---
  mapMod = mod: let
    m = lib.strings.trim mod;
  in
    if m == ""
    then "NONE"
    else lib.replaceStrings [" "] ["+"] m;

  # --- 2. ディスパッチャーの変換マップ ---
  mapDispatcher = disp: arg:
    if disp == "exec"
    then "spawn"
    else if disp == "killactive"
    then "killactive"
    else if disp == "togglefloating"
    then "togglefloating"
    else if disp == "fullscreen"
    then
      (
        if arg == "1"
        then "fakefullscreen"
        else "fullscreen"
      )
    else if disp == "movefocus"
    then "focusdir"
    else if disp == "swapwindow"
    then "swapdir"
    else if disp == "workspace"
    then "view"
    else if disp == "movetoworkspace"
    then "tag"
    else if disp == "togglespecialworkspace"
    then "togglescratch"
    else "spawn";

  # --- 3. 引数の変換マップ ---
  mapArg = disp: arg:
    if disp == "workspace" && arg == "e+1"
    then "next"
    else if disp == "workspace" && arg == "e-1"
    then "prev"
    else if arg == "special"
    then "scratch"
    else arg;

  toMangoBind = b: let
    mod = mapMod b.mod;
    disp = mapDispatcher b.dispatcher b.arg;
    arg = mapArg b.dispatcher b.arg;
  in
    if arg == ""
    then "${mod},${b.key},${disp}"
    else "${mod},${b.key},${disp},${arg}";

  mangoBinds =
    (map toMangoBind rawKeybinds.main)
    ++ (map toMangoBind rawKeybinds.locked);
in {
  wayland.windowManager.mango = {
    enable = true;
    systemd.enable = true;
    autostart_sh = ''
      waybar &
      swaync &
    '';
    settings = {
      bind = mangoBinds;
    };
  };
}
