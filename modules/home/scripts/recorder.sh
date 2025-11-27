#!/usr/bin/env bash

# ==============================
#  NVIDIA NVENC Recorder for Hyprland
# ==============================

OUTDIR="$HOME/Videos/Recordings"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
FILE="$OUTDIR/record_$TIMESTAMP.mp4"

ICON="$HOME/.config/swaync/icons/video.png"

mkdir -p "$OUTDIR"

# 🔊 音声録音の設定（PipeWire）
# デスクトップ音声
AUDIO_DESK="alsa_output.pci-0000_00_1f.3.analog-stereo"  # ←必要なら自動取得に変更可
# マイク
AUDIO_MIC="alsa_input.pci-0000_00_1f.3.analog-stereo"

# 必須コマンド
command -v wf-recorder >/dev/null || { echo "wf-recorder is missing"; exit 1; }

notify() {
    notify-send -i "$ICON" "$1" "$2"
}

# 🔥 Start Recording
start_record() {
    notify "Recording started" "$FILE"

    wf-recorder \
        -f "$FILE" \
        -c h264_nvenc \
        --audio="$AUDIO_DESK" \
        --audio="$AUDIO_MIC" \
        &
    
    echo $! > /tmp/wf_recorder.pid
}

# ⏹ Stop Recording
stop_record() {
    if [[ -f /tmp/wf_recorder.pid ]]; then
        kill "$(cat /tmp/wf_recorder.pid)"
        rm /tmp/wf_recorder.pid
        notify "Recording stopped" "$FILE"
    else
        notify "Recorder not running" ""
    fi
}

case "$1" in
    start) start_record ;;
    stop)  stop_record ;;
    *)
        echo "Usage: $0 start | stop"
        exit 1
        ;;
esac

exit 0
