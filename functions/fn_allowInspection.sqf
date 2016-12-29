params ["_unit","_allow"];
if (!isServer && !local _unit) exitWith {};

_unit setVariable ["GRAD_leaveNotes_canInspect", _allow, true];
