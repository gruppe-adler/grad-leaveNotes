params ["_unit","_modifier","_type"];

if (!isServer && !local _unit) exitWith {};

if (isNil "_modifier") then {
    _modifier = selectRandom [
        "somewhat",
        "quite",
        "remarkably"
    ];
};

if (isNil "_type") then {
    _type = selectRandom [
        "small",
        "fine",
        "sloppy",
        "messy",
        "angular",
        "elegant",
        "meticulous",
        "cramped",
        "bold"
    ];
};

private _font = switch (_type) do {
    case ("small"): {"PuristaLight"};
    case ("fine"): {"PuristaMedium"};
    case ("sloppy"): {"PuristaSemiBold"};
    case ("messy"): {"PuristaBold"};
    case ("angular"): {"LucidaConsoleB"};
    case ("elegant"): {"EtelkaMonospacePro"};
    case ("meticulous"): {"EtelkaMonospaceProBold"};
    case ("cramped"): {"EtelkaNarrowMediumPro"};
    case ("bold"): {"TahomaB"};
    default {"PuristaLight"};
};

_unit setVariable ["GRAD_leaveNotes_handwriting",[_modifier,[_type,_font]],true];
