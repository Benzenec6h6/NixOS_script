{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;

    # configFile / styleFile でそれぞれJSONとCSSを直接埋め込みます。
    settings = [{
      layer = "top";
      #mode = "dock";
      exclusive = true;
      passthrough = false;
      position = "top";
      spacing = 3;
      fixed-center = true;
      ipc = true;
      margin-top = 3;
      margin-left = 8;
      margin-right = 8;

      modules-left = [
        "custom/separator#blank"
        "custom/cava_mviz"
        "custom/separator#blank"
        "custom/playerctl"
        "custom/separator#blank_2"
        "hyprland/window"
      ];

      modules-center = [
        #"custom/separator#blank"
        "custom/swaync"
        "custom/separator#dot-line"
        "hyprland/workspaces#rw"
        "clock"
        "custom/separator#dot-line"
        "custom/weather"
        "custom/separator#dot-line"
        "idle_inhibitor"
        "custom/hint"
      ];

      modules-right = [
        "tray"
        "network#speed"
        "custom/separator#dot-line"
        "group/mobo_drawer"
        "custom/separator#line"
        "group/audio"
        "custom/separator#dot-line"
        "custom/wlogout"
      ];

      "temperature" = {
          "interval" = 10;
          "tooltip" = true;
          "hwmon-path" = [
              "/sys/class/hwmon/hwmon1/temp1_input"
              "/sys/class/thermal/thermal_zone0/temp"
          ];
          #"thermal-zone" = 0;
          "critical-threshold" = 82;
          "format-critical" = "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
              "󰈸"
          ];
      };
      "backlight" = {
          "interval" = 2;
          "align" = 0;
          "rotate" = 0;
          #"format" = "{icon} {percent}%";
          "format-icons" = [
              " "
              " "
              " "
              "󰃝 "
              "󰃞 "
              "󰃟 "
              "󰃠 "
          ];
          "format" = "{icon}";
          #"format-icons" = ["" "" "" "" "" "" "" "" "" "" "" "" "" "" ""];
          "tooltip-format" = "backlight {percent}%";
          "icon-size" = 10;
          "on-click" = "";
          "on-click-middle" = "";
          "on-click-right" = "";
          "on-update" = "";
          "on-scroll-up" = "$HOME/.config/hypr/scripts/Brightness.sh --inc";
          "on-scroll-down" = "$HOME/.config/hypr/scripts/Brightness.sh --dec";
          "smooth-scrolling-threshold" = 1;
      };
      "backlight#2" = {
          "device" = "intel_backlight";
          "format" = "{icon} {percent}%";
          "format-icons" = [
              ""
              ""
          ];
      };
      "battery" = {
          #"interval" = 5;
          "align" = 0;
          "rotate" = 0;
          #"bat" = "BAT1";
          #"adapter" = "ACAD";
          "full-at" = 100;
          "design-capacity" = false;
          "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "format-plugged" = "󱘖 {capacity}%";
          "format-alt-click" = "click";
          "format-full" = "{icon} Full";
          "format-alt" = "{icon} {time}";
          "format-icons" = [
              "󰂎"
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
          ];
          "format-time" = "{H}h {M}min";
          "tooltip" = true;
          "tooltip-format" = "{timeTo} {power}w";
      };
      "bluetooth" = {
          "format" = " ";
          "format-disabled" = "󰂳";
          "format-connected" = "󰂱 {num_connections}";
          "tooltip-format" = " {device_alias}";
          "tooltip-format-connected" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" = " {device_alias} 󰂄{device_battery_percentage}%";
          "tooltip" = true;
          "on-click" = "blueman-manager";
      };
      "clock" = {
          "interval" = 1;
          #"format" = " {:%I:%M %p}"; # AM PM format
          "format" = " {:%H:%M:%S}"; # 24H
          "format-alt" = " {:%H:%M   %Y, %d %B, %A}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
              "mode" = "year";
              "mode-mon-col" = 3;
              "weeks-pos" = "right";
              "on-scroll" = 1;
              "format" = {
                  "months" = "<span color='#ffead3'><b>{}</b></span>";
                  "days" = "<span color='#ecc6d9'><b>{}</b></span>";
                  "weeks" = "<span color='#99ffdd'><b>W{:%V}</b></span>";
                  "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
                  "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
              };
          };
      };
      "actions" = {
          "on-click-right"= "mode";
          "on-click-forward"= "tz_up";
          "on-click-backward"= "tz_down";
          "on-scroll-up"= "shift_up";
          "on-scroll-down"= "shift_down";
      };
      "clock#2"= {
          #"format": " {:%I:%M %p}", # AM PM format
          "format"= "  {:%H:%M}"; # 24H
          "format-alt"= "{:%A  |  %H:%M  |  %e %B}";
          "tooltip-format"= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      "clock#3"= {
          #"format"= "{:%I:%M %p - %d/%b}"; #for AM/PM
          "format"= "{:%H:%M - %d/%b}"; # 24H
          "tooltip"= false;
      };
      "clock#4"= {
          "interval"= 60;
          #"format"= "{:%B | %a %d, %Y | %I:%M %p}"; # AM PM format
          "format"= "{:%B | %a %d, %Y | %H:%M}"; # 24H
          "format-alt"= "{:%a %b %d, %G}";
          "tooltip-format"= "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };
      "clock#5"= {
          #"format"= "{:%A, %I:%M %P}"; # AM PM format
          "format"= "{:%a %d | %H:%M}"; # 24H
          "format-alt"= "{:%A, %d %B, %Y (%R)}";
          "tooltip-format"= "<big>{:%B %Y}</big>\n<tt><small>{calendar}</small></tt>";
      };
      "cpu"= {
          "format"= "{usage}% 󰍛";
          "interval"= 1;
          "min-length"= 5;
          "format-alt-click"= "click";
          "format-alt"= "{icon0}{icon1}{icon2}{icon3} {usage:>2}% 󰍛";
          "format-icons"= [
              "▁"
              "▂"
              "▃"
              "▄"
              "▅"
              "▆"
              "▇"
              "█"
          ];
      };
      "disk"= {
          "interval"= 30;
          #"format"= "󰋊";
          "path"= "/";
          #"format-alt-click"= "click";
          "format"= "{percentage_used}% 󰋊";
          #"tooltip"= true;
          "tooltip-format"= "{used} used out of {total} on {path} ({percentage_used}%)";
      };
      "hyprland/language"= {
          "format"= "Lang: {}";
          "format-en"= "US";
          "format-tr"= "Korea";
          "keyboard-name"= "at-translated-set-2-keyboard";
          "on-click"= "hyprctl switchxkblayout $SET_KB next";
      };
      "hyprland/submap"= {
          "format"= "<span style=\"italic\">  {}</span>"; # Icon: expand-arrows-alt
          "tooltip"= false;
      };
      "hyprland/window"= {
          "format"= "{}";
          "max-length"= 25;
          "separate-outputs"= true;
          "offscreen-css"= true;
          "offscreen-css-text"= "(inactive)";
          "rewrite"= {
              "(.*) — Mozilla Firefox"= " $1";
              "(.*) - fish"= "> [$1]";
              "(.*) - zsh"= "> [$1]";
              "(.*) - $term"= "> [$1]";
          };
      };
      "idle_inhibitor"= {
          "tooltip"= true;
          "tooltip-format-activated"= "Idle_inhibitor active";
          "tooltip-format-deactivated"= "Idle_inhibitor not active";
          "format"= "{icon}";
          "format-icons"= {
              "activated"= " ";
              "deactivated"= " ";
          };
      };
      "memory"= {
          "interval"= 10;
          "format"= "{used:0.1f}G 󰾆";
          "format-alt"= "{percentage}% 󰾆";
          "format-alt-click"= "click";
          "tooltip"= true;
          "tooltip-format"= "{used:0.1f}GB/{total:0.1f}G";
      };
      "mpris"= {
          "interval"= 10;
          "format"= "{player_icon} ";
          "format-paused"= "{status_icon} <i>{dynamic}</i>";
          "on-click-middle"= "playerctl play-pause";
          "on-click"= "playerctl previous";
          "on-click-right"= "playerctl next";
          "scroll-step"= 5.0;
          "on-scroll-up"= "$HOME/.config/hypr/scripts/Volume.sh --inc";
          "on-scroll-down"= "$HOME/.config/hypr/scripts/Volume.sh --dec";
          "smooth-scrolling-threshold"= 1;
          "tooltip"= true;
          "tooltip-format"= "{status_icon} {dynamic}\nLeft Click: previous\nMid Click: Pause\nRight Click: Next";
          "player-icons"= {
              "chromium"= "";
              "default"= "";
              "firefox"= "";
              "kdeconnect"= "";
              "mopidy"= "";
              "mpv"= "󰐹";
              "spotify"= "";
              "vlc"= "󰕼";
          };
          "status-icons"= {
              "paused"= "󰐎";
              "playing"= "";
              "stopped"= "";
          };
          # "ignored-players"= ["firefox"];
          "max-length"= 30;
      };
      "network"= {
          "format"= "{ifname}";
          "format-wifi"= "{icon}";
          "format-ethernet"= "󰌘";
          "format-disconnected"= "󰌙";
          "tooltip-format"= "{ipaddr}  {bandwidthUpBits}  {bandwidthDownBits}";
          "format-linked"= "󰈁 {ifname} (No IP)";
          "tooltip-format-wifi"= "{essid} {icon} {signalStrength}%";
          "tooltip-format-ethernet"= "{ifname} 󰌘";
          "tooltip-format-disconnected"= "󰌙 Disconnected";
          "max-length"= 30;
          "format-icons"= [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
          ];
          "on-click-right"= "$HOME/.config/hypr/scripts/WaybarScripts.sh --nmtui";
      };
      "network#speed"= {
          "interval"= 1;
          "format"= "{ifname}";
          "format-wifi"= "{icon}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          "format-ethernet"= "󰌘  {bandwidthUpBytes}  {bandwidthDownBytes}";
          "format-disconnected"= "󰌙";
          "tooltip-format"= "{ipaddr}";
          "format-linked"= "󰈁 {ifname} (No IP)";
          "tooltip-format-wifi"= "{essid} {icon} {signalStrength}%";
          "tooltip-format-ethernet"= "{ifname} 󰌘";
          "tooltip-format-disconnected"= "󰌙 Disconnected";
          "min-length"= 24;
          "max-length"= 24;
          "format-icons"= [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
          ];
      };
      "power-profiles-daemon"= {
          "format"= "{icon} ";
          "tooltip-format"= "Power profile: {profile}\nDriver: {driver}";
          "tooltip"= true;
          "format-icons"= {
              "default"= "";
              "performance"= "";
              "balanced"= "";
              "power-saver"= "";
          };
      };
      "pulseaudio"= {
          "format"= "{icon} {volume}%";
          "format-bluetooth"= "{icon} 󰂰 {volume}%";
          "format-muted"= "󰖁";
          "format-icons"= {
              "headphone"= "";
              "hands-free"= "";
              "headset"= "";
              "phone"= "";
              "portable"= "";
              "car"= "";
              "default"= [
                  ""
                  ""
                  "󰕾"
                  ""
              ];
              "ignored-sinks"= [
                  "Easy Effects Sink"
              ];
          };
          "scroll-step"= 5.0;
          "on-click"= "$HOME/.config/hypr/scripts/Volume.sh --toggle";
          "on-click-right"= "pavucontrol -t 3";
          "on-scroll-up"= "$HOME/.config/hypr/scripts/Volume.sh --inc";
          "on-scroll-down"= "$HOME/.config/hypr/scripts/Volume.sh --dec";
          "tooltip-format"= "{icon} {desc} | {volume}%";
          "smooth-scrolling-threshold"= 1;
      };
      "pulseaudio#1"= {
          "format"= "{icon} {volume}%";
          "format-bluetooth"= "{icon} {volume}%";
          "format-bluetooth-muted"= " {icon}";
          "format-muted"= "󰸈";
          "format-icons"= {
              "headphone"= "";
              "hands-free"= "";
              "headset"= "";
              "phone"= "";
              "portable"= "";
              "car"= "";
              "default"= [
                  ""
                  ""
                  ""
              ];
          };
          "on-click"= "pamixer --toggle-mute";
          "on-click-right"= "pavucontrol -t 3";
          "tooltip"= true;
          "tooltip-format"= "{icon} {desc} | {volume}%";
      };
      "pulseaudio#microphone"= {
          "format"= "{format_source}";
          "format-source"= " {volume}%";
          "format-source-muted"= "";
          "on-click"= "$HOME/.config/hypr/scripts/Volume.sh --toggle-mic";
          "on-click-right"= "pavucontrol -t 4";
          "on-scroll-up"= "$HOME/.config/hypr/scripts/Volume.sh --mic-inc";
          "on-scroll-down"= "$HOME/.config/hypr/scripts/Volume.sh --mic-dec";
          "tooltip-format"= "{source_desc} | {source_volume}%";
          "scroll-step"= 5;
      };
      "tray"= {
          "icon-size"= 20;
          "spacing"= 4;
      };
      "wireplumber"= {
          "format"= "{icon} {volume} %";
          "format-muted"= " Mute";
          "on-click"= "$HOME/.config/hypr/scripts/Volume.sh --toggle";
          "on-click-right"= "pavucontrol -t 3";
          "on-scroll-up"= "$HOME/.config/hypr/scripts/Volume.sh --inc";
          "on-scroll-down"= "$HOME/.config/hypr/scripts/Volume.sh --dec";
          "format-icons"= [
              ""
              ""
              "󰕾"
              ""
          ];
      };
      "wlr/taskbar"= {
          "format"= "{icon} {name}";
          "icon-size"= 16;
          "all-outputs"= false;
          "tooltip-format"= "{title}";
          "on-click"= "activate";
          "on-click-middle"= "close";
          "ignore-list"= [
              "wofi"
              "rofi"
              "kitty"
              "kitty-dropterm"
          ];
      };

      "custom/wlogout" = {
        format = "⏻";
        tooltip = false;
        on-click = "wlogout";
      };

      "custom/weather" = {
          "format" = "{}";
          "format-alt"  = "{alt}: {}";
          "format-alt-click" = "click";
          "interval" = 600;
          "return-type" = "json";
          #"exec" = "$HOME/.config/hypr/UserScripts/Weather.py";
          "exec" = "$HOME/.config/hypr/UserScripts/Weather.sh";
          #"exec-if" = "ping wttr.in -c1";
          "tooltip" = true;
      };
      "custom/hyprpicker" = {
          "format" = "";
          "on-click" = "hyprpicker | wl-copy";
          "tooltip" = true;
          "tooltip-format" = "Hyprpicker";
      };
      "custom/hint" = {
          "format" = "󰺁 HINT!";
          "on-click" = "$HOME/.config/hypr/scripts/KeyBinds.sh";
          "tooltip" = true;
          "tooltip-format" = "Left Click: Keybinds";
      };
      # This is a custom cava visualizer
      "custom/cava_mviz" = {
          "exec" = "$HOME/.config/hypr/scripts/WaybarCava.sh";
          "format" = "{}";
      };

      "custom/playerctl" = {
        "format" = "<span>{}</span>";
        "return-type" = "json";
        "max-length" = 25;
        "exec" = "playerctl -a metadata --format '{\"text\": \"{{artist}}  {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
        "on-click-middle" = "playerctl play-pause";
        "on-click" = "playerctl previous";
        "on-click-right" = "playerctl next";
        "scroll-step" = 5.0;
        "on-scroll-up" = "$HOME/.config/hypr/scripts/Volume.sh --inc";
        "on-scroll-down" = "$HOME/.config/hypr/scripts/Volume.sh --dec";
        "smooth-scrolling-threshold" = 1;
      };
      "custom/swaync" = {
          "tooltip"= true;
          "tooltip-format" = "Left Click: Launch Notification Center\nRight Click: Do not Disturb";
          "format" = "{} {icon} ";
          "format-icons" = {
              "notification" = "<span foreground='red'><sup></sup></span>";
              "none" = "";
              "dnd-notification" = "<span foreground='red'><sup></sup></span>";
              "dnd-none" = "";
              "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
              "inhibited-none" = "";
              "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
              "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "sleep 0.1 && swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
      };

      "custom/separator#dot-line" = {
        "format" = "";
        "interval" = "once";
        "tooltip" = false;
      };
      "custom/separator#line" = {
          "format" = "|";
          "interval" = "once";
          "tooltip" = false;
      };
      "custom/separator#blank" = {
          "format" = "";
          "interval" = "once";
          "tooltip" = false;
      };
      "custom/separator#blank_2" = {
          "format" = "  ";
          "interval" = "once";
          "tooltip" = false;
      };

      "group/audio" = {
        "orientation" = "inherit";
        "drawer"= {
            "transition-duration"= 500;
            "children-class"= "pulseaudio";
            "transition-left-to-right"= true;
        };
        "modules"= [
            "pulseaudio"
            "pulseaudio#microphone"
        ];
      };

      "group/mobo_drawer"= {
        "orientation"= "inherit";
        "drawer"= {
            "transition-duration"= 500;
            "children-class"= "cpu";
            "transition-left-to-right"= true;
        };
        "modules"= [
            "temperature"
            "cpu"
            "power-profiles-daemon"
            "memory"
            "disk"
        ];
      };

      "hyprland/workspaces#rw"= {
        "disable-scroll"= true;
        "all-outputs"= true;
        "warp-on-scroll"= false;
        "sort-by-number"= true;
        "show-special"= false;
        "on-click"= "activate";
        "on-scroll-up"= "hyprctl dispatch workspace e+1";
        "on-scroll-down"= "hyprctl dispatch workspace e-1";
        "persistent-workspaces"= {
            "*"= 5;
        };
        "format"= "{icon} {windows}";
        "format-window-separator"= " ";
        "window-rewrite-default"= " ";
        "window-rewrite"= {
            "title<.*amazon.*>"= " ";
            "title<.*reddit.*>"= " ";
            "class<firefox|org.mozilla.firefox|librewolf|floorp|mercury-browser|[Cc]achy-browser>"= " ";
            "class<zen>"= "󰰷 ";
            "class<waterfox|waterfox-bin>"= " ";
            "class<microsoft-edge>"= " ";
            "class<Chromium|Thorium|[Cc]hrome>"= " ";
            "class<brave-browser>"= "🦁 ";
            "class<tor browser>"= " ";
            "class<firefox-developer-edition>"= "🦊 ";
            "class<kitty|konsole>"= " ";
            "class<kitty-dropterm>"= " ";
            "class<com.mitchellh.ghostty>"= " ";
            "class<org.wezfurlong.wezterm>"= " ";
            "class<[Tt]hunderbird|[Tt]hunderbird-esr>"= " ";
            "class<eu.betterbird.Betterbird>"= " ";
            "title<.*gmail.*>"= "󰊫 ";
            "class<[Tt]elegram-desktop|org.telegram.desktop|io.github.tdesktop_x64.TDesktop>"= " ";
            "class<discord|[Ww]ebcord|Vesktop>"= " ";
            "title<.*whatsapp.*>"= " ";
            "title<.*zapzap.*>"= " ";
            "title<.*messenger.*>"= " ";
            "title<.*facebook.*>"= " ";
            "title<.*reddit.*>"= " ";
            "title<.*ChatGPT.*>"= "󰚩 ";
            "title<.*deepseek.*>"= "󰚩 ";
            "title<.*qwen.*>"= "󰚩 ";
            "class<subl>"= "󰅳 ";
            "class<slack>"= " ";
            "class<mpv>"= " ";
            "class<celluloid|Zoom>"= " ";
            "class<Cider>"= "󰎆 ";
            "title<.*Picture-in-Picture.*>"= " ";
            "title<.*youtube.*>"= " ";
            "class<vlc>"= "󰕼 ";
            "title<.*cmus.*>"= " ";
            "class<[Ss]potify>"= " ";
            "class<Plex>"= "󰚺 ";
            "class<virt-manager>"= " ";
            "class<.virt-manager-wrapped>"= " ";
            "class<virtualbox manager>"= "💽 ";
            "title<virtualbox>"= "💽 ";
            "class<remmina>"= "🖥️ ";
            "class<VSCode|code-url-handler|code-oss|codium|codium-url-handler|VSCodium>"= "󰨞 ";
            "class<dev.zed.Zed>"= "󰵁";
            "class<codeblocks>"= "󰅩 ";
            "title<.*github.*>"= " ";
            "class<mousepad>"= " ";
            "class<libreoffice-writer>"= " ";
            "class<libreoffice-startcenter>"= "󰏆 ";
            "class<libreoffice-calc>"= " ";
            "title<.*nvim ~.*>"= " ";
            "title<.*vim.*>"= " ";
            "title<.*nvim.*>"= " ";
            "title<.*figma.*>"= " ";
            "title<.*jira.*>"= " ";
            "class<jetbrains-idea>"= " ";
            "class<obs|com.obsproject.Studio>"= " ";
            "class<polkit-gnome-authentication-agent-1>"= "󰒃 ";
            "class<nwg-look>"= " ";
            "class<[Pp]avucontrol|org.pulseaudio.pavucontrol>"= "󱡫 ";
            "class<steam>"= " ";
            "class<thunar|nemo>"= "󰝰 ";
            "class<Gparted>"= "";
            "class<gimp>"= " ";
            "class<emulator>"= "📱 ";
            "class<android-studio>"= " ";
            "class<org.pipewire.Helvum>"= "󰓃";
            "class<localsend>"= "";
            "class<PrusaSlicer|UltiMaker-Cura|OrcaSlicer>"= "󰹛";
        };
      };
    }];

    # CSS（Arch時代のものを適用）
    style = ''
      * {
          font-family: "${config.stylix.fonts.monospace.name}, monospace;
          font-weight: bold;
          min-height: 0;
          font-size: 97%;
          font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      }

      window#waybar {
          background-color: transparent;
          border-radius: 6px;
          padding-top: 2px;
          padding-bottom: 0px;
          padding-right: 4px;
          padding-left: 4px;
      }

      tooltip {
          background: #${config.lib.stylix.colors.base01};
          border-radius: 12px;
          border-width: 1px;
          border-style: solid;
          border-color: #${config.lib.stylix.colors.base03};
          color: #${config.lib.stylix.colors.base07};
      }

      #taskbar button,
      #workspaces button {
        padding: 0px 3px;
        margin: 3px 2px;
        border-radius: 4px;
        color: #${config.lib.stylix.colors.base05};
        background-color: #${config.lib.stylix.colors.base01};
        transition: all 0.1s linear;
        opacity: 0.4;
      }

      #taskbar button.active,
      #workspaces button.active {
        color: #${config.lib.stylix.colors.base05};
        background: #${config.lib.stylix.colors.base02};
        border-radius: 4px;
        min-width: 30px;
        animation: gradient_f 20s ease-in infinite;
        transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        opacity: 1.0;
      }

      #taskbar button:hover,
      #workspaces button:hover {
        color: #${config.lib.stylix.colors.base08};
        background: #${config.lib.stylix.colors.base02};
        border-radius: 3px;
        opacity: 0.6;
        animation: gradient_f 20s ease-in infinite;
        transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button.focused {
        color: #${config.lib.stylix.colors.base06};
      }

      #workspaces button.urgent {
        color: #${config.lib.stylix.colors.base00};
        border-radius: 10px;
        background: #${config.lib.stylix.colors.base08};
      }

      /*-----module groups----*/
      .modules-left,
      .modules-right {
          background-color: transparent;
      }

      .modules-center {
          background-color: #${config.lib.stylix.colors.base00};
          border-radius: 0px 0px 45px 45px;
          padding-top: 8px;
          padding-bottom: 8px;
          padding-left: 10px;
          padding-right: 6px;
      }

      #custom-cava_mviz,
      #custom-playerctl,
      #window,
      #hyprland-window,
      #custom-swaync,
      #workspaces,
      #hyprland-workspaces,
      #clock,
      #custom-weather,
      #custom-weather.default,
      #idle_inhibitor,
      #custom-hint,
      #tray,
      #network.speed,
      #network,
      #group-audio,
      #group-mobo_drawer,
      #custom-wlogout {
          color: #${config.lib.stylix.colors.base06};
          padding-right: 6px;
          padding-left: 6px;
      }

      #clock {
          color: #${config.lib.stylix.colors.base0D}; /* sapphire */
          border-radius: 15px;
      }

      #custom-weather,
      #custom-weather.default {
          color: #${config.lib.stylix.colors.base0C}; /* lavender */
      }

      #idle_inhibitor {
          color: #${config.lib.stylix.colors.base0B}; /* teal */
      }

      #custom-hint {
          color: #${config.lib.stylix.colors.base09}; /* peach/orange */
      }

      #custom-swaync {
          color: #${config.lib.stylix.colors.base0A}; /* yellow/gold */
      }
    '';
  };
}
