#!/bin/bash

speed=5

delay=4 #$speed
while [ -d /proc/$1 ]
do
    ((--delay))
    if [ $delay -le 0 ] ; then
        kill -USR1 $1
        delay=$speed
    fi
    sleep 0.05
done
