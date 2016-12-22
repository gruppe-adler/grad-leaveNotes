params ["_message", "_handwriting"];
if (surfaceIsWater getPos player) exitWith {
    [(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
    hint "It would get wet here. Your note has been saved instead.";
};

_notePos = player getRelPos [grad_leaveNotes_playerDistance, 0];
[_notePos, (getDir player)-90, _message, _handwriting] remoteExec ["GRAD_leaveNotes_fnc_spawnNote", 2, false];
