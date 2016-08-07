/*  Initializes GRAD note leaving system
*
*   needs to be executed on both server and clients
*/

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
#ifndef LEAVENOTES_CANWRITENOTES
  #define LEAVENOTES_CANWRITENOTES true                                         //condition to be able to write notes
  #define LEAVENOTES_UNLIMITED true                                             //can write unlimited amount of notes
  #define LEAVENOTES_AMOUNT 10                                                  //amount of notes per player (irrelevant if LEAVENOTES_UNLIMITED)
  #define LEAVENOTES_PLAYERDIST 1                                               //distance to player that notes will be dropped
  #define LEAVENOTES_CLASS "Land_Notepad_F"                                     //note object class name
  #define LEAVENOTES_ACTOFFSET [0,0,0.1]                                        //interaction point offset to notepad object
  #define LEAVENOTES_ACTDIST 2                                                  //interaction distance
  #define LEAVENOTES_SLEEPTIME 0.1                                              //sleeptime between interaction and creation of dialog (ACE-interact-menu would stay open sometimes)
#endif

#ifndef LEAVENOTES_ACTPIC_WRITE
  #define LEAVENOTES_ACTPIC_WRITE (FILEPATH + "UI\pic\write.paa")               //"write note" action picture path
  #define LEAVENOTES_ACTPIC_READ (FILEPATH + "UI\pic\read.paa")                 //"read note" action picture path
  #define LEAVENOTES_ACTPIC_TAKE "\A3\ui_f\data\igui\cfg\actions\take_ca.paa"   //"take note" action picture path
  #define LEAVENOTES_ACTPIC_DROP (FILEPATH + "UI\pic\drop.paa")                 //"drop note" action picture path
  #define LEAVENOTES_ACTPIC_DESTROY (FILEPATH + "UI\pic\destroy.paa")           //"destroy note" action picture path
  #define LEAVENOTES_ACTPIC_MYNOTES (FILEPATH + "UI\pic\note.paa")              //"my notes" action-node picture path
#endif
//==============================================================================

//prevent executing this twice on non-dedicated
if (!isNil "GRAD_leaveNotes_initialized") exitWith {};
GRAD_leaveNotes_initialized = true;

//ui functions
[] call compile preprocessFileLineNumbers (FILEPATH + "UI\leaveNotes_uiFunctions.sqf");


