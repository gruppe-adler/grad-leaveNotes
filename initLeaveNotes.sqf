/*  Initializes GRAD note leaving system
*
*   needs to be executed on both server and clients
*/

/*(([player, [], ["ACE_SelfActions", "GRAD_leaveNotes_myNotesMain"], 0] call ace_interact_menu_fnc_collectActiveActionTree) select 1)*/

#define CANWRITENOTES true
#define NOTEDISTANCETOPLAYER 1
#define CLASS_NOTE "Land_Notepad_F"
#define ACTION_PIC_WRITE ""
#define ACTION_PIC_READ ""
#define ACTION_PIC_TAKE ""
#define ACTION_PIC_LEAVENOTE ""
#define ACTION_PIC_DESTROY ""
#define ACTION_PIC_MYNOTES ""
#define ACTION_OFFSET [0,0,0.1]
#define ACTION_DISTANCE 2

//ADD ACE-SELFACTION ===========================================================
if (CANWRITENOTES) then {
  _action = ["GRAD_leaveNotes_mainAction", "Notes", ACTION_PIC_MYNOTES, {}, {true}] call ace_interact_menu_fnc_createAction;
  [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_writeNote", "Write note", ACTION_PIC_WRITE, {[] call GRAD_leaveNotes_fnc_writeNote}, {true}] call ace_interact_menu_fnc_createAction;
  [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;
};

//LEAVE NOTE ===================================================================
GRAD_leaveNotes_fnc_writeNote = {
  if (surfaceIsWater getPos player) exitWith {hint "Ich kann im Wasser keine Notiz hinterlassen."};

  _notePos = player getRelPos [NOTEDISTANCETOPLAYER, 0];
  _message = "KJLASJDKLJASJDKLJJASKLDJKLJASJND lkasdj lkasjdkl asdl kIOKJASodkjioasj od kals jdlk askldlasdaös dlk asdkl jlaks djlk AL J";

  [_notePos, _message] remoteExec ["GRAD_leaveNotes_fnc_spawnNote", 2, false];
};

//INIT NOTE ====================================================================
GRAD_leaveNotes_fnc_initNote = {
  params ["_note"];
  if (!hasInterface) exitWith {};
  if (isNil "_note") exitWith {};
  if (isNull _note) exitWith {};

  //add ACE-actions
  _action = ["GRAD_leaveNotes_mainActionGround", "Interactions", "", {}, {true}, {}, [], ACTION_OFFSET, ACTION_DISTANCE] call ace_interact_menu_fnc_createAction;
  [_note, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_readNoteGround", "Read note", ACTION_PIC_READ, {[_this select 0] call GRAD_leaveNotes_fnc_readNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_takeNoteGround", "Take note", ACTION_PIC_TAKE, {[_this select 0] call GRAD_leaveNotes_fnc_takeNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_destroyNoteGround", "Destroy note", ACTION_PIC_DESTROY, {[_this select 0] call GRAD_leaveNotes_fnc_destroyNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;
};

//READ NOTE ====================================================================
GRAD_leaveNotes_fnc_readNote = {
  params ["_note"];
  _message = _note getVariable ["message", "Die Notiz ist leer."];
  hint _message;
};

//TAKE NOTE ====================================================================
GRAD_leaveNotes_fnc_takeNote = {
  params ["_note"];
  _message = _note getVariable ["message", ""];
  deleteVehicle _note;

  if (isNil "GRAD_leaveNotes_myNotes") then {GRAD_leaveNotes_myNotes = []};
  if (isNil "GRAD_leaveNotes_notesHandled") then {GRAD_leaveNotes_notesHandled = 0};
  GRAD_leaveNotes_myNotes pushBack _message;
  [GRAD_leaveNotes_notesHandled, "add"] call GRAD_leaveNotes_fnc_updateMyNotes;
  GRAD_leaveNotes_notesHandled = GRAD_leaveNotes_notesHandled + 1;
};

//UPDATE MY NOTES ==============================================================
GRAD_leaveNotes_fnc_updateMyNotes = {
  if (!hasInterface) exitWith {};
  if (isNil "GRAD_leaveNotes_myNotes") exitWith {diag_log "GRAD_leaveNotes_fnc_updateMyNotes - ERROR: Player does not have any notes."};

  params ["_noteID", "_mode"];

  //remove note
  if (_mode == "remove") then {
    _actionName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    _readactionName = _actionName + "_read";
    _dropactionName = _actionName + "_drop";
    _destroyactionName = _actionName + "_destroy";

    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName, _readactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName, _dropactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName, _destroyactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName]] call ace_interact_menu_fnc_removeActionFromObject;

    //remove main node
    if (!CANWRITENOTES && (count GRAD_leaveNotes_myNotes) == 0) then {
      [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction"]] call ace_interact_menu_fnc_removeActionFromObject;
    };
  };

  //add note
  if (_mode == "add") then {
    //add main node on first note
    if (!CANWRITENOTES && (count GRAD_leaveNotes_myNotes) == 1) then {
      _action = ["GRAD_leaveNotes_mainAction", "My notes", ACTION_PIC_MYNOTES, {}, {true}] call ace_interact_menu_fnc_createAction;
      [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };

    //note node
    _actionName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    _actionDisplayText = format ["Note %1", _noteID+1];
    _action = [_actionName, _actionDisplayText, "", {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;

    //note actions
    _readactionName = _actionName + "_read";
    _dropactionName = _actionName + "_drop";
    _destroyactionName = _actionName + "_destroy";
    _action = [_readactionName, "Read note", ACTION_PIC_READ, {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = [_dropactionName, "Drop note", ACTION_PIC_LEAVENOTE, {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName], _action] call ace_interact_menu_fnc_addActionToObject;
    _action = [_destroyactionName, "Destroy note", ACTION_PIC_DESTROY, {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _actionName], _action] call ace_interact_menu_fnc_addActionToObject;
  };
};

//DESTROY NOTE THAT IS ON GROUND ===============================================
GRAD_leaveNotes_fnc_destroyNote = {
  params ["_note"];
  deleteVehicle _note;
};

//SPAWN NOTE ===================================================================
GRAD_leaveNotes_fnc_spawnNote = {
  params ["_requestedPos", "_message"];

  _note = createVehicle [CLASS_NOTE, _requestedPos, [], 0, "NONE"];
  _note setPos _requestedPos;
  _note setVectorUp surfaceNormal _requestedPos;

  _note setVariable ["message", _message, true];

  [_note] remoteExec ["GRAD_leaveNotes_fnc_initNote", 0, true];
};
