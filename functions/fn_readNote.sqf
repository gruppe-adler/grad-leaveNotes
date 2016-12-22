#define PREFIX grad
#define COMPONENT leaveNotes
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_message", "_note", ["_handwriting", ["",""]]];

if (isNil "_note") exitWith {ERROR("_note is nil.")};
if (typeName _note != "OBJECT" && typeName _note  != "SCALAR") exitWith {ERROR(format ["_note is %1, expected object or number.", typeName _note])};

if (typeName _note == "OBJECT") then {
    _message = _note getVariable ["message", ""];
};

if (typeName _note == "SCALAR") then {
    _message = player getVariable [_nodeName + "_message", ""];
};



player setVariable ["GRAD_leaveNotes_activeNote", _note];
["READ", _note, _message, _handwriting] call GRAD_leaveNotes_fnc_loadUI;
