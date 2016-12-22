params ["_requestedPos", "_requestedDir", "_message", "_handwriting"];

_note = createVehicle [grad_leaveNotes_noteObject, _requestedPos, [], 0, "NONE"];
_note setPos _requestedPos;
_note setVectorUp surfaceNormal _requestedPos;
_note setDir _requestedDir;

_note setVariable ["message", _message, true];
_note setVariable ["handwriting", _handwriting, true];

[_note] remoteExec ["GRAD_leaveNotes_fnc_initNote", 0, true];
