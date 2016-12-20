if ((player getVariable ["GRAD_leaveNotes_amount", 0 ]) <= 0) exitWith {hint "I'm out of paper."};
["WRITE"] call GRAD_leaveNotes_fnc_loadUI;
