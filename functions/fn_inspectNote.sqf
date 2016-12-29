private ["_handwriting"];
params ["_handwriting"];

if (isNil "_handwriting") then {
    _note = player getVariable ["GRAD_leaveNotes_activeNote", objNull];
    switch (typeName _note) do {
        case ("OBJECT"): {
            _handwriting = _note getVariable ["handwriting", ["",""]];
        };

        case ("SCALAR"): {
            _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _note];
            _handwriting = player getVariable [_nodeName + "_handwriting", ["", ""]];
        };

        default {
            _handwriting = ["",""];
        };
    };
};

_texts = [
    "This note has a %1 %2 handwriting.",
    "The handwriting on this note is %1 %2.",
    "The author of this note has %1 %2 handwriting.",
    "The letters on this note are %1 %2."
];

hint format [selectRandom _texts, _handwriting select 0, _handwriting select 1];
