#! /bin/bash

# oneline to create test file
#for i in $(eval echo {"http://ice.somafm.com/beatblender"," http://ice.somafm.com/sonicuniverse","http://ice.somafm.com/dubstep"}); do echo $i >> "$HOME/.streamlist"; done
#
#set -x
function getRandomIndex()
{
    local number=$RANDOM
    number=$(($number % $limit))
    return $number
}

function play()
{
    local idx=$1
    echo "index $idx"
    mplayer ${lines[$idx]}
    exit 0
}

#TODO
# check if link is an valid url
function addNewStream()
{
    local name=$1
    local link=$2
    echo "$name $link" >> $slist
    exec mplayer $link
}

function list()
{
    OLDIFS=$IFS
    IFS=""
    for ((j=0; j < $limit; j++))
    do
        echo "[$j] ${lines[$j]}"
    done
    IFS=$OLDIFS
}

function playRandom()
{
    getRandomIndex
    local num=$?
    play $num
    exit 0
}

slist="$HOME/.streamlist"
if [ ! -z $list ]; then
    echo "could not find .streamlist"
    exit 1
fi

typeset -i i=0
while read lines[$i]
do
    i=i+1
done < $slist

limit=$(expr ${#lines[@]} - 1)

while getopts a:lri: opt
do
    case $opt in
        a) shift; addNewStream "$@";;
        l) list && exit;;
        i) play $OPTARG;;
        r) playRandom;;
    esac
done

# main loop
while list
do
    echo "take your choose:"
    read -t5 num;
    if [ $? -eq 142 ]; then
        echo "starting random ..."
        getRandomIndex
        num=$?
    elif [ $num -gt $limit ]; then
        echo "wrong index $num choose between 0 and $limit"
        continue
    fi

    play $num
done
