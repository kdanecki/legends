#!/bin/bash

set -x

fun () {
    #stty echo
    echo $$
    #. ./skrypt2.sh
}


draw () {
    clear
    for y in `seq 0 $YSIZE`
    do
        for x in `seq 0 $XSIZE`
        do
            echo -n ${world["$y,$x"]}
        done
        echo
    done
    echo "action: $action"
}

tick () {
    if [[ $action == w && ${player[y]} -gt 0 ]] ; then
        world["${player[y]},${player[x]}"]="."
        world["$((${player[y]}-1)),${player[x]}"]="@"
        player[y]=$((player[y]-1))
    fi
    if [[ $action == a && ${player[x]} -gt 0 ]] ; then
        world["${player[y]},${player[x]}"]="."
        world["${player[y]},$((player[x]-1))"]="@"
        player[x]=$((player[x]-1))
    fi
    if [[ $action == s && ${player[y]} -lt $YSIZE ]] ; then
        world["${player[y]},${player[x]}"]="."
        world["$((${player[y]}+1)),${player[x]}"]="@"
        player[y]=$((player[y]+1))
    fi
    if [[ $action == d && ${player[x]} -lt $XSIZE ]] ; then
        world["${player[y]},${player[x]}"]="."
        world["${player[y]},$((player[x]+1))"]="@"
        player[x]=$((player[x]+1))
    fi
    draw
}

stty -echo
#trap 'stty echo' EXIT
#trap 'stty echo ; sudo kbdrate' EXIT
#trap 'stty echo ; xset r rate 250 20 ; echo exit' EXIT

# generate world

declare -A world

XSIZE=9
YSIZE=9

for y in `seq 0 $YSIZE`
do
    for x in `seq 0 $XSIZE`
    do
        if [ $(($RANDOM%5)) = 0 ] ; then
            world[$y,$x]="T"
        else
            world[$y,$x]="."
        fi
    done
done

declare -A player
player[x]=5
player[y]=5
world[${player[y]},${player[x]}]="@"

# start the game

#trap "sleep 0.01 ; echo ctrl-c ; reset ;echo $$;ls -l /proc/self/fd ; tty ; sleep 0.01 ; strace  -e openat,ioctl stty -F /dev/tty3 -a;strace  -e openat,ioctl stty -F /dev/tty3 echo ; strace  -e openat,ioctl stty -F /dev/tty3 -a; sleep 0.01 ; sleep 0.01 ; echo exit ; exit 0" SIGINT
trap "fun ; exec ./quit.sh" INT
trap "tick" USR1
#sudo kbdrate --rate=10 --delay=0
#xset r rate 1 30
#./timer.sh $$ &
i=20
while [[ $i -gt 0 ]]
do
    while read -n 1 -t 0.1 input ; do
        action=$input
    done
    echo $$
    ((--i))
done

#stty echo
