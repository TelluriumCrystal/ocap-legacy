/*
	Function: ocap_fnc_init_wrapper

	Description:
	Wrapper for ocap_fnc_init. Spawned by OCAP init editor module.

	Paramaters:
	_logic = [OBJECT] Module settings
	_units = [LIST] List of affected units (unused)
	_activated = [BOOL] True if the module is activated

	Returns:
	nil

	Author: TelluriumCrystal
*/

// Get Module settings
_this params ["_logic", "", "_activated"];

if(_activated) then {

	private _ocap_exportPath = _logic getVariable "ExportPath";
	private _ocap_captureDelay = _logic getVariable "CaptureDelay";
	private _ocap_pauseCaptureOnNoPlayers = _logic getVariable "PauseCaptureOnNoPlayers";
	private _ocap_endCaptureOnEndMission = _logic getVariable "EndCaptureOnEndMission";
	private _ocap_debug = _logic getVariable "DebugMode";

	// Call ocap_fnc_init
	[_ocap_exportPath, _ocap_captureDelay, _ocap_pauseCaptureOnNoPlayers, _ocap_endCaptureOnEndMission, _ocap_debug] call ocap_fnc_init;
};

nil
