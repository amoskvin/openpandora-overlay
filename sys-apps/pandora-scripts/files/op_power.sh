#!/bin/sh

# A simplified version that uses pm-utils
# Only does real suspend

[ -z "$2" ] && exec pm-suspend

case "$2" in
	lid | screensaver) exec /usr/pandora/scripts/op_lid.sh "$1" ;;
	*) echo "Not implemented" ;;
esac
