{ pkgs }:

pkgs.writeShellScriptBin "keybinds" ''
  #!${pkgs.bash}/bin/bash
  # 🧭 Hyprland keybind viewer for rofi
  # Dependencies: rofi, libnotify, coreutils, grep, sed

  HYPRLAND_NIX="/etc/nixos/NixOS_script/modules/home/wm/hyprland.nix"
  HEADER=" = SUPER (Win Key)"
  MSG='🔍 Search or scroll to view your keybinds (Press Esc to exit)'

  describe_command() {
    local cmd="$1"
    case "$cmd" in
      *kitty*) echo "Open terminal" ;;
      *zen*) echo "Open web browser (Zen)" ;;
      *wlogout*) echo "Show logout menu" ;;
      *thunar*) echo "Open file manager" ;;
      *toggle-waybar*) echo "Toggle Waybar visibility" ;;
      *help_shortcuts.sh*) echo "Show help / shortcuts list" ;;
      *rofi*) echo "Open application launcher" ;;
      *wpctl*5%+*) echo "Increase volume (+5%)" ;;
      *wpctl*5%-*) echo "Decrease volume (-5%)" ;;
      *wpctl*1%+*) echo "Increase volume (+1%)" ;;
      *wpctl*1%-*) echo "Decrease volume (-1%)" ;;
      *mute*) echo "Toggle mute" ;;
      *playerctl*play-pause*) echo "Play/Pause media" ;;
      *playerctl*next*) echo "Next track" ;;
      *playerctl*previous*) echo "Previous track" ;;
      *brightnessctl*5%+*) echo "Increase brightness (+5%)" ;;
      *brightnessctl*5%-*) echo "Decrease brightness (-5%)" ;;
      *brightnessctl*1%+*) echo "Increase brightness (+1%)" ;;
      *brightnessctl*1%-*) echo "Decrease brightness (-1%)" ;;
      *movefocus*) echo "Move focus between windows" ;;
      *swapwindow*) echo "Swap window position" ;;
      *workspace*,*) echo "Switch workspace" ;;
      *movetoworkspace*) echo "Move window to workspace" ;;
      *togglespecialworkspace*) echo "Toggle special workspace" ;;
      *) echo "Custom action" ;;
    esac
  }

  # --- check file existence ---
  if [[ ! -f "$HYPRLAND_NIX" ]]; then
      ${pkgs.libnotify}/bin/notify-send "Keybinds Viewer" "❌ hyprland.nix not found: $HYPRLAND_NIX"
      exit 1
  fi

  # --- extract bind lines ---
  keybinds=$(${pkgs.gnugrep}/bin/grep -E '^[[:space:]]*"[^"]*,[^"]*,[^"]*"' "$HYPRLAND_NIX" | ${pkgs.gnugrep}/bin/grep bind -v)

  if [[ -z "$keybinds" ]]; then
      ${pkgs.libnotify}/bin/notify-send "Keybinds Viewer" "⚠️ No keybinds found in hyprland.nix"
      exit 1
  fi

  # --- format lines for display ---
  formatted_binds=""
  while IFS= read -r line; do
    clean=$(echo "$line" | ${pkgs.gnused}/bin/sed 's/"//g' | ${pkgs.gnused}/bin/sed 's/^ *//' | ${pkgs.gnused}/bin/sed 's/,$//')
    key_combo=$(echo "$clean" | cut -d',' -f1-2 | ${pkgs.gnused}/bin/sed 's/,/ + /')
    action=$(echo "$clean" | cut -d',' -f3-)
    desc=$(describe_command "$action")
    formatted_binds+="$key_combo → $action  [$desc]\n"
  done <<< "$keybinds"

  display_keybinds=$(echo -e "$formatted_binds" | ${pkgs.gnused}/bin/sed 's/SUPER//g')
  display_keybinds="$HEADER\n───────────────────────────────\n$display_keybinds"

  echo -e "$display_keybinds" | ${pkgs.rofi}/bin/rofi -dmenu -i -mesg "$MSG"
''

