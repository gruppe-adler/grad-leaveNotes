params ["_handwriting"];

_texts = [
    "This note has a %1 %2 handwriting.",
    "The handwriting on this note is %1 %2.",
    "The author of this note has %1 %2 handwriting.",
    "The letters on this note are %1 %2."
];

hint format [selectRandom _texts, _handwriting select 0, _handwriting select 1];