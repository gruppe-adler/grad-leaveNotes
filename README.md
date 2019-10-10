# GRAD LeaveNotes

Enables you to:
* write notes (ACE-Selfinteraction)
* place notes on the ground
* store notes in your (virtual) inventory (ACE-Selfinteraction)
* read notes
* inspect a notes handwriting
* destroy notes

GRAD LeaveNotes is multiplayer and JIP proof.

[![Youtube Video](http://i.imgur.com/0tT6LX3.png)](https://www.youtube.com/watch?v=RiyfNgn-hQo&feature=youtu.be)


## Dependencies
* [CBA_A3](https://github.com/CBATeam/CBA_A3)
* [ACE3](https://github.com/acemod/ACE3)


## Installation
### Manually
1. Create a folder in your mission root folder and name it `node_modules`. Then create one inside there and call it `grad-leaveNotes`. If you want to use a different folder name, you *have* to preped your description.ext with `#define MODULES_DIRECTORY <yourFolderName>`.
2. Download the contents of this repository ( there's a download link at the side ) and put it into the directory you just created.
3. see step 3 below in the npm part

### Via `npm`
_for details about what npm is and how to use it, look it up on [npmjs.com](https://www.npmjs.com/)_

1. Install package `grad-leaveNotes` : `npm install --save grad-leaveNotes`
2. Append the following lines of code to the `description.ext`:

```sqf
#include "node_modules\grad-leaveNotes\grad_leaveNotes.hpp"

class CfgFunctions {
    #include "node_modules\grad-leaveNotes\cfgFunctions.hpp"
};

class CfgSounds {
	sounds[] = {};
    #include "node_modules\grad-leaveNotes\cfgSounds.hpp"
};
```


## Usage
Using the notes system is fairly intuitive. Open up your ACE selfinteraction menu, go to "Equipment", "Notes" and choose "Write Note". A notepad will open up. Write whatever you like, then hit "SAVE" to put the note into your virtual inventory or hit "DROP" to place it on the ground. Use your ACE interaction key to read, pick up or destroy notes on the ground. Use your selfinteraction menu and go to "Equipment", "Notes" again to read, drop or destroy notes in your virtual inventory.

Use this function to enable/disable a unit to write notes (default is true):  
`[unit, allow] call GRAD_leaveNotes_fnc_allowWriting;`

Use this function to enable/disable a unit to inspect notes (default is true):  
`[unit, allow] call GRAD_leaveNotes_fnc_allowInspection;`

Use this function to set how many notes a unit can write (default is 10):  
`[unit, amount] call GRAD_leaveNotes_fnc_setAmount;`

All of these function have to be called either on server or or client where unit is local.

| Parameter | Type | Explanation |
| ----------|------|-------------|
| unit      | object | The unit this applies to |
| allow     | bool   | Enable or disable this ability |
| amount    | number | Amount of notes this unit can write. (Does not add to remaining amount.) |


## Configuration
You can configure this module in your `description.ext`. This is entirely optional however, since every setting has a default value.

Add the class `GRAD_leaveNotes` to your `description.ext`, then add any of these attributes to configure the module:

| Attribute       | Default Value    | Explanation                                                 |
|-----------------|------------------|-------------------------------------------------------------|
| startAmount     | 10               | (Number) How many notes a player can write by default.      |
| noteObject      | "Land_Notepad_F" | (String) Note object class name.                            |
| actOffset[]     | {0,0,0.1}        | (Array) Note object interaction point offset.               |
| actDist         | 2                | (Number) Note object interaction distance.                  |
| playerDistance  | 1                | (Number) Distance to player at which notes will be dropped. |
| visibleHandwriting | 1             | (1/0) is a player's handwriting represented by a specific font? |
| canWriteDefault | 1                | (1/0) Can everyone write notes by default?                  |
| canInspectDefault | 1              | (1/0) Can everyone inspect a note's handwriting by default? |

Example:

```sqf
class GRAD_leaveNotes {
    playerDistance = 1;             
    actOffset[] = {0,0,0.1};        
    actDist = 2;                    
    noteObject = "Land_Notepad_F";  
    startAmount = 10;               
    visibleHandwriting = 1;         
    canWriteDefault = 1;            
    canInspectDefault = 1;          
};
```

## Handwriting
By default, a note's handwriting is represented by one of 9 fonts. So most of the times you will know that two notes are from two different authors simply by looking at them. However if two notes *do* seem to have the same handwriting, only inspecting them will tell you more.

Each font has an adjective that it is described by. For example: "EtelkaMonospacePro" will show up as "elegant" handwriting upon inspection. Every handwriting also has one of three modifiers, "somewhat", "quite", and "remarkably". So if two notes have the same font but show up as "quite elegant" and "somewhat elegant", they must have been written by different authors.

9 adjevtives and 3 modifiers give us a total of 27 different handwritings. So depending on number of players, two or more people in your game might have the same.
