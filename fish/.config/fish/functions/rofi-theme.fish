#!/usr/bin/fish

sleep 0.05

set -l window_id (xdotool getactivewindow 2>/dev/null)
set -l app_name ""

if test -n "$window_id"
    set -l xprop_output (xprop -id $window_id WM_CLASS 2>/dev/null)
    set app_name (echo $xprop_output | string match -r '"([^"]+)"$' | tail -n 1 | string lower)
end

if test -z "$app_name"
    set app_name "desktop"
end

set -l dark_theme "$HOME/.config/rofi/themes/dark-theme.rasi"
set -l light_theme "$HOME/.config/rofi/themes/light-theme.rasi"

if string match -r "firefox|chrome|brave|code|spotify|zed|zed-editor|dev.zed.zed|alacritty" "$app_name" >/dev/null
    set theme_selected $dark_theme
else
    set theme_selected $light_theme
end


rofi -show drun -theme $theme_selected
