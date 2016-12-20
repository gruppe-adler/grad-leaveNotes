_startAmount = player getVariable "GRAD_leaveNotes_amount";
if (isNil "_startAmount") then {player setVariable ["GRAD_leaveNotes_amount", GRAD_leaveNotes_startAmount]};

_action = ["GRAD_leaveNotes_mainAction", "Notes", GRAD_leaveNotes_moduleRoot + "\data\note.paa", {}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

_action = ["GRAD_leaveNotes_writeNote", "Write Note", GRAD_leaveNotes_moduleRoot + "\data\write.paa", {[[],GRAD_leaveNotes_fnc_writeNote] call GRAD_leaveNotes_fnc_delayedCall}, {true}] call ace_interact_menu_fnc_createAction;
[player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;
