#!/bin/bash

cd /srv/info-beamer

REMOTE=$(git ls-remote https://github.com/UlmApi/jugendhackt-infobeamer.git master | cut -f1)
LOCAL=$(git rev-parse origin/master)

if [ "${REMOTE}" != "${LOCAL}" ]; then
	git pull > /dev/null 2>&1
	cat schedule.json | ./fix-schedule.py > node/schedule/_schedule.json
	mv webcamp-2017/schedule/_schedule.json node/schedule/schedule.json
fi

if [ ! -f node/schedule/schedule.json ]; then
	cat schedule.json | ./fix-schedule.py > node/schedule/_schedule.json
	mv webcamp-2017/schedule/_schedule.json node/schedule/schedule.json
fi
