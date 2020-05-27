private _functionsPath = [(missionConfigFile >> "CfgFunctions" >> "GRAD_leaveNotes" >> "common" >> "file"), "text", ""] call CBA_fnc_getConfigEntry;
private _functionsPathArray = _functionsPath splitString "\";
_functionsPathArray deleteAt (count _functionsPathArray - 1);
private _root = _functionsPathArray joinString "\";

_root
