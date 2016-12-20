GRAD_leaveNotes_moduleRoot = [] call GRAD_leaveNotes_fnc_getModuleRoot;

GRAD_leaveNotes_playerDistance = [missionConfigFile >> "GRAD_leaveNotes" >> "playerDistance", "number", 1] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_actOffset = [missionConfigFile >> "GRAD_leaveNotes" >> "actOffset", "array", [0,0,0.1]] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_actDist = [missionConfigFile >> "GRAD_leaveNotes" >> "actDist", "number", 2] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_noteObject = [missionConfigFile >> "GRAD_leaveNotes" >> "noteObject", "text", "Land_Notepad_F"] call CBA_fnc_getConfigEntry;
GRAD_leaveNotes_canWriteDefault = ([missionConfigFile >> "GRAD_leaveNotes" >> "canWriteDefault", "number", 1] call CBA_fnc_getConfigEntry) == 1;
GRAD_leaveNotes_startAmount = [missionConfigFile >> "GRAD_leaveNotes" >> "startAmount", "number", 10] call CBA_fnc_getConfigEntry;

GRAD_leaveNotes_interactionSleepTime = 0.1;

if (!hasInterface) exitWith {};
if !(player getVariable ["GRAD_leaveNotes_canWriteNotes", GRAD_leaveNotes_canWriteDefault]) exitWith {};
[{!isNull player}, {[] call GRAD_leaveNotes_fnc_addSelfinteraction}, []] call CBA_fnc_waitUntilAndExecute;
