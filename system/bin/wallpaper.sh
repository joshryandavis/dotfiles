#!/bin/zsh

TIME=300 # seconds
WALLPAPER_DIRECTORY=$1
PID_FILE="/tmp/wallpaper_changer.pid"
LOCK_FILE="/tmp/wallpaper_changer.lock"

echo -e $1

trap 'rm -f "$LOCK_FILE"; exit' EXIT

if [ -f "$LOCK_FILE" ] || [ -f "$PID_FILE" ]; then
    if ps -p $(cat "$PID_FILE") > /dev/null; then
        echo "Killing existing script instance..."
        kill -9 $(cat "$PID_FILE")
        rm "$PID_FILE"
        rm "$LOCK_FILE"
    fi
fi

touch "$LOCK_FILE"

echo $$ > "$PID_FILE"

trap "rm $PID_FILE; exit" SIGHUP SIGINT SIGTERM

command() {
    echo $($1)
}

command "rm -rf  $HOME/.cache/swww/"

if [[ -z $(pgrep swww-daemon) ]]; then
    command "swww init"
fi

command "pkill swaybg"

wallpaperDir=$(readlink -f $WALLPAPER_DIRECTORY)
declare -a wallpaperMemory

readarray -t monitors < <(wlr-randr | grep "\"" | awk -F' "' '{print $1}')

set_wallpaper() {
    readarray -t wallpapers < <(find "$wallpaperDir" -type f)

    for entry in "${wallpaperMemory[@]}"; do
        wallpapers=("${wallpapers[@]/$entry}")
    done

    declare -a selectedWallpapers

    for output in "${monitors[@]}"; do
        idx=$((RANDOM % ${#wallpapers[@]}))
        wp="${wallpapers[$idx]}"
        wallpapers=("${wallpapers[@]:0:$idx}" "${wallpapers[@]:$((idx + 1))}")       
        echo "Setting wallpaper $wp on $output"
        command "swww img $wp"
        selectedWallpapers+=("$wp")
    done

    wallpaperMemory=("${selectedWallpapers[@]}")
}

set_wallpaper
while true; do
    sleep $TIME
    set_wallpaper
done
