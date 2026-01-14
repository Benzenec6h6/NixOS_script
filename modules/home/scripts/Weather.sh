#!/usr/bin/env bash
set -euo pipefail

# --- 設定 ---
city="Kakogawa"
latitude="34.765"
longitude="134.829"
api_key="${OWM_KEY:-}" # <--- home managerから渡すhome managerはgitignoreが必用か？
cachedir="$HOME/.cache/rbn"
cache_path="$cachedir/weather_cache.json"
mkdir -p "$cachedir"

# 1. キャッシュの有効期限チェック（30分）
if [[ -f "$cache_path" ]]; then
    last_mod=$(stat -c '%Y' "$cache_path")
    if (( $(date +%s) - last_mod < 1800 )); then
        cat "$cache_path"
        exit 0
    fi
fi

# 2. データ取得の試行
data=""
cond_text=""
temp=""

# --- Source 1: OpenWeatherMap (New) ---
echo "Trying source: OpenWeatherMap" >&2
# units=metric で摂氏度を取得
owm_url="https://api.openweathermap.org/data/2.5/weather?lat=${latitude}&lon=${longitude}&appid=${api_key}&units=metric"

if owm_json=$(curl -sSf --connect-timeout 4 "$owm_url"); then
    # jq を使って天気名と気温を抽出
    cond_text=$(echo "$owm_json" | jq -r '.weather[0].description')
    temp_val=$(echo "$owm_json" | jq -r '.main.temp')
    if [[ "$cond_text" == "null" || "$temp_val" == "null" ]]; then
        cond_text=""
    else
        temp="${temp_val%.*}°C"
        echo "Successfully fetched data from OpenWeatherMap" >&2
    fi
fi

# --- Source 2 & 3: wttr.in (Fallback) ---
if [[ -z "$cond_text" ]]; then
    SOURCES=(
        "https://wttr.in/${latitude},${longitude}?format=%C\n%t"
        "https://v2.wttr.in/${latitude},${longitude}?format=%C\n%t"
    )

    for source in "${SOURCES[@]}"; do
        echo "Trying source: $source" >&2
        if raw_data=$(curl -sSf --connect-timeout 4 "$source"); then
            if [[ -n "$raw_data" && "$raw_data" != *"Unknown location"* ]]; then
                mapfile -t info <<< "$raw_data"
                cond_text="${info[0]:-}"
                temp="${info[1]:-}"
                echo "Successfully fetched data from $source" >&2
                break
            fi
        fi
    done
fi

# 3. 取得できた場合のアイコン変換処理
if [[ -n "$cond_text" ]]; then
    # OWMとwttr.inの両方のキーワードに対応できるよう小文字化
    case "${cond_text,,}" in
    "clear" | "sunny")
        condition=""
        ;;
    "clouds" | "partly cloudy" | "scattered clouds" | "broken clouds")
        condition="󰖕"
        ;;
    "cloudy" | "overcast clouds")
        condition=""
        ;;
    "overcast")
        condition=""
        ;;
    "fog" | "mist" | "haze" | "freezing fog")
        condition=""
        ;;
    "patchy rain possible" | "patchy light drizzle" | "light drizzle" | "patchy light rain" | "light rain" | "light rain shower" | "rain" | "drizzle")
        condition="󰼳"
        ;;
    "moderate rain at times" | "moderate rain" | "heavy rain at times" | "heavy rain" | "moderate or heavy rain shower" | "torrential rain shower" | "rain shower")
        condition=""
        ;;
    "snow")
        condition="󰙿"
        ;;
    "thunderstorm")
        condition=""
        ;;
    *)
        condition="" # 判定不能な場合
        ;;
    esac

    output_json=$(printf '{"text":"%s %s %s", "tooltip":"%s: %s %s"}\n' \
        "$city" "$temp" "$condition" "$city" "$temp" "$cond_text")
    
    echo "$output_json" > "$cache_path"
    echo "$output_json"
    exit 0
fi

# 4. 全てのソースが失敗した場合
if [[ -f "$cache_path" ]]; then
    cat "$cache_path"
    # notify-send -u low "Weather" "All sources failed. Showing cached data."
else
    echo '{"text":"N/A", "tooltip":"Check internet connection"}'
fi