//add ACE-Selfinteraction
[] spawn {
  if (!hasInterface) exitWith {};
  waitUntil {!isNull player};
  if (LEAVENOTES_CANWRITENOTES) then {
    player setVariable ["GRAD_leaveNotes_amount", LEAVENOTES_AMOUNT];

    _action = ["GRAD_leaveNotes_mainAction", "Notes", LEAVENOTES_ACTPIC_MYNOTES, {}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;

    _action = ["GRAD_leaveNotes_writeNote", "Write Note", LEAVENOTES_ACTPIC_WRITE, {[] spawn GRAD_leaveNotes_fnc_writeNote}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;
  };
};


//WRITE NOTE ===================================================================
GRAD_leaveNotes_fnc_writeNote = {
  sleep LEAVENOTES_SLEEPTIME;
  if (!LEAVENOTES_UNLIMITED && (player getVariable ["GRAD_leaveNotes_amount", 0 ]) <= 0) exitWith {hint "Ich habe kein Papier mehr."};
  ["WRITE"] execVM (FILEPATH + "UI\leaveNotes_loadUI.sqf");
};

//DROP NOTE ====================================================================
GRAD_leaveNotes_fnc_dropNote = {
  params ["_message"];
  if (surfaceIsWater getPos player) exitWith {hint "Ich kann im Wasser keine Notiz hinterlassen."};

  _notePos = player getRelPos [LEAVENOTES_PLAYERDIST, 0];
  [_notePos, (getDir player)-90, _message] remoteExec ["GRAD_leaveNotes_fnc_spawnNote", 2, false];
};

//INIT NOTE ====================================================================
GRAD_leaveNotes_fnc_initNote = {
  params ["_note"];
  if (!hasInterface) exitWith {};
  if (isNil "_note") exitWith {};
  if (isNull _note) exitWith {};

  //add ACE-actions
  _action = ["GRAD_leaveNotes_mainActionGround", "Interactions", "", {}, {true}, {}, [], LEAVENOTES_ACTOFFSET, LEAVENOTES_ACTDIST] call ace_interact_menu_fnc_createAction;
  [_note, 0, [], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_readNoteGround", "Read Note", LEAVENOTES_ACTPIC_READ, {[(_this select 0) getVariable ["message", ""], (_this select 0)] spawn GRAD_leaveNotes_fnc_readNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_takeNoteGround", "Take Note", LEAVENOTES_ACTPIC_TAKE, {[_this select 0] call GRAD_leaveNotes_fnc_takeNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;

  _action = ["GRAD_leaveNotes_destroyNoteGround", "Destroy Note", LEAVENOTES_ACTPIC_DESTROY, {[_this select 0] call GRAD_leaveNotes_fnc_destroyNote}, {true}] call ace_interact_menu_fnc_createAction;
  [_note, 0, ["GRAD_leaveNotes_mainActionGround"], _action] call ace_interact_menu_fnc_addActionToObject;
};

//READ NOTE ====================================================================
GRAD_leaveNotes_fnc_readNote = {
  params ["_message", "_note"];
  if (isNil "_note") exitWith {diag_log "GRAD_leaveNotes_fnc_readNote - ERROR: _note is nil."};
  if (typeName _note != "OBJECT" && typeName _note  != "SCALAR") exitWith {diag_log format ["GRAD_leaveNotes_fnc_readNote - ERROR: _note is %1, expected object or number.", typeName _note]};

  sleep LEAVENOTES_SLEEPTIME;
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

//GENERATE NOTE NAME ===========================================================
GRAD_leaveNotes_fnc_generateName = {
  params ["_message"];
  if (_message == "") exitWith {_name = "Empty Note"; _name};

  _maxChars = 10;
  _name = "";
  _done = false;
  _words = _message splitString " ";

  //add first word
  if (count (_words select 0) < _maxChars) then {
    _name = _name + (_words select 0);

  //first word is too big
  } else {
    _firstWordArray = toArray (_words select 0);
    _firstWordArray resize _maxChars;
    _name = toString _firstWordArray;
    _name = _name + "...";
  };
  if (count _name >= _maxChars) exitWith {_name};

  //add more words
  for [{_i = 1}, {_i < count _words}, {_i = _i + 1}] do {
    _word = _words select _i;
    if (count _name + count _word < _maxChars) then {
      _name = _name + " " + _word;
    } else {
      _name = _name + "...";
      _done = true;
    };
    if (_done) exitWith {};
  };
  _name
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
    if (!LEAVENOTES_CANWRITENOTES && (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) == 0) then {
      [player,1,["ACE_SelfActions", "GRAD_leaveNotes_mainAction"]] call ace_interact_menu_fnc_removeActionFromObject;
    };
  };

  //add note
  if (_mode == "add") then {
    player setVariable ["GRAD_leaveNotes_notesInInventory", (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) + 1];
    _nodeName = format ["GRAD_leaveNotes_myNotes_%1", _noteID];
    player setVariable [_nodeName + "_message", _message];

    //add main node on first note
    if (!LEAVENOTES_CANWRITENOTES && (player getVariable ["GRAD_leaveNotes_notesInInventory", 0]) == 1) then {
      _action = ["GRAD_leaveNotes_mainAction", "My notes", LEAVENOTES_ACTPIC_MYNOTES, {}, {true}] call ace_interact_menu_fnc_createAction;
      [player, 1, ["ACE_SelfActions"], _action] call ace_interact_menu_fnc_addActionToObject;
    };

    //node
    _actionDisplayText = [_message] call GRAD_leaveNotes_fnc_generateName;
    _action = [_nodeName, _actionDisplayText, "", {true}, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction"], _action] call ace_interact_menu_fnc_addActionToObject;

    //read
    _readactionName = _nodeName + "_read";
    _readAction = compile format ["[player getVariable ['GRAD_leaveNotes_myNotes_%1_message', ''], %1] spawn GRAD_leaveNotes_fnc_readNote", _noteID];
    _action = [_readactionName, "Read Note", LEAVENOTES_ACTPIC_READ, _readAction, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //drop
    _dropactionName = _nodeName + "_drop";
    _dropAction = compile format ["[player getVariable ['GRAD_leaveNotes_myNotes_%1_message', '']] call GRAD_leaveNotes_fnc_dropNote; [%1, 'remove'] call GRAD_leaveNotes_fnc_updateMyNotes", _noteID];
    _action = [_dropactionName, "Drop Note", LEAVENOTES_ACTPIC_DROP, _dropAction, {true}] call ace_interact_menu_fnc_createAction;
    [player, 1, ["ACE_SelfActions", "GRAD_leaveNotes_mainAction", _nodeName], _action] call ace_interact_menu_fnc_addActionToObject;

    //destroy
    _destroyactionName = _nodeName + "_destroy";
    _destroyAction = compile format ["[%1, 'remove'] call GRAD_leaveNotes_fnc_updateMyNotes", _noteID];
    _action = [_destroyactionName, "Destroy Note", LEAVENOTES_ACTPIC_DESTROY, _destroyAction, {true}] call ace_interact_menu_fnc_createAction;
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
  params ["_requestedPos", "_requestedDir", "_message"];

  _note = createVehicle [LEAVENOTES_CLASS, _requestedPos, [], 0, "NONE"];
  _note setPos _requestedPos;
  _note setVectorUp surfaceNormal _requestedPos;
  _note setDir _requestedDir;

  _note setVariable ["message", _message, true];

  [_note] remoteExec ["GRAD_leaveNotes_fnc_initNote", 0, true];
};
