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
# DO NOT RUN THIS MANUALLY
# start with ./legends.sh



#set -x

draw () {
    echo "${world[type]}" > world
#    echo -n "0 " >> world
#    echo -n "${world["player,x"]} " >> world    
#    echo -n "${world["player,y"]} " >> world    
#    echo -n "${world["player,hp"]} " >> world    
#    echo "" >> world
    echo "0 1 ${player[x]} ${player[y]}" >> world

    for i in `seq 0 10`
    do
        STATE=1
        if [[ ${world["enemy$i,hp"]} == 0 ]] ; then
            STATE=0
        fi
            echo "${world["enemy$i,type"]} $STATE ${world["enemy$i,x"]} ${world["enemy$i,y"]}" >> world
    done
    if [[ ${FIREBALL[spawned]} == 1 ]] ; then
        echo "1 ${FIREBALL[dir]} ${FIREBALL[x]} ${FIREBALL[y]}" >> world
    fi
}

generate () {
    world[type]=$((RANDOM%3))
    case $1 in
        0) for i in `seq 0 10`
            do
                world["enemy$i,x"]=$((RANDOM%XSIZE))
                world["enemy$i,y"]=$((RANDOM%(YSIZE*3/4)))
                world["enemy$i,type"]=$((2+(RANDOM%3)))
                world["enemy$i,hp"]=${HP[${world["enemy$i,type"]}]}
            done
            ;;
        1) for i in `seq 0 10`
            do
                world["enemy$i,x"]=$(((XSIZE/4) + RANDOM%(XSIZE*3/4)))
                world["enemy$i,y"]=$((RANDOM%YSIZE))
                world["enemy$i,type"]=$((2+(RANDOM%3)))
                world["enemy$i,hp"]=${HP[${world["enemy$i,type"]}]}
            done
            ;;
        2) for i in `seq 0 10`
            do
                world["enemy$i,x"]=$((RANDOM%XSIZE))
                world["enemy$i,y"]=$(((YSIZE/4) + RANDOM%(YSIZE*3/4)))
                world["enemy$i,type"]=$((2+(RANDOM%3)))
                world["enemy$i,hp"]=${HP[${world["enemy$i,type"]}]}
            done
            ;;
        3) for i in `seq 0 10`
            do
                world["enemy$i,x"]=$((RANDOM%(XSIZE*3/4)))
                world["enemy$i,y"]=$((RANDOM%YSIZE))
                world["enemy$i,type"]=$((2+(RANDOM%3)))
                world["enemy$i,hp"]=${HP[${world["enemy$i,type"]}]}
            done
            ;;
    esac
}

normalize () {
    if [[ $1 -gt 0 ]] ; then
        echo 1
    elif [[ $1 -lt 0 ]] ; then
        echo -1
    else
        echo 0
    fi
}

