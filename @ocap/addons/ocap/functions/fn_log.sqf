/*
	Author: MisterGoodson, TelluriumCrystal

	Description:
	Logs supplied string to Arma RPT log file (with "OCAP" prefix).
*/

_this params ["_string", ["_displayHint", true]];

if (_displayHint) then {
	hint text ("OCAP: " + _string);
};

diag_log text ("OCAP: " + _string);