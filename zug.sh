#!/usr/bin/env bash

# preserve original
cp input/WoWCombatLog.txt output/WoWCombatLog.txt

mkdir -p /tmp/zug

log=output/WoWCombatLog.txt
orig=input/WoWCombatLog.txt


#    ┏━━━━━━━━━━━━━━━┓
#    |    GLOBALS    |
#    ┗━━━━━━━━━━━━━━━┛

sep="────────────  ⚔  ────────────"


#    ┏━━━━━━━━━━━━━━━┓
#    |    HUNTERS    |
#    ┗━━━━━━━━━━━━━━━┛

# PET DAMAGE ATTRIBUTION

# get hunter + pet pairs
# TODO detect duplicates - all pet family names?
grep 'Happiness from' $log | awk 'BEGIN{OFS=" "} { print $8,$3 }' | sort | uniq > /tmp/zug/hunter-pets


# get pet ability names
while read line; do

    pet=`echo $line | awk '{ print $2 }'`

    # https://stackoverflow.com/a/21077908
    grep -E "$pet 's .* hits" $log | sed -e "s/.*$pet 's \(.*\) hits.*/\1/" |\
    sort | uniq > /tmp/zug/pet-abilities-${pet}

done < /tmp/zug/hunter-pets


# find/replace "pet hits" -> "hunter 's pet hits"
while read line; do

    hunter=`echo $line | awk '{ print $1 }'`
    pet=`echo $line | awk '{ print $2 }'`
    h='HUNTERS:'

    # handle illegal pet names? e.g. abilities
    # even the logging addon says this is a no-no, so I'm not going out of my way to cover it. Trolls gonna troll

    # hits
    hmsg=`echo "replacing#'$pet hits'#with#'$hunter hits'" | column -t -s '#' -o $'\t'`
    echo "$h $hunter: $hmsg"
    sed -i'.bak' "s/${pet} hits/${hunter} hits/g" $log

    # crits
    cmsg=`echo "replacing#'$pet crits'#with#'$hunter crits'" | column -t -s '#' -o $'\t'`
    echo "$h $hunter: $cmsg"
    sed -i'.bak' "s/${pet} crits/${hunter} crits/g" $log

    # pet abilities
    while read ability; do
               
        # hits
        ahmsg=`echo "replacing#'$pet 's $ability hits'#with#'$hunter 's $ability hits'" | column -t -s '#' -o $'\t'`
        echo -e "$h $hunter: $ahmsg"
        sed -i'.bak' "s/${pet} 's $ability hits/${hunter} 's $ability hits/g" $log

        # crits 
        acmsg=`echo "replacing#'$pet 's $ability crits'#with#'$hunter 's $ability crits'" | column -t -s '#' -o $'\t'`
        echo -e "$h $hunter: $acmsg"
        sed -i'.bak' "s/${pet} 's $ability crits/${hunter} 's $ability crits/g" $log

    done < /tmp/zug/pet-abilities-${pet}

    # separator
    # echo "<< 🪓 >>"
    echo $sep

    # cleanup all pet miss/dodge/parry?
    # there's no way to affect pets' hit tables other than positioning, so this is mostly unimportant.
    # maybe tracking all parries and displaying them could be helpful...

done < /tmp/zug/hunter-pets


#    ┏━━━━━━━━━━━━━━━┓
#    |   WARRIORS    |
#    ┗━━━━━━━━━━━━━━━┛

# find all warriors
warriors=`grep "'s Heroic Strike" $log | awk '{ print $3 }' | sort | uniq`

# find all sunders
for war in $warriors; do
sunders=`grep "$war 's Sunder Armor" $log | wc -l`
echo -e "$war: $sunders" >> /tmp/zug/sunders
done

# print sunders sorted by #
sort -k2 -n /tmp/zug/sunders > output/accountability.txt
echo "WARRIORS: Number of Sunder Armor parries/dodges/misses"
cat output/accountability.txt | column -t
echo $sep


#    ┏━━━━━━━━━━━━━━━┓
#    |    OUTPUT     |
#    ┗━━━━━━━━━━━━━━━┛

zip output/WoWCombatLog.zip $log 


#    ┏━━━━━━━━━━━━━━━┓
#    |    CLEANUP    |
#    ┗━━━━━━━━━━━━━━━┛

rm -f output/WoWCombatLog.txt.bak
rm -f output/sed*
rm -rf /tmp/zug/*


#    ┏━━━━━━━━━━━━━━━┓
#    |   GRAVEYARD   |
#    ┗━━━━━━━━━━━━━━━┛

# print a character n times and set as var
    # hl=`expr length $h`
    # hunterl=`expr length $hunter`
    # sepl=`expr $hl + $hunterl + 3`
    # # https://stackoverflow.com/a/21998682
    # sep=`
    #     for ((i=1; i<$sepl/2; i++)); do
    #         printf '─%.0s' "$i"
    #     done
    #     `
