#include "..\dialog\defines.hpp"

disableSerialization;
private _dialog = findDisplay LN_DIALOG;
private _editBox = _dialog displayCtrl LN_EDITBOX;
private _message = ctrlText _editBox;

private _noteID = (ACE_player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1;
private _handwriting = ACE_player getVariable ["GRAD_leaveNotes_handwriting",["", ["",""]]];

[_noteID, "add", _message, _handwriting] call GRAD_leaveNotes_fnc_updateMyNotes;
ACE_player setVariable ["GRAD_leaveNotes_amount", (ACE_player getVariable ["GRAD_leaveNotes_amount", 1]) - 1];
