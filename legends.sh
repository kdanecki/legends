#!/bin/bash
#
#  Copyright (c) 2023-2023 Kamil Danecki <danecki.kamil@gmail.com>
#
# Legends is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Legends is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details <http://www.gnu.org/licenses/>.
# 
# starting script

nohup mplayer battle-epic.ogg &

while getopts "vh" OPTION ; do
    case $OPTION in
        v) echo 0.1 ; exit ;;
        h) echo "pomoc" ; exit ;;
    esac
done

trap "" INT

stty -echo
sudo kbdrate -s --rate=30 --delay=0
#xset r rate 10 30 

./main.sh

./quit.sh
