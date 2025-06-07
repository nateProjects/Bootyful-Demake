# Issues

## Not implemented due to problems

- Traveling platforms - Worked imperfectly, so didn't implement traveling between moving platforms, and didn't put in data past first few levels. Replaced with fading platforms.
- Booby traps - Timing and animation issues, so didn't implement avoidance and death.
- No falling - Timing and animation issues.
- Birds, Rats & Flood door - Unexpectedly being trapped or dying seemed unfair.
- 3rd Pirate on a couple levels - Animation issues.
- Settings screen.

## Planned features that didn't make it

Most of these were not implemented due to lack of available memory and / or that they were impractical to implement.

- Bonus levels from C64 version.
- Map screen to show progress, connections between levels.
- Different difficulty modes.
- Part 2 of game in which ship was slowly flooding.
- Ability to get weapons to kill pirates.

## Other differences from the original

- Exit level indicator.
- Death & completion screen.
- Turned off return to start upon death.
- No secret game - not enough memory.
- No changing level color palette.
- No special timed end escape.
- Treasure is randomly distributed
- No animated portholes

## Lessons learnt

- It can be faster to rewrite than to fix
- if it's not faster to rewrite try the simplest test possible and debug that!
- Group timing based events together
- Use same collision functions for NPCs as player
- Don't use exact numbers use relative arrays
- Account for elements and how they interactive beforehand
- Replace temporary stop-gap code as soon as possible (or don't use)
- Abstract movement to be able programmable for testing gameplay automatically

## Real bugs

- FIXED - Sometimes you seem to get stuck on a ladder
- Sometimes you respawn after death behind a door
- Pressing Z to reposition was introduced to address this

## Not so secret cheats

- On Level 2 to get to door 3 use Level 9 door 3
- On Level 5 to get to door 1 use Level 20 door 1
- On Level 8 to get to door 1 use Level 16 door 2
- On Level 16 to get to door 2 use Level 15 door 2

Note: Door 1 on Level 4 & Level 19 are one way doors (to Levels 10 & 14). Door 3 on Level 11 is a death-trap door!

### Hard coded cheats

Add to the end of gameinit()

- To remove enemies - cheat[2]==1
- To remove doors - cheat[3]=1
- To jump to the next level using Z - cheat[5]=1
- To fill in fading platforms - cheat[7]=1
