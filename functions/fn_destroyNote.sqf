params ["_note",["_silent", false]];
if (isNil "_note") then {_note = player getVariable ["GRAD_leaveNotes_activeNote", objNull]};

//ground note
if (typeName _note == "OBJECT") then {
    if (isNull _note) exitWith {hint "Jemand ist mir zuvorgekommen."};
    deleteVehicle _note;
};

//inventory note
if (typeName _note == "SCALAR") then {
    [_note, "remove"] call GRAD_leaveNotes_fnc_updateMyNotes;
};

if (!_silent) then {
    _sounds = [
        "GRAD_leaveNotes_sounds_rip1",
        "GRAD_leaveNotes_sounds_rip2",
        "GRAD_leaveNotes_sounds_rip3",
        "GRAD_leaveNotes_sounds_rip4"
    ];
    [player, selectRandom _sounds] remoteExec ["say3D", 0, false];
};
