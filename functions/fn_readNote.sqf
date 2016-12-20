#define PREFIX grad
#define COMPONENT leaveNotes
#include "\x\cba\addons\main\script_macros_mission.hpp"

params ["_message", "_note"];

diag_log str _this;

if (isNil "_note") exitWith {ERROR("_note is nil.")};
if (typeName _note != "OBJECT" && typeName _note  != "SCALAR") exitWith {ERROR(format ["_note is %1, expected object or number.", typeName _note])};

player setVariable ["GRAD_leaveNotes_activeNote", _note];
["READ"] call GRAD_leaveNotes_fnc_loadUI;
