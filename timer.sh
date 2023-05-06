#!/bin/bash

speed=1

delay=$speed
while kill -0 $1 2> /dev/null
do
    ((--delay))
    if [ $delay -le 0 ] ; then
        kill -USR1 $1
        delay=$speed
    fi
    sleep 1
done