tick () {
    kill -USR1 $DRAWPID
    while read -n 1 -t 0.01 input ; do
        action=$input
        TICK=7
        if [[ $action == q ]] ; then
            exit 0
        fi
    done
    if [[ $action == w ]] ; then
        player[y]=$((${player[y]}-${SPEED[0]}))
    fi
    if [[ $action == a ]] ; then
        player[x]=$((${player[x]}-${SPEED[0]}))
    fi
    if [[ $action == s ]] ; then
        player[y]=$((${player[y]}+${SPEED[0]}))
    fi
    if [[ $action == d ]] ; then
        player[x]=$((${player[x]}+${SPEED[0]}))
    fi

    if [[ ${player[x]} -gt $(($XSIZE-80)) ]] ; then
        player[x]=15
        generate 1
    elif [[ ${player[x]} -lt 10 ]] ; then
        player[x]=$((XSIZE-90))
        generate 3
    elif [[ ${player[y]} -lt 10 ]] ; then
        player[y]=$((YSIZE-90))
        generate 0
    elif [[ ${player[y]} -gt $(($YSIZE-80)) ]] ; then
        player[y]=15
        generate 2
    fi



    draw
#    echo "bla bla$(normalize 10)"
    if [[ $((TICK--)) -le 0 ]] ; then  
        action=""
    fi

    for i in `seq 0 10`
    do
        if [[ world["enemy$i,hp"] -gt 0 ]] ; then
            DISTANCEXPLAYER=$((player[x]-world["enemy$i,x"]))
            DISTANCEYPLAYER=$((player[y]-world["enemy$i,y"]))
            DIRX=`normalize $DISTANCEXPLAYER`
            DIRY=`normalize $DISTANCEYPLAYER`
            if [[ ${DISTANCEXPLAYER#-} -lt world["enemy$i,cx"] && ${DISTANCEYPLAYER#-} -lt world["enemy$i,cy"] ]]
            then
                ((player[hp] -= ${world["enemy$i,hp"]}))
                if [[ ${player[hp]} -le 0 ]] ; then
                    clear
                    echo "YOU DIED"
                    echo "You defeated ${player[points]} enemies"
                    exit
                fi
                world["enemy$i,hp"]="0"
            fi
            DISTANCEX=$((FIREBALL[x]-(world["enemy$i,x"]+world["enemy$i,cx"]/2)))
            DISTANCEY=$((FIREBALL[y]-(world["enemy$i,y"]+world["enemy$i,cy"]/2)))
            if [[ ${FIREBALL[spawned]} -eq 1 && ${DISTANCEX#-} -lt world["enemy$i,cx"] && ${DISTANCEY#-} -lt world["enemy$i,cy"] ]]
            then
                world["enemy$i,hp"]="0"
                FIREBALL[spawned]=0
                ((player[points]++))
            fi
            if [[ world["enemy$i,hp"] -gt 0 ]] ; then
                ((world["enemy$i,y"] += $DIRY * ${SPEED[${world["enemy$i,type"]}]}))
                ((world["enemy$i,x"] += $DIRX * ${SPEED[${world["enemy$i,type"]}]}))
            fi
        fi
    done
    if [[ ${FIREBALL[spawned]} == 0 ]] ; then
        if [[ $action == h ]] ; then
            FIREBALL[dir]=0
            FIREBALL[x]=$((${player[x]}+30))
            FIREBALL[y]=$((${player[y]}+30))
            FIREBALL[spawned]=1
        fi
        if [[ $action == j ]] ; then
            FIREBALL[dir]=1
            FIREBALL[x]=$((${player[x]}+30))
            FIREBALL[y]=$((${player[y]}+30))
            FIREBALL[spawned]=1
        fi
        if [[ $action == k ]] ; then
            FIREBALL[dir]=2
            FIREBALL[x]=$((${player[x]}+30))
            FIREBALL[y]=$((${player[y]}+30))
            FIREBALL[spawned]=1
        fi
        if [[ $action == l ]] ; then
            FIREBALL[dir]=3
            FIREBALL[x]=$((${player[x]}+30))
            FIREBALL[y]=$((${player[y]}+30))
            FIREBALL[spawned]=1
        fi
    else
        case ${FIREBALL[dir]} in
            0) ((FIREBALL[x] -= ${SPEED[1]})) ;; 
            1) ((FIREBALL[y] += ${SPEED[1]})) ;; 
            2) ((FIREBALL[y] -= ${SPEED[1]})) ;; 
            3) ((FIREBALL[x] += ${SPEED[1]}))
        esac
        if [[ ${FIREBALL[x]} -ge $(($XSIZE-70)) || ${FIREBALL[x]} -lt 0 || ${FIREBALL[y]} -ge $YSIZE || ${FIREBALL[y]} -lt 0 ]] ; then
            FIREBALL[spawned]=0
        fi
        #echo ${FIREBALL[@]}
    fi
}


# generate world

declare -A world

world[type]=0

XSIZE=1920
YSIZE=1080

declare -a SPEED
SPEED[0]=5
SPEED[1]=10
SPEED[2]=2
SPEED[3]=3
SPEED[4]=5
#SPEED=5
#FSPEED=10
#OSPEED=1
declare -a HP
HP[0]=3
HP[1]=999
HP[2]=3
HP[3]=3
HP[4]=3

TICK=0

declare -A player
player[x]=960
player[y]=540
player[hp]=3
player[cx]=72
player[cy]=72
player[points]=0

declare -A FIREBALL

FIREBALL[x]=2000
FIREBALL[y]=2000
FIREBALL[spawned]=0
FIREBALL[dir]=0


for i in `seq 0 10`
do
    if [[ $((RANDOM%2)) == 1 ]] ; then
        world["enemy$i,x"]=$(($RANDOM%500))
    else
        world["enemy$i,x"]=$((1400 + $RANDOM%400))
    fi
    if [[ $((RANDOM%2)) == 1 ]] ; then
        world["enemy$i,y"]=$(($RANDOM%300))
    else
        world["enemy$i,y"]=$((700 + $RANDOM%300))
    fi
    world["enemy$i,hp"]=0
    world["enemy$i,cx"]=72
    world["enemy$i,cy"]=72
    world["enemy$i,type"]=$((2+(RANDOM%3)))
done

# start the game

./a.out &
DRAWPID=$!
sleep 1
trap "tick" USR1
./timer.sh $$ &
i=20
draw
for i in `seq 0 10`
do
    world["enemy$i,hp"]=${HP[${world["enemy$i,type"]}]}
done
while true #[[ $i -gt 0 ]]
do
    
    ((--i))
done

