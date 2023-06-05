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
# DO NOT RUN MANUALLY
# clock script

speed=1

delay=4 #$speed
while [ -d /proc/$1 ]
do
#    ((--delay))
#    if [ $delay -le 0 ] ; then
        kill -USR1 $1
 #       delay=$speed
#    fi
    sleep 0.02
done
