#include "..\dialog\defines.hpp"

disableSerialization;
private _dialog = findDisplay LN_DIALOG;
private _editBox = _dialog displayCtrl LN_EDITBOX;
private _message = ctrlText _editBox;
private _handwriting = ACE_player getVariable ["GRAD_leaveNotes_handwriting",["",["",""]]];

[_message, _handwriting] call GRAD_leaveNotes_fnc_dropNote;
ACE_player setVariable ["GRAD_leaveNotes_amount", (ACE_player getVariable ["GRAD_leaveNotes_amount", 1]) - 1];
