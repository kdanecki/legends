#!/bin/bash

stty -echo
trap 'stty echo' EXIT
trap 'echo sygnal' USR1
next=5
for i in `seq 1 1000`
do
    while read -n 1 -t 0.01 input
    do
        action=$input
    done
    ((--next))
    if [ $next -le 0 ] ; then
        echo "tick $action"
        next=5
        action=""
    fi 
#    read -n 1 -t 0.01 test1
#    echo "test1: $test1"
    sleep 0.1
done
stty echo
trap - EXIT
trap - USR1

#read -t 2 abc 2> test

#b=$(echo "a: $abc")
#echo "b: $b"
#for i in `seq 1 100`
#do
 #   echo $(read -t 1 abc)
#    test1=$(read -n 1 -s -t 1 abc)
 #   echo "$i out: $abc, $test1"
#    sleep 1
#done
