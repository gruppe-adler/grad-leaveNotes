params ["_unit"];

if (!isServer && !local _unit) exitWith {};

_types = [
    ["small","PuristaLight"],
    ["fine","PuristaMedium"],
    ["sloppy","PuristaSemiBold"],
    ["messy","PuristaBold"],
    ["angular","LucidaConsoleB"],
    ["elegant","EtelkaMonospacePro"],
    ["meticulous","EtelkaMonospaceProBold"],
    ["cramped","EtelkaNarrowMediumPro"],
    ["bold","TahomaB"]
];

_modifiers = [
    "somewhat",
    "quite",
    "remarkably"
];


_handwriting = [selectRandom _modifiers, selectRandom _types];
_unit setVariable ["GRAD_leaveNotes_handwriting", _handwriting, true];
