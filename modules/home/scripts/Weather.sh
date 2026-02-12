#!/usr/bin/env bash
set -euo pipefail

# --- 設定 ---
city="${city}"
latitude="${latitude}"
longitude="${longitude}"
api_key="${OWM_KEY}"
cachedir="$HOME/.cache/rbn"
cache_path="$cachedir/weather_cache.json"
mkdir -p "$cachedir"

# 1. キャッシュチェック（30分）
if [[ -f "$cache_path" ]]; then
    last_mod=$(stat -c '%Y' "$cache_path")
    if (( $(date +%s) - last_mod < 1800 )); then
        cat "$cache_path"
        exit 0
    fi
fi

# 2. OpenWeatherMap からデータ取得
owm_url="https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${api_key}&units=metric&lang=ja"

if response=$(curl -sSf --connect-timeout 5 "$owm_url"); then
    # 各種データの抽出
    temp=$(echo "$response" | jq -r '.main.temp | round')
    feels_like=$(echo "$response" | jq -r '.main.feels_like | round')
    temp_min=$(echo "$response" | jq -r '.main.temp_min | round')
    temp_max=$(echo "$response" | jq -r '.main.temp_max | round')
    humidity=$(echo "$response" | jq -r '.main.humidity')
    wind_speed=$(echo "$response" | jq -r '.wind.speed')
    description=$(echo "$response" | jq -r '.weather[0].description')
    icon_code=$(echo "$response" | jq -r '.weather[0].icon')
    
    # 日の出・日の入（UNIX時間を時刻形式に変換）
    sunrise_unix=$(echo "$response" | jq -r '.sys.sunrise')
    sunset_unix=$(echo "$response" | jq -r '.sys.sunset')
    sunrise=$(date -d "@$sunrise_unix" +%H:%M)
    sunset=$(date -d "@$sunset_unix" +%H:%M)

    # 3. Icon ID によるマッピング
    case "$icon_code" in
        01d) icon=""; class="sunny" ;;
        01n) icon=""; class="clear-night" ;;
        02d) icon=""; class="cloudy" ;;
        02n) icon=""; class="cloudy" ;;
        03*) icon=""; class="cloudy" ;;
        04*) icon=""; class="cloudy" ;;
        09*) icon=""; class="rain" ;;
        10d) icon=""; class="rain" ;;
        10n) icon=""; class="rain" ;;
        11*) icon=""; class="thunder" ;;
        13*) icon="󰙿"; class="snow" ;;
        50*) icon=""; class="mist" ;;
        *)   icon=""; class="unknown" ;;
    esac

    # 4. ツールチップ用テキスト（日の出・日の入を追加）
    tooltip_text=$(printf "地点: %s\n天気: %s\n気温: %d°C (体感: %d°C)\n最高: %d°C / 最低: %d°C\n湿度: %d%%\n風速: %.1fm/s\n\n🌅 日の出: %s\n🌇 日の入り: %s" \
                   "$city" "$description" "$temp" "$feels_like" "$temp_max" "$temp_min" "$humidity" "$wind_speed" "$sunrise" "$sunset")

    # 5. JSON の生成
    output=$(jq -n \
        --arg text "$icon $temp°C" \
        --arg alt "$city" \
        --arg tooltip "$tooltip_text" \
        --arg class "$class" \
        '{"text": $text, "alt": $alt, "tooltip": $tooltip, "class": $class}')

    echo "$output" > "$cache_path"
    echo "$output"
else
    if [[ -f "$cache_path" ]]; then
        cat "$cache_path"
    else
        echo '{"text":"󰤭 ", "tooltip":"取得失敗"}'
    fi
fi