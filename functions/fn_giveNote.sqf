params ["_target", "_caller", "_args"];
_args params ["_noteID", "_message", "_handwriting"];

[_noteID, "remove", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
[_target, _caller, _message, _handwriting] remoteExec ["GRAD_leaveNotes_fnc_receiveNote",0,false];
[] call GRAD_leaveNotes_fnc_playGiveAnimation;
