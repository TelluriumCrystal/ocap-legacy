/*
	Function: ocap_fnc_captureLoop

	Description:
	Main OCAP capture loop. Handles unit and vehicle initalization and position logging. Should
	catch JIP players and spawned units. Can be paused by setting ocap_enableCapture to false.
	Will automatically pause capture if ocap_pauseCaptureOnNoPlayers is true and player count is 0.
	Exports all capture data to the .data file at the end of each loop.

	Note that while this function is intended to run on the scheduler there are parts that must be
	executed atomically. These sections are forced to do so by using isNil {}.

	Paramaters:
	None

	Returns:
	nil

	Author: TelluriumCrystal
*/

// Scroll wheel commands for testing
if (ocap_debug) then {
	player addAction ["Write saved data", {[false] call ocap_fnc_exportData}];
	player addAction ["End mission", {endMission "end1"}];
	player addEventHandler ["Respawn", {
		player addAction ["Write saved data", {[false] call ocap_fnc_exportData}];
		player addAction ["End mission", {endMission "end1"}];
	}];
};

// Capture loop
private _id = 0;                  // Next available OCAP entity ID. Increments as IDs are assigned to entities.
private _captureStopped = false;  // Set true if capture was paused. Used to create log message that capture has resumed
while {true} do {

	// Inhibit capture until player count is > 0 and current module command state is play
	waitUntil {
		if (ocap_moduleEnableCapture && !(ocap_pauseCaptureOnNoPlayers and count allPlayers <= 0)) then {
			ocap_capture = true;
		} else {
			ocap_capture = false;
		};

		ocap_capture
	};

	// Log message if capture resumed after being stopped
	if (_captureStopped) then {
		_captureStopped = false;
		diag_log "OCAP: capture resumed";
	};

	// Debug logging of capture time
	private _captureStartTime = diag_tickTime;

	{   // forEach (allUnits + (entities "LandVehicle") + (entities "Ship") + (entities "Air"))

		if (!(_x getVariable ["ocap_exclude", false])) then {

			// Setup entity if not initialised
			if (!(_x getVariable ["ocap_isInitialised", false])) then {

				// Enter atomic block
				isNil {

					// Get entity info
					private _timestamp = time;
					private _entityId = _id;
					_id = _id + 1;
					private _entityType = 0; // 0 = AI, 1 = Player, 2 = Vehicle
					if (!(_x isKindOf "CAManBase")) then {
						_entityType = 2;
					} else {
						if (isPlayer _x) then {
							_entityType = 1;
						};
					};
					private _entityName = "";
					if (_entityType == 0 or _entityType == 1) then {
						_entityName = name _x;
					} else {
						_entityName = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
					};
					private _entityGroup = "";
					if (!isNull group _x) then {
						_entityGroup = groupID (group _x);
					};
					private _entitySide = (side _x) call BIS_fnc_sideID;
					private _vehicleType = "";
					if (_entityType == 2) then {
						_vehicleType = typeOf _x;
					};

					// Build capture string and append to capture array
					private _captureString = format ["3;%1;%2;%3;%4;%5;%6;%7", _timestamp, _entityId, _entityType, _entityName, _entityGroup, _entitySide, _vehicleType];
					ocap_captureArray pushBack _captureString;

					// Set entity variables and add event handlers
					_x setVariable ["ocap_isInitialised", true];
					_x setVariable ["ocap_exclude", false];
					_x setVariable ["ocap_id", _entityId];
					_x call ocap_fnc_addEventHandlers;

					// Handle case where units are already in a vehicle (do this in the vehicle init because vehicles should be initalized after units)
					if (_entityType == 2) then {

						{	// forEach (crew _x)
							if (_x getVariable ["ocap_isInitialised", false]) then {

								// Build enter vehicle capture string and append to capture array
								private _crewId = _x getVariable "ocap_id";
								private _captureString = format ["5;%1;%2;%3;1", _timestamp, _crewId, _entityId];
								ocap_captureArray pushBack _captureString;

								// Debug message
								if (ocap_debug) then {
									systemChat format["OCAP: [%1] %2 (%3) got in %4 (%5)", _timestamp, name _x, _crewId, _entityName, _entityId];
									diag_log format["OCAP: [%1] %2 (%3) got in %4 (%5)", _timestamp, name _x, _crewId, _entityName, _entityId];
								};
							};
						} forEach (crew _x);
					};

					// Debug message
					if (ocap_debug) then {
						systemChat format["OCAP: [%1] Initalized %2 (%3) in %4 on %5 side", _timestamp, _entityName, _entityId, _entityGroup, _entitySide call BIS_fnc_sideType];
						diag_log format["OCAP: [%1] Initalized %2 (%3) in %4 on %5 side", _timestamp, _entityName, _entityId, _entityGroup, _entitySide call BIS_fnc_sideType];
					};
				};
			};

			// Grab entity position and add to capture array
			// Enter atomic block
			isNil {
				private _timestamp = time;
				private _entityId = _x getVariable "ocap_id";
				private _entityRawASL = getPosASL _x;
				private _entityRawATL = getPosATL _x;
				private _entityPosX = _entityRawASL select 0;
				private _entityPosY = _entityRawASL select 1;
				private _entityElevASL = _entityRawASL select 2;
				private _entityElevAGL = _entityRawATL select 2;
				private _entityAzimuth = getDir _x;

				// Build capture string and append to capture array
				private _captureString = format ["4;%1;%2;%3;%4;%5;%6;%7", _timestamp, _entityId, _entityPosX, _entityPosY, _entityAzimuth, _entityElevASL, _entityElevAGL];
				ocap_captureArray pushBack _captureString;

				// Debug message
				if (ocap_debug) then {
					private _entityName = "";
					if (_x isKindOf "CAManBase") then {
						_entityName = name _x;
					} else {
						_entityName = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
					};
					diag_log format["OCAP: [%1] %2 (%3) is at [%4,%5] %6 ASL (%7 AGL) pointing at %8", _timestamp, _entityName, _entityId, _entityPosX, _entityPosY, _entityElevASL, _entityElevAGL, _entityAzimuth];
				};
			};
		};
	} forEach (allUnits + (entities "LandVehicle") + (entities "Ship") + (entities "Air"));

	// Export capture data to temp file
	2 call ocap_fnc_callExtension;

	// Debug message
	if (ocap_debug) then {
		private _timestamp = time;
		private _captureEndTime = diag_tickTime;
		private _captureDuration = _captureEndTime - _captureStartTime;
		systemChat format["OCAP: [%1] capture completed in %2s", _timestamp, _captureDuration];
		diag_log format["OCAP: [%1] capture completed in %2s", _timestamp, _captureDuration];
	};

	// Handle case where number of players <= 0
	if (ocap_pauseCaptureOnNoPlayers and count allPlayers <= 0) then {
		diag_log "OCAP: no players on server, pausing capture";
	};

	// Execute capture delay, if any
	if (ocap_captureDelay > 0) then {
		sleep ocap_captureDelay;
	};
};

nil
