/*
	Function: ocap_fnc_exportData

	Description:
	Exports all current capture strings to the temp file, then builds and exports
	the footer capture strings. Next it tells the extension to export the temp file to
	its final location and deletes the local copy. Finally, all event handlers are removed,
	the main capture loop is terminated, and all missionNamespace variables are deinstantiated.

	Note that this is a terminal function. OCAP must be reinitalized to resume capturing
	data.

	Params:
	None

	Returns:
	nil

	Author: TelluriumCrystal
*/

// Log that export is starting
diag_log "OCAP: exporting all data to remote folder";

// Export all data to remote folder
2 call ocap_fnc_callExtension;
3 call ocap_fnc_callExtension;
0 call ocap_fnc_callExtension;

// Terminate main capture loop
terminate ocap_mainLoop;

// Remove all event handlers
{
	removeMissionEventHandler [_x select 0, _x select 1];
} forEach ocap_missionEHs;
{
	private _unit = _x;
	if (_unit getVariable ["ocap_isInitialised", false]) then {
		{
			_unit removeEventHandler _x;
		} forEach (_unit getVariable "ocap_eventHandlers");
		{
			_unit removeMPEventHandler _x;
		} forEach (_unit getVariable "ocap_MPeventHandlers");
		_unit setVariable ["ocap_isInitialised", nil];
		_unit setVariable ["ocap_exclude", nil];
		_unit setVariable ["ocap_id", nil];
		_unit setVariable ["ocap_eventHandlers", nil];
	};
} forEach (allUnits + allDead + (entities "LandVehicle") + (entities "Ship") + (entities "Air"));
if (!isNil {ocap_eh_aceUnconscious}) then {
	["ace_unconscious", ocap_eh_aceUnconscious] call CBA_fnc_removeEventHandler;
};

// Uninstantiate all global variables
ocap_version = nil;
ocap_enableCapture = nil;
ocap_moduleEnableCapture = nil;
ocap_captureArray = nil;
ocap_exportPath = nil;
ocap_captureDelay = nil;
ocap_endCaptureOnNoPlayers = nil;
ocap_endCaptureOnEndMission = nil;
ocap_debug = nil;
ocap_missionEHs = nil;
ocap_eh_aceUnconscious = nil;
ocap_mainLoop = nil;

// Log that OCAP is now shut down
diag_log "OCAP: exporting complete and OCAP has shut down";

nil
