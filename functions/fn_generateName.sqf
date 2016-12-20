params ["_message"];
if (_message == "") exitWith {_name = "Empty Note"; _name};

_maxChars = 10;
_name = "";
_done = false;
_words = _message splitString " ";

//add first word
if (count (_words select 0) < _maxChars) then {
    _name = _name + (_words select 0);

//first word is too big
} else {
    _firstWordArray = toArray (_words select 0);
    _firstWordArray resize _maxChars;
    _name = toString _firstWordArray;
    _name = _name + "...";
};
if (count _name >= _maxChars) exitWith {_name};

//add more words
for [{_i = 1}, {_i < count _words}, {_i = _i + 1}] do {
    _word = _words select _i;
    if (count _name + count _word < _maxChars) then {
        _name = _name + " " + _word;
    } else {
        _name = _name + "...";
        _done = true;
    };
    if (_done) exitWith {};
};
_name
