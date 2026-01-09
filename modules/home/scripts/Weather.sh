#!/usr/bin/env bash
set -euo pipefail

city="Kakogawa"
cachedir="$HOME/.cache/rbn"
cache_path="$cachedir/weather_cache.json"
mkdir -p "$cachedir"

# --- 設定 ---
# 複数のソースを試す
# 1. 通常の wttr.in
# 2. サブドメイン（ミラー）の v2.wttr.in
# 3. (オプション) 他の気象APIなど
SOURCES=(
    "https://wttr.in/$city?format=%l\n%C\n%t"
    "https://v2.wttr.in/$city?format=%l\n%C\n%t"
)

# 1. キャッシュの有効期限チェック（30分）
if [[ -f "$cache_path" ]]; then
    last_mod=$(stat -c '%Y' "$cache_path")
    if (( $(date +%s) - last_mod < 1800 )); then
        cat "$cache_path"
        exit 0
    fi
fi

# 2. 複数のソースからデータ取得を試みる
data=""
for source in "${SOURCES[@]}"; do
    echo "Trying source: $source" >&2
    # -s: 静か, -S: エラー表示, -f: HTTPエラーで失敗させる, --connect-timeout: タイムアウト
    if data=$(curl -sSf --connect-timeout 4 "$source"); then
        if [[ -n "$data" && "$data" != *"Unknown location"* ]]; then
            echo "Successfully fetched data from $source" >&2
            break
        fi
    fi
    data="" # 失敗した場合は空にする
done

# 3. 取得できた場合の処理
if [[ -n "$data" ]]; then
    mapfile -t info <<< "$data"
    loc="${info[0]:-$city}"
    cond_text="${info[1]:-Unknown}"
    temp="${info[2]:-?°C}"

    case "${cond_text,,}" in
    "clear" | "sunny")
        condition=""
        ;;
    "partly cloudy")
        condition="󰖕"
        ;;
    "cloudy")
        condition=""
        ;;
    "overcast")
        condition=""
        ;;
    "fog" | "freezing fog")
        condition=""
        ;;
    "patchy rain possible" | "patchy light drizzle" | "light drizzle" | "patchy light rain" | "light rain" | "light rain shower" | "mist" | "rain")
        condition="󰼳"
        ;;
    "moderate rain at times" | "moderate rain" | "heavy rain at times" | "heavy rain" | "moderate or heavy rain shower" | "torrential rain shower" | "rain shower")
        condition=""
        ;;
    "patchy snow possible" | "patchy sleet possible" | "patchy freezing drizzle possible" | "freezing drizzle" | "heavy freezing drizzle" | "light freezing rain" | "moderate or heavy freezing rain" | "light sleet" | "ice pellets" | "light sleet showers" | "moderate or heavy sleet showers")
        condition="󰼴"
        ;;
    "blowing snow" | "moderate or heavy sleet" | "patchy light snow" | "light snow" | "light snow showers")
        condition="󰙿"
        ;;
    "blizzard" | "patchy moderate snow" | "moderate snow" | "patchy heavy snow" | "heavy snow" | "moderate or heavy snow with thunder" | "moderate or heavy snow showers")
        condition=""
        ;;
    "thundery outbreaks possible" | "patchy light rain with thunder" | "moderate or heavy rain with thunder" | "patchy light snow with thunder")
        condition=""
        ;;
    *)
        condition=""
        ;;
    esac

    output_json=$(printf '{"text":"%s %s %s", "tooltip":"%s: %s %s"}\n' \
        "$city" "$temp" "$condition" "$loc" "$temp" "$cond_text")
    
    echo "$output_json" > "$cache_path"
    echo "$output_json"
    exit 0
fi

# 4. 全てのソースが失敗した場合
if [[ -f "$cache_path" ]]; then
    # 古いキャッシュがあればそれを表示（何もしないよりマシ）
    cat "$cache_path"
    notify-send -u low "Weather" "All sources failed. Showing cached data."
else
    # キャッシュすらない場合
    echo '{"text":"N/A", "tooltip":"Check internet connection"}'
fi