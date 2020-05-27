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

if (!hasInterface) exitWith {};

[] call GRAD_leaveNotes_fnc_addInteractions;

[{!isNull player},{
    if (isNil {player getVariable "GRAD_leaveNotes_amount"}) then {
        player setVariable ["GRAD_leaveNotes_amount", GRAD_leaveNotes_startAmount]
    };
    if (isNil {player getVariable "GRAD_leaveNotes_handwriting"}) then {
        [player] call GRAD_leaveNotes_fnc_setHandwriting;
    };
},[]] call CBA_fnc_waitUntilAndExecute;
