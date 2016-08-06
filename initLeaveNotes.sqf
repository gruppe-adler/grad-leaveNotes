/*  Initializes GRAD note leaving system
*
*   needs to be executed on both server and clients
*/

/*(([player, [], ["ACE_SelfActions", "GRAD_leaveNotes_myNotesMain"], 0] call ace_interact_menu_fnc_collectActiveActionTree) select 1)*/

#define ISPUBLIC true
#define FILEPATH GRAD_leaveNotes_filePath

GRAD_core_getFileDirectory = {
    params ['_filePath', '_worldname'];

    _isMissionFileName = {
        _splitArray = _this splitString ".";
        (count _splitArray == 2) && (_worldname in _splitArray);
    };

    _filePathArray = _filePath splitString "\";
    _start = 0;
    {
        if (_x call _isMissionFileName) exitWith {
            _start = _forEachIndex + 1;
        };
    } forEach _filePathArray;

    _directoryCount = (count _filePathArray) - 1 - _start;
    _filePathArray = _filePathArray select [_start, _directoryCount];
    if (count _filePathArray > 0) then {_filePathArray pushBack ""};
    _filePathArray joinString "\";
};

FILEPATH = [__FILE__, worldname] call GRAD_core_getFileDirectory;

//CONFIG VALUES (YOU CAN CHANGE THESE!) ========================================
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
//==============================================================================



//prevent executing this twice on non-dedicated
if (!isNil "GRAD_leaveNotes_initialized") exitWith {};
GRAD_leaveNotes_initialized = true;

//ui functions
[] call compile preprocessFileLineNumbers (FILEPATH + "UI\leaveNotes_uiFunctions.sqf");

//add ACE-Selfinteraction
if (CANWRITENOTES) then {
  _action = ["GRAD_leaveNotes_mainAction", "Notes", ACTION_PIC_MYNOTES, {}, {true}] call ace_interact_menu_fnc_createAction;
  [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_writeNote", "Write note", ACTION_PIC_WRITE, {[] call GRAD_leaveNotes_fnc_writeNote}, {true}] call ace_interact_menu_fnc_createAction;
  [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;
};


//WRITE NOTE ===================================================================
GRAD_leaveNotes_fnc_writeNote = {
  ["WRITE"] execVM (FILEPATH + "UI\leaveNotes_loadUI.sqf");
};

//DROP NOTE ====================================================================
GRAD_leaveNotes_fnc_dropNote = {
  params ["_message"];
  if (surfaceIsWater getPos player) exitWith {hint "Ich kann im Wasser keine Notiz hinterlassen."};

  _notePos = player getRelPos [NOTEDISTANCETOPLAYER, 0];
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

  _action = ["GRAD_leaveNotes_readNoteGround", "Read note", ACTION_PIC_READ, {[(_this select 0) getVariable ["message", ""], (_this select 0)] call GRAD_leaveNotes_fnc_readNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_takeNoteGround", "Take note", ACTION_PIC_TAKE, {[_this select 0] call GRAD_leaveNotes_fnc_takeNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_destroyNoteGround", "Destroy note", ACTION_PIC_DESTROY, {[_this select 0] call GRAD_leaveNotes_fnc_destroyNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;
};

//READ NOTE ====================================================================
GRAD_leaveNotes_fnc_readNote = {
  params ["_message", "_note"];
  if (isNil "_note") exitWith {diag_log "GRAD_leaveNotes_fnc_readNote - ERROR: _note is nil."};
  if (typeName _note != "OBJECT" && typeName _note  != "SCALAR") exitWith {diag_log format ["GRAD_leaveNotes_fnc_readNote - ERROR: _note is %1, expected object or number.", typeName _note]};

  player setVariable ["GRAD_leaveNotes_activeNote", _note];
  ["READ"] execVM (FILEPATH + "UI\leaveNotes_loadUI.sqf");
};

//TAKE NOTE ====================================================================
GRAD_leaveNotes_fnc_takeNote = {
  params ["_note"];
  _message = _note getVariable ["message", ""];
  deleteVehicle _note;

  [(player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1, "add", _message] call GRAD_leaveNotes_fnc_updateMyNotes;
  player setVariable ["GRAD_leaveNotes_notesHandled", (player getVariable ["GRAD_leaveNotes_notesHandled", 0]) + 1];
};

//UPDATE MY NOTES ==============================================================
GRAD_leaveNotes_fnc_updateMyNotes = {
  if (!hasInterface) exitWith {};
  params ["_noteID", "_mode", ["_message", ""]];

  //remove note
  if (_mode == "remove") then {
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 1]) - 1];

    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    _readactionName = _nodeName + "_read";
    _dropactionName = _nodeName + "_drop";
    _destroyactionName = _nodeName + "_destroy";

    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName, _readactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName, _dropactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName, _destroyactionName]] call ace_interact_menu_fnc_removeActionFromObject;
    [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName]] call ace_interact_menu_fnc_removeActionFromObject;

    //remove main node
    if (!CANWRITENOTES && (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) == 0) then {
      [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction"]] call ace_interact_menu_fnc_removeActionFromObject;
    };
  };

  //add note
  if (_mode == "add") then {
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) + 1];
    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    player setVariable [_nodeName + "_message", _message];

    //add main node on first note
    if (!CANWRITENOTES && (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) == 1) then {
      _action = ["GRAD_leaveNotes_mainAction", "My notes", ACTION_PIC_MYNOTES, {}, {true}] call ace_interact_menu_fnc_createAction;
      [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };

    //node
    _actionDisplayText = format ["Note %1", _noteID];
    _action = [_nodeName, _actionDisplayText, "", {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;

    //read
    _readactionName = _nodeName + "_read";
    _readAction = compile format ["[player getVariable ['GRAD_leaveNotes_myNotes_%1_message', ''], %1] call GRAD_leaveNotes_fnc_readNote", _noteID];
    _action = [_readactionName, "Read note", ACTION_PIC_READ, _readAction, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //drop
    _dropactionName = _nodeName + "_drop";
    _dropAction = compile format ["[player getVariable ['GRAD_leaveNotes_myNotes_%1_message', '']] call GRAD_leaveNotes_fnc_dropNote; [%1, 'remove'] call GRAD_leaveNotes_fnc_updateMyNotes", _noteID];
    _action = [_dropactionName, "Drop note", ACTION_PIC_LEAVENOTE, _dropAction, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //destroy
    _destroyactionName = _nodeName + "_destroy";
    _destroyAction = compile format ["[%1, 'remove'] call GRAD_leaveNotes_fnc_updateMyNotes", _noteID];
    _action = [_destroyactionName, "Destroy note", ACTION_PIC_DESTROY, _destroyAction, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;
  };
};

//DESTROY NOTE =================================================================
GRAD_leaveNotes_fnc_destroyNote = {
  params ["_note"];
  if (isNil "_note") then {_note = player getVariable ["GRAD_leaveNotes_activeNote", objNull]};

  //ground note
  if (typeName _note == "OBJECT") then {
    if (isNull _note) exitWith {hint "Jemand ist mir zuvorgekommen."};
    deleteVehicle _note;
  };

  //inventory note
  if (typeName _note == "SCALAR") then {
    [_note, "remove"] call GRAD_leaveNotes_fnc_updateMyNotes;
  };
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
