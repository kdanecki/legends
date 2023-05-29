#!/bin/bash

#set -x

draw () {
    clear
#    echo -n "" > world
    echo -n ""
    for y in `seq 0 $YSIZE`
    do
        for x in `seq 0 $XSIZE`
        do
            #echo -n ${world["$y,$x"]}  >> world
            echo -n ${world["$y,$x"]}
        done
#        echo >> world
        echo 
    done
    echo "action: $action"
}

tick () {
    while read -n 1 -t 0.01 input ; do
        action=$input
        if [[ $action == q ]] ; then
            exit 0
        fi
    done
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
    echo "tick works"
    action=""
}


# generate world

declare -A world

XSIZE=128
YSIZE=128

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

trap "tick" USR1
./timer.sh $$ &
i=20
while true #[[ $i -gt 0 ]]
do
    
    ((--i))
done

#./quit.sh
