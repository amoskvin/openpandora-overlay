#!/bin/sh

. /usr/pandora/scripts/op_common.sh

if [ $1 = 1 ]; then
	echo 1 > /sys/class/graphics/fb0/blank
else
	echo 0 > /sys/class/graphics/fb0/blank

	# To be safe
	brightness="$(cat $SYSFS_BACKLIGHT_BRIGHTNESS)"
	if [ $brightness = 0 ]; then
		cat "${SYSFS_BACKLIGHT}/max_brightness" > "${SYSFS_BACKLIGHT_BRIGHTNESS}"
	fi
fi
