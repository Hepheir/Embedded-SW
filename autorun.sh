#!/bin/bash

echo "김동주, 이 곳에 잠들다..."
cd hepheir/Embedded-SW

while true
do
    git fetch
    HEADHASH=$(git rev-parse HEAD)
    UPSTREAMHASH=$(git rev-parse master@{upstream})
    if [ "$HEADHASH" != "$UPSTREAMHASH" ]
    then
        echo -e ${ERROR}Not up to date with origin. Aborting.${NOCOLOR}
        killall python
        git fetch origin
        echo "Launching Program"
        python python/index.py &
    else
        echo -e ${FINISHED}Current branch is up to date with origin/master.${NOCOLOR}
        sleep 20
    fi
done