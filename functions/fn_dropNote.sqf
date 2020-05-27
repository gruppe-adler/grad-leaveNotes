params ["_message", "_handwriting"];
if (surfaceIsWater getPos ACE_player) exitWith {
    [(ACE_player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
    hint "It would get wet here. Your note has been saved instead.";
};

private _notePos = ACE_player getRelPos [grad_leaveNotes_playerDistance, 0];
[_notePos, (getDir ACE_player)-90, _message, _handwriting] remoteExec ["GRAD_leaveNotes_fnc_spawnNote", 2, false];
