params ["_message"];
if (surfaceIsWater getPos player) exitWith {hint "It would get wet here."};

_notePos = player getRelPos [grad_leaveNotes_playerDistance, 0];
[_notePos, (getDir player)-90, _message] remoteExec ["GRAD_leaveNotes_fnc_spawnNote", 2, false];
