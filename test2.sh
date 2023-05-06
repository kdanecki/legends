#!/bin/bash

declare -A world
for t in `seq 1 10`
do
clear
for y in `seq 0 9`
do
    for x in `seq 0 9`
    do
        world[$y,$x]="."
    done
done
world[$(((t%100) / 10)),$((t%10))]="#"

for y in `seq 0 9`
do
    for x in `seq 0 9`
    do
        echo -n ${world["$y,$x"]}
    done
    echo
done
sleep 0.1
done
