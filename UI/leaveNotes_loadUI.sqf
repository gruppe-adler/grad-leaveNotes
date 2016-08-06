/*  Loads GUI in read or write mode
*
*/

#include "leaveNotes_defines.sqf";
#define FILEPATH GRAD_leaveNotes_filePath
params [["_mode", "UNDEFINED"]];

disableSerialization;

switch (_mode) do {
  case "WRITE": {
    createDialog "leaveNotes_write";
    _dialog = findDisplay LN_DIALOG;
    _notepad = _dialog displayCtrl LN_NOTEPAD;
    _notepad ctrlSetText (FILEPATH + "UI\pic\notepad.paa");
  };

  case "READ": {
    createDialog "leaveNotes_read";
    _dialog = findDisplay LN_DIALOG;
    _notepad = _dialog displayCtrl LN_NOTEPAD;
    _notepad ctrlSetText (FILEPATH + "UI\pic\notepad.paa");
    _textBox = _dialog displayCtrl LN_TEXTBOX;
    _button2 = _dialog displayCtrl LN_BUTTON2;
    _message = "";
    _note = player getVariable ["GRAD_leaveNotes_activeNote", objNull];

    if (typeName _note == "OBJECT") then {
      _message = _note getVariable ["message", ""];
      _button2 ctrlSetText "TAKE";
    };

    if (typeName _note == "SCALAR") then {
      _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _note];
      _message = player getVariable [_nodeName + "_message", ""];
      _button2 ctrlSetText "DROP";
    };

    _textBox ctrlSetText _message;

  };

  default {diag_log format ["leaveNotes_loadUI.sqf - ERROR: %1 is not a valid mode.", _mode]};
};
