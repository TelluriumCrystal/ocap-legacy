/*
	Function: ocap_fnc_init

	Description:
	Initialises OCAP global variables and mission event handlers.
	Capture loop is automatically started once init completes.
	
	Paramaters:
	_logic = [OBJECT] Module settings
	_units = [LIST] List of affected units
	_activated = [BOOL] True if the module is activated
	
	Returns:
	[BOOL] Value of '_activated', indicates if init was executed
	
	Author: MisterGoodson, TelluriumCrystal
*/

// Get Module settings
_this params ["_logic", "_units", "_activated"];

if(_activated and isServer) then {

	// Define global variables
	ocap_exportPath = _logic getVariable "ExportPath";                          // Absolute path the mission.data file will be exported to
	ocap_captureDelay = _logic getVariable "CaptureDelay";                      // Minimum delay between each capture, may be exceeded if number of entities is high or scheduler is overloaded
	ocap_endCaptureOnNoPlayers = _logic getVariable "EndCaptureOnNoPlayers";    // Enables/disables automatic export if all players leave the server
	ocap_endCaptureOnEndMission = _logic getVariable "EndCaptureOnEndMission";  // Enables/disables automatic export when the mission ends
	ocap_debug = _logic getVariable "DebugMode";                                // Enables/disables verbose debug logging

	// Use CBA setting export path if module path is empty
	if (ocap_exportPath == "") then {
		ocap_exportPath = ocap_ModuleInit_ExportPath_default;
	};
	
	// Add mission event handlers
	ocap_entityKilled_MEH = addMissionEventHandler ["EntityKilled", {_this call ocap_fnc_eh_entityKilled}];
	
	// Transfer ID from old unit to new unit
	// Mark old body to now be excluded from capture
	ocap_meh_entityRespawned = addMissionEventHandler ["EntityRespawned", {
		_newEntity = _this select 0;
		_oldEntity = _this select 1;

		if (_oldEntity getVariable ["ocap_isInitialised", false]) then {
			_newEntity setVariable ["ocap_isInitialised", true];
			_id = _oldEntity getVariable "ocap_id";
			_newEntity setVariable ["ocap_id", _id];
			_newEntity setVariable ["ocap_exclude", false];
			_oldEntity setVariable ["ocap_exclude", true]; // Exclude old body from capture

			_newEntity call ocap_fnc_addEventHandlers;
		};
	}];

	ocap_meh_handleDisconnect = addMissionEventHandler["HandleDisconnect", {
		_unit = _this select 0;
		_name = _this select 3;

		if (_unit getVariable ["ocap_isInitialised", false]) then {
			_unit setVariable ["ocap_exclude", true];
		};

		_name call ocap_fnc_eh_disconnected;
	}];

	ocap_meh_playerConnected = addMissionEventHandler["PlayerConnected", {
		_name = _this select 2;

		_name call ocap_fnc_eh_connected;
	}];

	ocap_meh_ended = nil;
	if (ocap_endCaptureOnEndMission) then {
		ocap_ended_MEH = addMissionEventHandler ["Ended", {
			["Mission ended."] call ocap_fnc_log;
			[] call ocap_fnc_exportData;
		}];
	};

	[] spawn ocap_fnc_startCaptureLoop;
};

// Return state of _activated - indicates if init ran or not
_activated
