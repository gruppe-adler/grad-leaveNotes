params ["_type","_path"];

_actionName = _path select (count _path - 1);
_actionID = [_actionName] call FAKEACE_interact_menu_fnc_findActionName;
_allClassesThatInherited = [_actionID] call FAKEACE_interact_menu_fnc_getAllClasses;

{
    [_x,_type,_path] call ace_interact_menu_fnc_removeActionFromClass;
} forEach _allClassesThatInherited;

ace_interact_menu_inheritedActions deleteAt _actionID;
