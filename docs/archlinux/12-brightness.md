# brightness config store file
echo /sys/class/backlight/intel_backlight/brightness

# check percentage of brightness
echo $((20000*255/65535))
