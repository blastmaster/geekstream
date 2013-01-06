#! /bin/bash

function playRandom()
{
    local number=$RANDOM
    number=$(($number % $limit))
    playIndex $number
}

function playIndex()
{
    local idx=$1
    if [[ $idx -le $limit ]];then
        arg=$(echo ${lines[$idx]} | awk '{print $2}')
        play $arg
    else
        echo error index not found
    fi
}

function play()
{
    local ressource=$1
    echo RESSOURCE $ressource
    if [[ -f $ressource ]]; then
        exec mplayer -playlist $ressource
    else
        exec mplayer $ressource
    fi
}

function addNewStream()
{
    local name=$1
    local ressource=$2
    echo "$name $ressource" >> $slist
    play $ressource
}

function list()
{
    OLDIFS=$IFS IFS=""
    for ((j=0; j < $limit; j++))
    do
        echo "[$j] ${lines[$j]}"
    done
    IFS=$OLDIFS
}

function interactive()
{
    while list
    do
        echo "take your choose:"
        read num;
        if [[ $num =~ ^[^0-9]+$ ]]; then
            parseCategory $num
        elif [ $num -gt $limit ]; then
            echo "wrong index $num choose between 0 and $limit"
            continue
        fi
        playIndex $num
    done
}

function parseCategory()
{
    local regex="(^[a-zA-Z-]+\s?)\s(.*$)"
    for ((k=0; k < $limit; k++))
    do
        if [[ ${lines[$k]} =~ $regex ]]; then
            n=${#BASH_REMATCH[*]}
            if [[ $n -eq 3 ]]; then
                category=${BASH_REMATCH[1]}
                ressource=${BASH_REMATCH[2]}
                if [[ $category =~ $1 ]]; then
                    play $ressource
                fi
            else
                echo unrecognized numbers of sub-matches
            fi
        else
            echo regex does not match
        fi
    done
}

# exists global file
slist="$HOME/.streamlist"
if [ ! -z $list ]; then
    echo "could not find .streamlist"
    exit 1
fi

# read it
typeset -i i=0
while read lines[$i]
do
    i=i+1
done < $slist

limit=$(expr ${#lines[@]} - 1)

if [[ $# -lt 1 ]]; then
    interactive
fi

while getopts a:lri: opt
do
    case $opt in
        a) shift; addNewStream "$@";;
        l) interactive;;
        i) playIndex $OPTARG;;
        r) playRandom;;
    esac
done
parseCategory "$@"
