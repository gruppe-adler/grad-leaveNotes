//add main selfinteraction node
private _mainCondition = {
    params ["",["_unit",objNull]];
    ({!isNil "_x"} count (_unit getVariable ["grad_leaveNotes_notesArray", []])) > 0 ||
    {_unit getVariable ["GRAD_leaveNotes_canWriteNotes", GRAD_leaveNotes_canWriteDefault]}
};
private _mainChildren = {
    params ["",["_unit",objNull]];

    private _children = [];
    {
        if (!isNil "_x") then {
            _x params [["_message",""],["_handwriting",["somewhat",["small","PuristaLight"]]]];

            private _noteID = _forEachIndex;
            private _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
            private _actionDisplayText = [_message] call GRAD_leaveNotes_fnc_generateName;
            private _action = [_nodeName, _actionDisplayText, GRAD_leaveNotes_moduleRoot + "\data\note.paa", {true}, {true}] call ace_interact_menu_fnc_createAction;

            private _grandChildren = [];

            //read
            private _readactionName = _nodeName + "_read";
            private _readActionCode = {(_this select 2) call GRAD_leaveNotes_fnc_delayedCall};
            private _readAction = [_readactionName, "Read Note", GRAD_leaveNotes_moduleRoot + "\data\read.paa", _readActionCode, {true}, {}, [[_message, _noteID, _handwriting, ACE_player],GRAD_leaveNotes_fnc_readNote]] call ace_interact_menu_fnc_createAction;
            _grandChildren pushBack [_readAction,[],_unit];

            //drop
            private _dropactionName = _nodeName + "_drop";
            private _dropActionCode = {(_this select 2) params ["_noteID", "_message", "_handwriting"]; [_message, _handwriting] call GRAD_leaveNotes_fnc_dropNote; [_noteID, "remove"] call GRAD_leaveNotes_fnc_updateMyNotes};
            private _dropAction = [_dropactionName, "Drop Note", GRAD_leaveNotes_moduleRoot + "\data\drop.paa", _dropActionCode, {true}, {}, [_noteID, _message, _handwriting]] call ace_interact_menu_fnc_createAction;
            _grandChildren pushBack [_dropAction,[],_unit];

            //destroy
            private _destroyactionName = _nodeName + "_destroy";
            private _destroyAction = [_destroyactionName, "Destroy Note", GRAD_leaveNotes_moduleRoot + "\data\destroy.paa", {(_this select 2) call GRAD_leaveNotes_fnc_destroyNote}, {true}, {}, [_noteID]] call ace_interact_menu_fnc_createAction;
            _grandChildren pushBack [_destroyAction,[],_unit];

            _children pushBack [_action,_grandChildren,_unit];
        };
    } forEach (_unit getVariable ["grad_leaveNotes_notesArray",[]]);

    _children
};
private _mainAction = ["GRAD_leaveNotes_mainAction","Notes",GRAD_leaveNotes_moduleRoot + "\data\note.paa",{},_mainCondition,_mainChildren] call ace_interact_menu_fnc_createAction;
["CAManBase",1,["ACE_SelfActions","ACE_Equipment"],_mainAction,true] call ace_interact_menu_fnc_addActionToClass;

//add write action
private _writeCondition = {
    params ["",["_unit",objNull]];
    _unit getVariable ["GRAD_leaveNotes_canWriteNotes", GRAD_leaveNotes_canWriteDefault]
};
private _writeAction = ["GRAD_leaveNotes_writeNote", "Write Note", GRAD_leaveNotes_moduleRoot + "\data\write.paa", {[_this,GRAD_leaveNotes_fnc_writeNote] call GRAD_leaveNotes_fnc_delayedCall}, _writeCondition] call ace_interact_menu_fnc_createAction;
["CAManBase",1,["ACE_SelfActions","ACE_Equipment","GRAD_leaveNotes_mainAction"],_writeAction,true] call ace_interact_menu_fnc_addActionToClass;

// add give action
private _giveCondition = {
    params ["",["_unit",objNull]];
    ({!isNil "_x"} count (_unit getVariable ["grad_leaveNotes_notesArray", []])) > 0
};
private _giveChildren = {
    params ["",["_unit",objNull]];

    private _children = [];
    {
        if (!isNil "_x") then {
            _x params [["_message",""],["_handwriting",["somewhat",["small","PuristaLight"]]]];

            private _noteID = _forEachIndex;
            private _giveactionName = format ["GRAD_leaveNotes_myNotes_%1_give", _noteID];
            private _actionDisplayText = [_message] call GRAD_leaveNotes_fnc_generateName;
            _action = [_giveactionName, _actionDisplayText, GRAD_leaveNotes_moduleRoot + "\data\note.paa", {_this call GRAD_leaveNotes_fnc_giveNote}, {true}, {}, [_noteID, _message, _handwriting]] call ace_interact_menu_fnc_createAction;

            diag_log [74,_noteID,_giveactionName,_actionDisplayText,_unit,_action];
            _children pushBack [_action,[],_unit];
        };
    } forEach (_unit getVariable ["grad_leaveNotes_notesArray",[]]);

    _children
};
private _giveAction = ["GRAD_leaveNotes_mainGiveAction","Give note",GRAD_leaveNotes_moduleRoot + "\data\give.paa",{},_giveCondition] call ace_interact_menu_fnc_createAction;
["CAManBase",0,["ACE_MainActions"],_giveAction,true] call ace_interact_menu_fnc_addActionToClass;
