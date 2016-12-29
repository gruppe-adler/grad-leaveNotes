params ["_note"];

_message = _note getVariable ["message", ""];
_handwriting = _note getVariable ["handwriting", ["",["",""]]];
deleteVehicle _note;

[(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
