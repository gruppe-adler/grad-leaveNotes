#define PREFIX grad
#define COMPONENT leaveNotes
#include "\x\cba\addons\main\script_macros_mission.hpp"
#include "..\dialog\defines.hpp"

params [["_mode", "UNDEFINED"],"_note","_message","_handwriting"];

disableSerialization;

switch (_mode) do {
  case "WRITE": {
    createDialog "GRAD_leaveNotes_write";
    _dialog = findDisplay LN_DIALOG;
    _notepad = _dialog displayCtrl LN_NOTEPAD;
    _editBox = _dialog displayCtrl LN_EDITBOX;

    _notepad ctrlSetText (GRAD_leaveNotes_moduleRoot + "\data\notepad.paa");

    if (GRAD_leaveNotes_visibleHandwriting) then {
        _handwriting = player getVariable ["GRAD_leaveNotes_handwriting", ["",["","TahomaB"]]];
        _handwriting params ["_modifier", "_type"];
        _editBox ctrlSetFont (_type select 1);
    };
  };

  case "READ": {
    createDialog "GRAD_leaveNotes_read";
    _dialog = findDisplay LN_DIALOG;
    _notepad = _dialog displayCtrl LN_NOTEPAD;
    _notepad ctrlSetText (GRAD_leaveNotes_moduleRoot + "\data\notepad.paa");
    _textBox = _dialog displayCtrl LN_TEXTBOX;
    _button2 = _dialog displayCtrl LN_BUTTON2;
    _button3 = _dialog displayCtrl LN_BUTTON3;
    //_message = "";
    //_note = player getVariable ["GRAD_leaveNotes_activeNote", objNull];

    if (typeName _note == "OBJECT") then {
        _button2 ctrlSetText "TAKE";
    };

    if (typeName _note == "SCALAR") then {
        _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _note];
        _button2 ctrlSetText "DROP";
    };

    if !(player getVariable ["GRAD_leaveNotes_canInspect", GRAD_leaveNotes_canInspectDefault]) then {
        _button3 ctrlShow false;
    };

    if (GRAD_leaveNotes_visibleHandwriting) then {
        _handwriting params ["_modifier", "_type"];
        _textBox ctrlSetFont (_type select 1);
    };

    _textBox ctrlSetText _message;

  };

  default {ERROR(format ["%1 is not a valid mode.", _mode])};
};
