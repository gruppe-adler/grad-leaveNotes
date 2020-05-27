params ["",["_unit",objNull]];

if ((_unit getVariable ["GRAD_leaveNotes_amount",0]) <= 0) exitWith {hint "I'm out of paper."};

// in case unit is remote controlled
if (isNil {_unit getVariable "GRAD_leaveNotes_handwriting"}) then {
    [_unit] call GRAD_leaveNotes_fnc_setHandwriting;
};

["WRITE",nil,nil,nil,_unit] call GRAD_leaveNotes_fnc_loadUI;
