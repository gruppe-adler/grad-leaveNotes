params ["_note",["_silent", false]];
if (isNil "_note") then {_note = ACE_player getVariable ["GRAD_leaveNotes_activeNote", objNull]};

//ground note
if (typeName _note == "OBJECT") then {
    if (isNull _note) exitWith {hint "Jemand ist mir zuvorgekommen."};
    deleteVehicle _note;
};

//inventory note
if (_note isEqualType 0) then {
    [_note,"remove"] call GRAD_leaveNotes_fnc_updateMyNotes;
};

if (!_silent) then {
    [ACE_player, selectRandom [
        "GRAD_leaveNotes_sounds_rip1",
        "GRAD_leaveNotes_sounds_rip2",
        "GRAD_leaveNotes_sounds_rip3",
        "GRAD_leaveNotes_sounds_rip4"
    ]] remoteExec ["say3D", 0, false];
};
