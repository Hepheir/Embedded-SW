#!/bin/bash

echo "김동주, 이 곳에 잠들다..."

while true ; do
    git fetch origin/master
    reslog=$(git log HEAD..origin/master --oneline)
    if [ "${reslog}" != "" ] ; then
        killall python

        echo "Updating..."
        git pull

        echo "Launching Program!"
        python python/index.py &

    else
        echo "No changes"
        sleep 20
    fi
done