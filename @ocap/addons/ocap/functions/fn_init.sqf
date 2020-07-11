/*
	Author: MisterGoodson, TelluriumCrystal

	Description:
	Initialises OCAP variables and mission-wide eventhandlers.
	Capture loop is automatically started once init complete.
	
	Paramaters:
	_logic = [OBJECT] Module settings
	_units = [LIST] List of affected units
	_activated = [BOOL] Whether or not the module is activated
*/

// Get Module settings
_this params ["_logic", "_units", "_activated"];

if(_activated and isServer) then {

	// Define global vars
	ocap_capture = true;
	ocap_exportPath = _logic getVariable "ExportPath";
	ocap_frameCaptureDelay = _logic getVariable "FrameDelay";
	ocap_minPlayerCount = 0;
	ocap_endCaptureOnNoPlayers = _logic getVariable "EndCaptureOnNoPlayers";
	ocap_endCaptureOnEndMission = _logic getVariable "EndCaptureOnEndMission";
	ocap_debug = _logic getVariable "DebugMode";
	ocap_entitiesData = [];  // Data on all units + vehicles that appear throughout the mission.
	ocap_eventsData = [];    // Data on all events (involving 2+ units) that occur throughout the mission.
	ocap_captureFrameNo = 0; // Frame number for current capture
	ocap_endFrameNo = 0;     // Frame number at end of mission

	// Add mission EHs
	addMissionEventHandler ["EntityKilled", {
		_victim = _this select 0;
		_killer = _this select 1;

		// Check entity is initiliased with OCAP
		// TODO: Set ocap_exclude to true if unit is not going to respawn (e.g. AI)
		if (_victim getVariable ["ocap_isInitialised", false]) then {
			[_victim, _killer] call ocap_fnc_eh_killed;

			{
				_victim removeEventHandler _x;
			} forEach (_victim getVariable "ocap_eventHandlers");
		};
	}];

	// Transfer ID from old unit to new unit
	// Mark old body to now be excluded from capture
	addMissionEventHandler ["EntityRespawned", {
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

	addMissionEventHandler["HandleDisconnect", {
		_unit = _this select 0;
		_name = _this select 3;

		if (_unit getVariable ["ocap_isInitialised", false]) then {
			_unit setVariable ["ocap_exclude", true];
		};

		_name call ocap_fnc_eh_disconnected;
	}];

	addMissionEventHandler["PlayerConnected", {
		_name = _this select 2;

		_name call ocap_fnc_eh_connected;
	}];

	if (ocap_endCaptureOnEndMission) then {
		addMissionEventHandler ["Ended", {
			["Mission ended."] call ocap_fnc_log;
			[] call ocap_fnc_exportData;
		}];
	};

	[] spawn ocap_fnc_startCaptureLoop;
};

// Dummy function return
true