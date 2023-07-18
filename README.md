# ZUG

This script parses and modifies [Legacy Players](http://legacyplayers.info/) log files (server: Turtle WoW (1.16.1)). Its goal is twofold: to fix inconsistencies and omissions in the Legacy Players parsing process, and to report key data to more accurately assess players' performance.

This is my first shell script. I don't have tons of time to work on this. Temper your expectations.

## INSTRUCTIONS
You will need a Linux environment. 

1. Move your log file (must be named `WoWCombatLog.txt`) into the `input` directory.
1. In the main directory (`ZUG`), run:
```sh
./zug.sh
```

Results are created in the `output` directory. The original log file is preserved in `input`.

## FUNCTIONALITY

### HUNTERS
ZUG associates pets' hits (and their abilities' hits) with hunters. 
This is accomplished by replacing pet names with hunter names in pet damage entries.

### WARRIORS
ZUG prints the number of times each warrior's Sunder Armor was parried, dodged, or missed. 
Sunder Armor hits don't get logged, so I think this is the only way to get an idea of who's pressing the button.

### SHAMANS
NYI: ZUG associates minions (fire totems and spirit wolves) with shamans.
This is accomplished by replacing minion names with shaman names in minion damage entries.

This is NYI because shaman minions have generic names. In a raid with multiple shamans, timestamp arithmetic is required to accurately associate minion damage with shamans. This is far more complicated than the 1:1 replacements for hunter pets.