//add main selfinteraction node
private _mainCondition = {
    params ["",["_unit",objNull]];
    (_unit getVariable ["GRAD_leaveNotes_notesInInventory", 0]) > 0 ||
    {_unit getVariable ["GRAD_leaveNotes_canWriteNotes", GRAD_leaveNotes_canWriteDefault]}
};
private _mainAction = ["GRAD_leaveNotes_mainAction","Notes",GRAD_leaveNotes_moduleRoot + "\data\note.paa",{},_mainCondition] call ace_interact_menu_fnc_createAction;
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
    (_unit getVariable ["GRAD_leaveNotes_notesInInventory", 0]) > 0
};
private _giveAction = ["GRAD_leaveNotes_mainGiveAction","Give note",GRAD_leaveNotes_moduleRoot + "\data\give.paa",{},_giveCondition] call ace_interact_menu_fnc_createAction;
["CAManBase",0,["ACE_MainActions"],_giveAction,true] call ace_interact_menu_fnc_addActionToClass;
