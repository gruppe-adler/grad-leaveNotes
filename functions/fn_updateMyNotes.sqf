if (!hasInterface) exitWith {};
params ["_noteID", "_mode", ["_message", ""]];

//remove note
if (_mode == "remove") then {
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 1]) - 1];

    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    _readactionName = _nodeName + "_read";
    _dropactionName = _nodeName + "_drop";
    _destroyactionName = _nodeName + "_destroy";

    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName, _readactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName, _dropactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName, _destroyactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName]] call ace_interact_menu_fnc_removeActionFromObject;
};

//add note
if (_mode == "add") then {
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) + 1];
    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    player setVariable [_nodeName + "_message", _message];

    //node
    _actionDisplayText = [_message] call GRAD_leaveNotes_fnc_generateName;
    _action = [_nodeName, _actionDisplayText, "", {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;

    //read
    _readactionName = _nodeName + "_read";
    _readAction = {(_this select 2) call GRAD_leaveNotes_fnc_delayedCall};
    _action = [_readactionName, "Read Note", GRAD_leaveNotes_moduleRoot + "\data\read.paa", _readAction, {true}, {}, [[call compile format ["player getVariable ['GRAD_leaveNotes_myNotes_%1_message', '']", _noteID], _noteID],GRAD_leaveNotes_fnc_readNote]] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //drop
    _dropactionName = _nodeName + "_drop";
    _dropAction = compile format ["[player getVariable ['GRAD_leaveNotes_myNotes_%1_message', '']] call GRAD_leaveNotes_fnc_dropNote; [%1, 'remove'] call GRAD_leaveNotes_fnc_updateMyNotes", _noteID];
    _action = [_dropactionName, "Drop Note", GRAD_leaveNotes_moduleRoot + "\data\drop.paa", _dropAction, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //destroy
    _destroyactionName = _nodeName + "_destroy";
    _destroyAction = {[_this select 2] call GRAD_leaveNotes_fnc_destroyNote};
    _action = [_destroyactionName, "Destroy Note", GRAD_leaveNotes_moduleRoot + "\data\destroy.paa", _destroyAction, {true}, {}, _noteID] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;
};
