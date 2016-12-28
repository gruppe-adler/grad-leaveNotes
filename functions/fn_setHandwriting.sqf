params ["_unit"];


_descriptors = [
    "cursive",
    "bold",
    "small",
    "fine",
    "shaky",
    "elegant",
    "sloppy",
    "messy"
];

_modifiers = [
    "very",
    "extraordinarily",
    "slightly",
    "somewhat",
    "quite",
    "remarkably"
];


_isPublic = !local _unit;
_handwriting = [selectRandom _modifiers, selectRandom _descriptors];
_unit setVariable ["GRAD_leaveNotes_handwriting", _handwriting, _isPublic];
