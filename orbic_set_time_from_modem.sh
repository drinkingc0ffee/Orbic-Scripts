#!/bin/sh

get_modem_time() {
    for DEV in /dev/smd7 /dev/smd8 /dev/smd11; do
        {
            cat "$DEV" &
            CAT_PID=$!
            sleep 0.2
            echo -e "AT+CCLK?\r" > "$DEV"
            sleep 1
            kill "$CAT_PID"
        } | grep "+CCLK" && return 0
    done
    return 1
}

CCLK_LINE=$(get_modem_time | grep "+CCLK")

if [ -z "$CCLK_LINE" ]; then
    echo "No modem time found."
    exit 1
fi

# Example: +CCLK: "25/08/05,15:00:40+32"
TIME_STRING=$(echo "$CCLK_LINE" | sed -n 's/.*"\(.*\)".*/\1/p')

YEAR="20$(echo "$TIME_STRING" | cut -d'/' -f1)"
MONTH=$(echo "$TIME_STRING" | cut -d'/' -f2)
DAY=$(echo "$TIME_STRING" | cut -d'/' -f3 | cut -d',' -f1)
HOUR=$(echo "$TIME_STRING" | cut -d',' -f2 | cut -d':' -f1)
MIN=$(echo "$TIME_STRING" | cut -d',' -f2 | cut -d':' -f2)
SEC=$(echo "$TIME_STRING" | cut -d',' -f2 | cut -d':' -f3 | cut -d'+' -f1)

# Format for BusyBox: MMDDhhmmYYYY.ss
BUSYBOX_DATE="${MONTH}${DAY}${HOUR}${MIN}${YEAR}.${SEC}"

echo "Setting system time to: $BUSYBOX_DATE"

date "$BUSYBOX_DATE"

