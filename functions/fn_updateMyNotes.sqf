if (!hasInterface) exitWith {};
params ["_noteID", "_mode", ["_message", ""], ["_handwriting", ["",["",""]]]];

if (isNil {ACE_player getVariable "grad_leaveNotes_notesArray"}) then {ACE_player setVariable ["grad_leaveNotes_notesArray",[],true]};
private _unitNotesArray = ACE_player getVariable ["grad_leaveNotes_notesArray",[]];

//remove note
if (_mode == "remove") then {
    _unitNotesArray set [_noteID,nil];
    ACE_player setVariable ["grad_leaveNotes_notesArray",_unitNotesArray,true];
};

//add note
if (_mode == "add") then {
    _unitNotesArray pushBack [_message,_handwriting];
    ACE_player setVariable ["grad_leaveNotes_notesArray",_unitNotesArray,true];
};
