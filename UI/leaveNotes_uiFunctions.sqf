/*  Functions that are called by UI controls
*
*/

#include "leaveNotes_defines.sqf";

//WRITE-MODE ===================================================================
GRAD_leaveNotes_fnc_uiDrop = {
  disableSerialization;
  _dialog = findDisplay LN_DIALOG;
  _editBox = _dialog displayCtrl LN_EDITBOX;
  _message = ctrlText _editBox;
  [_message] call GRAD_leaveNotes_fnc_dropNote;
  player setVariable ["GRAD_leaveNotes_amount", (player getVariable ["GRAD_leaveNotes_amount", 1]) - 1];
};

GRAD_leaveNotes_fnc_uiSave = {
  disableSerialization;
  _dialog = findDisplay LN_DIALOG;
  _editBox = _dialog displayCtrl LN_EDITBOX;
  _message = ctrlText _editBox;
  [(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message] call GRAD_leaveNotes_fnc_updateMyNotes;
  player setVariable ["GRAD_leaveNotes_notesHandled", (player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1];
  player setVariable ["GRAD_leaveNotes_amount", (player getVariable ["GRAD_leaveNotes_amount", 1]) - 1];
};

//READ-MODE ====================================================================
GRAD_leaveNotes_fnc_uiTakeDrop = {
  _note = player getVariable ["GRAD_leaveNotes_activeNote", objNull];

  //take
  if (typeName _note == "OBJECT") then {
    if (isNull _note) exitWith {hint "Jemand ist mir zuvorgekommen."};

    [_note] call GRAD_leaveNotes_fnc_destroyNote;
    _message = _note getVariable ["message", ""];
    [(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message] call GRAD_leaveNotes_fnc_updateMyNotes;
    player setVariable ["GRAD_leaveNotes_notesHandled", (player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1];
  };

  //drop
  if (typeName _note == "SCALAR") then {
    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _note];
    _message = player getVariable [_nodeName + "_message", ""];
    [_note, "remove"]call GRAD_leaveNotes_fnc_updateMyNotes;
    [_message] call GRAD_leaveNotes_fnc_dropNote;
  };
};
