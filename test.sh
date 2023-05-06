l=123  
      
boo() {
echo "l=$l"
}      
      
      
kwadrat() {
   echo "fun: $l"  
   local l=$(($1 - 1))
      
   if [ $l != 0 ]
   then
       kwadrat $l
       boo $l
   fi
}      
      
kwadrat $1
echo $l
      
      
tab=()
      
tab[0]="ala"
tab[1]="lola"
tab[10]="bolek"
tab[5]="bobo"
      
declare -A  asoc
asoc["jeden"]="1"
asoc["dwa"]="2"
asoc["tab"]=${tab[1]}


echo ${tab[@]}
      
      
echo "tab=${tab[@]} size=${#tab[@]}"
echo "asoc=${asoc[@]} size=${#asoc[@]}"
      
echo "jeden=${asoc["jeden"]}"
      
      
for i in ${asoc[@]}
do     
   echo "asoc: $i"
done   
      
declare -A t1
t1=${asoc["tab"]}                                                                                                                                                                                                                                                                         
echo "keys=${!asoc[@]}"
echo "t1=${t1[@]}"
t1[0]="nie lola"
echo "t1=${t1[@]}"
echo "tab=${tab[@]}"

declare -n p="tab"
#p="bla bla"
echo "p=${p[@]}"
echo $l
#declare -p
      
#echo "key t1: ${t1[@]}"
      
#echo "key asoc: ${asoc[1]}"
      
#for i in ${!t1[@]}  
#do    
#    echo "$i: ${tab[$i]}"
#done

# nohup mplayer battle-epic.ogg &
