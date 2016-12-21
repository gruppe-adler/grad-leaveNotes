params ["_target", "_caller", "_args"];
_args params ["_noteID", "_message"];

[_noteID, "remove", _message] call GRAD_leaveNotes_fnc_updateMyNotes;
[_target, _caller, _message] remoteExec ["GRAD_leaveNotes_fnc_receiveNote",0,false];
[] call GRAD_leaveNotes_fnc_playGiveAnimation;
