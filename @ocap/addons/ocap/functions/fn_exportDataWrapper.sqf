/*
	Author: TelluriumCrystal

	Description:
	Wrapper for fn_exportData, allows calling from the Eden Editor module.
	
	Paramaters:
	_logic = [OBJECT] Module settings
	_units = [LIST] List of affected units
	_activated = [BOOL] Whether or not the module is activated
*/

// Get Module settings
_this params ["_logic", "_units", "_activated"];

// Call fn_exportData if activated
if (_activated) then {
	[] call ocap_fnc_exportData;
};
// Dummy return
true
