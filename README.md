# ZUG

This script edits [Legacy Players](http://legacyplayers.info/) log files (server: Turtle WoW (1.16.1)) to fix inconsistencies and omissions in the parsing process.

This is my first shell script. I don't have tons of time to work on this. Keep both of those factors in mind.

## HUNTERS
ZUG associates pets' hits (and their abilities' hits) with hunters. 
This is accomplished by replacing pet names with hunter names in pet damage entries.

## WARRIORS
ZUG prints the number of times each warrior's Sunder Armor was parried, dodged, or missed. 
Sunder Armor hits don't get logged, so I think this is the only way to get an idea of who's pressing the button.