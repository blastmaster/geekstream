#! /bin/bash

# oneline to create test file
#for i in $(eval echo {"http://ice.somafm.com/beatblender"," http://ice.somafm.com/sonicuniverse","http://ice.somafm.com/dubstep"}); do echo $i >> "$HOME/.streamlist"; done
#

slist="$HOME/.streamlist"
[ -z $slist ] || echo "could not find .streamlist" && exit 1
typeset -i i=0
while read lines[$i]
do
    i=i+1
done < $slist

