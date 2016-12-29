params ["_unit","_amount"];
if (!isServer && !local _unit) exitWith {};

_unit setVariable ["GRAD_leaveNotes_amount", round _amount, true];
