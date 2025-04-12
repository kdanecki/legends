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
# cleaup script 

echo $DISPLAY
sudo kbdrate -s --rate=30 --delay=250
#xset r rate 250 20
while read -t 0.1
do
    i=1
done
stty echo
killall ./a.out
killall mplayer

echo "bye bye"
