params ["_actionID"];

_action = ace_interact_menu_inheritedActions select _actionID;
_classes = _action select 0;

_classes
