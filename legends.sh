#!/bin/bash

trap "" INT

stty -echo
#sudo kbdrate --rate=10 --delay=0
xset r rate 10 30 

./main.sh

./quit.sh
