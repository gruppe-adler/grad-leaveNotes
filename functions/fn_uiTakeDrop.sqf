#include "..\dialog\defines.hpp"

_note = player getVariable ["GRAD_leaveNotes_activeNote", objNull];

//take
if (typeName _note == "OBJECT") then {
    if (isNull _note) exitWith {hint "Somebody already took it."};

    [_note, true] call GRAD_leaveNotes_fnc_destroyNote;
    _message = _note getVariable ["message", ""];
    _handwriting = _note getVariable ["handwriting", ["",["",""]]];
    [(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
};

//drop
if (typeName _note == "SCALAR") then {
    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _note];
    _message = player getVariable [_nodeName + "_message", ""];
    _handwriting = player getVariable [_nodeName + "_handwriting", ["", ["",""]]];
    [_note, "remove"]call GRAD_leaveNotes_fnc_updateMyNotes;
    [_message, _handwriting] call GRAD_leaveNotes_fnc_dropNote;
};
