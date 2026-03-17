{ ... }:
{
  programs.waybar.settings = [{
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
        "custom/separator#line"
        "battery"
        "custom/separator#dot-line"
        "custom/wlogout"
    ];

    "temperature" = {
        "interval" = 10;
        "tooltip" = true;
        "hwmon-path" = [
            #"/sys/class/hwmon/hwmon1/temp1_input"
            "/run/hwmon-coretemp/temp1_input"
            "/sys/class/thermal/thermal_zone0/temp"
        ];
        #"thermal-zone" = 0;
        "critical-threshold" = 80;
        "warning-threshold" = 60;
        "format-critical" = "{temperatureC}°C {icon}";
        "format-warning" = "{temperatureC}°C {icon}";
        "format" = "{temperatureC}°C";
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
        "on-scroll-up" = "brightness --inc";
        "on-scroll-down" = "brightness --dec";
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
        "on-scroll-up"= "Volume --inc";
        "on-scroll-down"= "Volume --dec";
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
        "on-click-right"= "WaybarScripts --nmtui";
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
        "on-click"= "Volume --toggle";
        "on-click-right"= "pavucontrol -t 3";
        "on-scroll-up"= "Volume --inc";
        "on-scroll-down"= "Volume --dec";
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
        "on-click"= "Volume --toggle-mic";
        "on-click-right"= "pavucontrol -t 4";
        "on-scroll-up"= "Volume --mic-inc";
        "on-scroll-down"= "Volume --mic-dec";
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
        "on-click"= "Volume --toggle";
        "on-click-right"= "pavucontrol -t 3";
        "on-scroll-up"= "Volume --inc";
        "on-scroll-down"= "Volume --dec";
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

    "custom/tlp" = {
        "interval" = 10;
        "exec" = "tlp-stat -p | grep 'Mode' | awk '{print $3}'";
        "format" = "{} ";
        "tooltip" = true;
        "tooltip-format" = "TLP power mode: {}";
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
        "interval" = 1800;
        "return-type" = "json";
        "exec" = "Weather";
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
        "on-click" = "keybind-menu";
        "tooltip" = true;
        "tooltip-format" = "Left Click: Keybinds";
    };
    # This is a custom cava visualizer
    "custom/cava_mviz" = {
        "exec" = "WaybarCava";
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
        "on-scroll-up" = "Volume --inc";
        "on-scroll-down" = "Volume --dec";
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
            #"children-class"= "cpu";
            "transition-left-to-right"= true;
        };
        "modules"= [
            "temperature"
            "cpu"
            "custom/tlp"
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
}
