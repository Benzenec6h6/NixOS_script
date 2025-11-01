{ pkgs }:

pkgs.writeShellScriptBin "weather" ''
  #!${pkgs.bash}/bin/bash
  # weather — wttr.in weather info with caching for Waybar
  # Dependencies: curl, jq, coreutils (stat), fontawesome glyphs
  set -euo pipefail

  CURL=${pkgs.curl}/bin/curl
  JQ=${pkgs.jq}/bin/jq
  STAT=${pkgs.coreutils}/bin/stat
  DATE=${pkgs.coreutils}/bin/date
  MKDIR=${pkgs.coreutils}/bin/mkdir
  CAT=${pkgs.coreutils}/bin/cat
  TR=${pkgs.coreutils}/bin/tr
  SED=${pkgs.gnused}/bin/sed

  # Detect city by IP
  city=$($CURL -s https://ipinfo.io | $JQ -r '.city')
  cachedir="$HOME/.cache/rbn"
  cachefile="${cachedir}/weather-cache-$1"

  $MKDIR -p "$cachedir"
  touch "$cachefile"

  SAVEIFS=$IFS
  IFS=$'\n'

  cacheage=$(($($DATE +%s) - $($STAT -c '%Y' "$cachefile")))
  if [ "$cacheage" -gt 1740 ] || [ ! -s "$cachefile" ]; then
    data=($($CURL -s "https://en.wttr.in/${city}$1?0qnT" 2>/dev/null))
    echo "${data[0]}" | cut -f1 -d, > "$cachefile"
    echo "${data[1]}" | $SED -E 's/^.{15}//' >> "$cachefile"
    echo "${data[2]}" | $SED -E 's/^.{15}//' >> "$cachefile"
  fi

  weather=($($CAT "$cachefile"))
  IFS=$SAVEIFS

  temperature=$(echo "${weather[2]}" | $SED -E 's/([[:digit:]]+)\.\./\1 to /g')
  condition_raw=$(echo "${weather[1]##*,}" | $TR '[:upper:]' '[:lower:]')

  case "$condition_raw" in
    "clear" | "sunny") icon="" ;;
    "partly cloudy") icon="󰖕" ;;
    "cloudy") icon="" ;;
    "overcast") icon="" ;;
    "fog" | "freezing fog") icon="" ;;
    "patchy rain possible" | "light rain" | "light rain shower" | "rain") icon="󰼳" ;;
    "moderate rain" | "heavy rain" | "rain shower") icon="" ;;
    "light snow" | "sleet" | "ice pellets") icon="󰼴" ;;
    "moderate snow" | "heavy snow") icon="" ;;
    "thundery outbreaks possible" | *"thunder"*) icon="" ;;
    *) icon="" ;;
  esac

  echo -e "{\"text\":\"${temperature} ${icon}\", \"alt\":\"${weather[0]}\", \"tooltip\":\"${weather[0]}: ${temperature} ${weather[1]}\"}"

  printf " %s  \\n%s %s\n" "$temperature" "$icon" "${weather[1]}" > "$HOME/.cache/.weather_cache"
''
