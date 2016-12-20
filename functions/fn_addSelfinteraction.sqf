//add main selfinteraction node
_mainCondition = {(player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) > 0 || {player getVariable ["GRAD_leaveNotes_canWriteNotes", GRAD_leaveNotes_canWriteDefault]}};
_action = ["GRAD_leaveNotes_mainAction", "Notes", GRAD_leaveNotes_moduleRoot + "\data\note.paa", {}, _mainCondition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions","ACE_Equipment"], _action] call ace_interact_menu_fnc_addActionToObject;

//add write action
_writeCondition = {player getVariable ["GRAD_leaveNotes_canWriteNotes", GRAD_leaveNotes_canWriteDefault]};
_action = ["GRAD_leaveNotes_writeNote", "Write Note", GRAD_leaveNotes_moduleRoot + "\data\write.paa", {[[],GRAD_leaveNotes_fnc_writeNote] call GRAD_leaveNotes_fnc_delayedCall}, _writeCondition] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "ACE_Equipment", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;
