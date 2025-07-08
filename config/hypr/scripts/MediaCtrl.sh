#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Playerctl media controls with reliable play/pause notifications

music_icon="$HOME/.config/swaync/icons/music.png"

# Show notification with current song info or paused state
show_music_notification() {
    status=$(playerctl status)
    if [[ "$status" == "Playing" ]]; then
        song_title=$(playerctl metadata title)
        song_artist=$(playerctl metadata artist)
        notify-send -e -u low -i "$music_icon" "Now Playing:" "$song_title by $song_artist"
    elif [[ "$status" == "Paused" ]]; then
        notify-send -e -u low -i "$music_icon" "Playback:" "Paused"
    else
        notify-send -e -u low -i "$music_icon" "Playback:" "Stopped"
    fi
}

# Play the next track
play_next() {
    playerctl next
    show_music_notification
}

# Play the previous track
play_previous() {
    playerctl previous
    show_music_notification
}

# Toggle play/pause by inverting the *old* status for a race‑free notification
toggle_play_pause() {
    old_status=$(playerctl status)
    playerctl play-pause

    if [[ "$old_status" == "Playing" ]]; then
        # we just paused
        notify-send -e -u low -i "$music_icon" "Playback:" "Paused"
    else
        # we just played (or were already stopped)
        song_title=$(playerctl metadata title)
        song_artist=$(playerctl metadata artist)
        notify-send -e -u low -i "$music_icon" "Now Playing:" "$song_title by $song_artist"
    fi
}

# Stop playback completely
stop_playback() {
    playerctl stop
    notify-send -e -u low -i "$music_icon" "Playback:" "Stopped"
}

# Dispatch based on the first argument
case "$1" in
    "--nxt")
        play_next
        ;;
    "--prv")
        play_previous
        ;;
    "--pause")
        toggle_play_pause
        ;;
    "--stop")
        stop_playback
        ;;
    *)
        echo "Usage: $0 [--nxt|--prv|--pause|--stop]"
        exit 1
        ;;
esac
