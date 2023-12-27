#!/bin/bash

call_bsod() {
	sudo journalctl --user --flush --rotate --vacuum-time=1s
	sudo systemd-cat -p emerg echo "$(printf %b '\e[H\e[J')$1"
	sudo /usr/lib/systemd/systemd-bsod &
}

sudo echo "Starting in 3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
echo "Initializing sequence."

IFS='=' read -ra frames <<< $(cat frames.txt)
COUNTER=1
for frame in "${frames[@]}"; do
	call_bsod "$frame"
	sleep 1
	COUNTER=$(($COUNTER+1))
	if [[ "$COUNTER" == 10 ]]; then
		sudo pkill systemd-bsod
		COUNTER=1
	fi
done
