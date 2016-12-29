GRAD_leaveNotes_moduleRoot = [] call GRAD_leaveNotes_fnc_getModuleRoot;

GRAD_leaveNotes_playerDistance = [missionConfigFile >> "GRAD_leaveNotes" >> "playerDistance", "number", 1] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_actOffset = [missionConfigFile >> "GRAD_leaveNotes" >> "actOffset", "array", [0,0,0.1]] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_actDist = [missionConfigFile >> "GRAD_leaveNotes" >> "actDist", "number", 2] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_noteObject = [missionConfigFile >> "GRAD_leaveNotes" >> "noteObject", "text", "Land_Notepad_F"] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_startAmount = [missionConfigFile >> "GRAD_leaveNotes" >> "startAmount", "number", 10] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_visibleHandwriting = ([missionConfigFile >> "GRAD_leaveNotes" >> "visibleHandwriting", "number", 1] call CBA_fnc_getConfigEntry) == 1;
GRAD_leaveNotes_canWriteDefault = ([missionConfigFile >> "GRAD_leaveNotes" >> "canWriteDefault", "number", 1] call CBA_fnc_getConfigEntry) == 1;
GRAD_leaveNotes_canInspectDefault = ([missionConfigFile >> "GRAD_leaveNotes" >> "canInspectDefault", "number", 1] call CBA_fnc_getConfigEntry) == 1;

GRAD_leaveNotes_interactionSleepTime = 0.1;

GRAD_leaveNotes_inheritFromCAManBase = ("configName _x isKindOf 'Car'" configClasses (configFile / "CfgVehicles")) apply {configName _x};

if (!hasInterface) exitWith {};

//set start amount
_startAmount = player getVariable "GRAD_leaveNotes_amount";
if (isNil "_startAmount") then {player setVariable ["GRAD_leaveNotes_amount", GRAD_leaveNotes_startAmount]};

//set handwriting
[player] call GRAD_leaveNotes_fnc_setHandwriting;

//add interaction nodes
[{!isNull player}, {
    [] call GRAD_leaveNotes_fnc_addSelfinteraction;

    _action = ["GRAD_leaveNotes_mainGiveAction", "Give note", GRAD_leaveNotes_moduleRoot + "\data\give.paa", {}, {(player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) > 0}] call ace_interact_menu_fnc_createAction;
    ["CAManBase",0,["ACE_MainActions"],_action,true] call ace_interact_menu_fnc_addActionToClass;
}, []] call CBA_fnc_waitUntilAndExecute;
