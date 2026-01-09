#!/usr/bin/env bash

OUTDIR="$HOME/Videos/Recordings"
mkdir -p "$OUTDIR"

PID_FILE="/tmp/wf_recorder.pid"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
FILE="$OUTDIR/record_$TIMESTAMP.mp4"

# PipeWire からデフォルトのデバイス名を取得
AUDIO_DESK=$(pactl get-default-sink).monitor
AUDIO_MIC=$(pactl get-default-source)

notify() {
    # Papirus アイコンテーマ内の "media-record" を使用
    notify-send -a "Recorder" -i "media-record" "$1" "$2"
}

start_record() {
    if [[ -f "$PID_FILE" ]]; then
        notify "Error" "Recording is already running"
        exit 1
    fi

    notify "Recording started" "File: record_$TIMESTAMP.mp4"

    wf-recorder \
        -f "$FILE" \
        -c h264_nvenc \
        --audio="$AUDIO_DESK" \
        --audio="$AUDIO_MIC" &
    
    echo $! > "$PID_FILE"
}

stop_record() {
    if [[ -f "$PID_FILE" ]]; then
        local pid
        pid=$(cat "$PID_FILE")
        
        kill -SIGINT "$pid"
        while kill -0 "$pid" 2>/dev/null; do sleep 0.5; done
        
        rm "$PID_FILE"
        notify "Recording saved" "$FILE"
    else
        notify "Error" "No recording in progress"
    fi
}

case "${1:-}" in
    start) start_record ;;
    stop)  stop_record ;;
    *) echo "Usage: $0 {start|stop}"; exit 1 ;;
esac