if (!hasInterface) exitWith {};
params ["_noteID", "_mode", ["_message", ""], ["_handwriting", ["",["",""]]]];

//remove note
if (_mode == "remove") then {
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 1]) - 1];

    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    _readactionName = _nodeName + "_read";
    _dropactionName = _nodeName + "_drop";
    _destroyactionName = _nodeName + "_destroy";
    _giveactionName = _nodeName + "_give";

    //self interactions
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName, _readactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName, _dropactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName, _destroyactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName]] call ace_interact_menu_fnc_removeActionFromObject;

    //give interaction
    [0,["ACE_MainActions", "GRAD_leaveNotes_mainGiveAction", _giveactionName]] call FAKEACE_interact_menu_fnc_removeActionFromClass;
    /*["CAManBase",0,["ACE_MainActions", "GRAD_leaveNotes_mainGiveAction", _giveactionName]] call ace_interact_menu_fnc_removeActionFromClass;*/
};

//add note
if (_mode == "add") then {
    player setVariable ["GRAD_leaveNotes_notesHandled", (player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1];
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) + 1];
    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    player setVariable [_nodeName + "_message", _message];
    player setVariable [_nodeName + "_handwriting", _handwriting];

    //node
    _actionDisplayText = [_message] call GRAD_leaveNotes_fnc_generateName;
    _action = [_nodeName, _actionDisplayText, GRAD_leaveNotes_moduleRoot + "\data\note.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;

    //read
    _readactionName = _nodeName + "_read";
    _readAction = {(_this select 2) call GRAD_leaveNotes_fnc_delayedCall};
    _action = [_readactionName, "Read Note", GRAD_leaveNotes_moduleRoot + "\data\read.paa", _readAction, {true}, {}, [[_message, _noteID, _handwriting],GRAD_leaveNotes_fnc_readNote]] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //drop
    _dropactionName = _nodeName + "_drop";
    _dropAction = {(_this select 2) params ["_noteID", "_message", "_handwriting"]; [_message, _handwriting] call GRAD_leaveNotes_fnc_dropNote; [_noteID, "remove"] call GRAD_leaveNotes_fnc_updateMyNotes};
    _action = [_dropactionName, "Drop Note", GRAD_leaveNotes_moduleRoot + "\data\drop.paa", _dropAction, {true}, {}, [_noteID, _message, _handwriting]] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //destroy
    _destroyactionName = _nodeName + "_destroy";
    _action = [_destroyactionName, "Destroy Note", GRAD_leaveNotes_moduleRoot + "\data\destroy.paa", {(_this select 2) call GRAD_leaveNotes_fnc_destroyNote}, {true}, {}, [_noteID]] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //give
    _giveactionName = _nodeName + "_give";
    _action = [_giveactionName, _actionDisplayText, GRAD_leaveNotes_moduleRoot + "\data\note.paa", {_this call GRAD_leaveNotes_fnc_giveNote}, {true}, {}, [_noteID, _message, _handwriting]] call ace_interact_menu_fnc_createAction;
    ["CAManBase",0,["ACE_MainActions","GRAD_leaveNotes_mainGiveAction"],_action,true] call ace_interact_menu_fnc_addActionToClass;
};
