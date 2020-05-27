params ["_target", "_caller", "_message", "_handwriting"];

if (ACE_player != _target) exitWith {};

hint format ["You have received a note from %1.", name _caller];
[(ACE_player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1,"add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
