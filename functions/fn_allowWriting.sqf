params ["_unit","_allow"];
if (!isServer && !local _unit) exitWith {};

_unit setVariable ["GRAD_leaveNotes_canWriteNotes", _allow, true];
