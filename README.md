# Orbic-Scripts

## Overview
The Orbic RC400L likes to lose time but we can get time from the network via /dev/smd* devices.
The devices appear to be a bit unrelaible so this prog checks the ones that are avable and
sends the the AT command CCLK to get the time from the modem chip. 

The script basically just does the following to get the time:

echo -e "AT+CCLK?\r" > /dev/smd8 & cat /dev/smd8
[2] 26050
AT+CCLK?
+CCLK: "25/08/10,22:02:32+32"

OK

## Usage
To use the script, you must run it with root privileges (rootshell). For example:

rootshell ./orbic_set_time_from_modem.sh
```

Or, if you are already in a root shell:

```bash
./orbic_set_time_from_modem.sh
```

## Requirements
- Bash shell
- Root access

