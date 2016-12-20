#include "..\dialog\defines.hpp"

disableSerialization;
_dialog = findDisplay LN_DIALOG;
_editBox = _dialog displayCtrl LN_EDITBOX;
_message = ctrlText _editBox;
[(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message] call GRAD_leaveNotes_fnc_updateMyNotes;
player setVariable ["GRAD_leaveNotes_notesHandled", (player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1];
player setVariable ["GRAD_leaveNotes_amount", (player getVariable ["GRAD_leaveNotes_amount", 1]) - 1];
