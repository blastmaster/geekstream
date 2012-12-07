#! /bin/bash

# oneline to create test file
#for i in $(eval echo {"http://ice.somafm.com/beatblender"," http://ice.somafm.com/sonicuniverse","http://ice.somafm.com/dubstep"}); do echo $i >> "$HOME/.streamlist"; done
#
#set -x
function getRandomIndex()
{
    local number=$RANDOM
    number=$(($number % ${#lines[@]}))
    #eval "$1='$number'"
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
# after adding a new stream it should play it instant
# check if link is an valid url
function addNewStream()
{
    local name=$1
    local link=$2
    echo "$name $link" >> $slist
    exit 0
}

function list()
{
    OLDIFS=$IFS
    IFS=""
    for ((j=0; j < ${#lines[@]}; j++))
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

while getopts a:lri: opt
do
    case $opt in
        a) shift; addNewStream "$@";;
        l) list && exit;;
        i) play $OPTARG;;
        r) playRandom;;
        ?) list;;
    esac
done

echo "take your choose:"
read -t5 num;
if [ $? -eq 142 ]; then
    echo "starting random ..."
    getRandomIndex
    num=$?
fi

play $num

