#include "..\dialog\defines.hpp"

disableSerialization;
_dialog = findDisplay LN_DIALOG;
_editBox = _dialog displayCtrl LN_EDITBOX;
_message = ctrlText _editBox;

_noteID = (player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1;
_handwriting = player getVariable ["GRAD_leaveNotes_handwriting",["", ["",""]]];

[_noteID, "add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
player setVariable ["GRAD_leaveNotes_amount", (player getVariable ["GRAD_leaveNotes_amount", 1]) - 1];
