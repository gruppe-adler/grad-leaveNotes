params ["_actionName"];

_return = -1;

{
    _action = _x;
    _name = (_action select 3) select 0;

    if (_name == _actionName) exitWith {_return = _forEachIndex};
} forEach ace_interact_menu_inheritedActions;

_return
