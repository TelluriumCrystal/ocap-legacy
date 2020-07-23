/*
	Function: ocap_fnc_eh_entityRespawned

	Description:
	Mission event handler for "EntityRespawned". Builds a capture string for an entity being respawned
	and adds it to the capture array. Also sets up the new entity for tracking and disables tracking on
	the old entity.

	Paramaters:
	_newEntity = [OBJECT] Respwaned entity
	_oldEntity = [OBJECT] Body/wreck

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_newEntity", "_oldEntity"];

// Check if entity is initiliased with OCAP and isn't marked as excluded from capture
if (ocap_enableCapture and _oldEntity getVariable ["ocap_isInitialised", false] and  !(_oldEntity getVariable ["ocap_exclude", false])) then {

	// If entity is a person, remove body from tracking and give new entity the same ocap ID
	// Otherwise let the main loop assign a new ID to the vehicle because we want to track the positions of vehicle wrecks
	if (_oldEntity isKindOf "CAManBase") then {
		_newEntity setVariable ["ocap_isInitialised", true];
		_newEntity setVariable ["ocap_id", _oldEntity getVariable "ocap_id"];
		_newEntity setVariable ["ocap_exclude", false];
		_newEntity call ocap_fnc_addEventHandlers;
	};

	// Remove event handlers from body/wreck
	{
		_oldEntity removeEventHandler _x;
	} forEach (_oldEntity getVariable "ocap_eventHandlers");

	// Get relevant data for capture
	private _timestamp = serverTime;
	private _entityId = _newEntity getVariable "ocap_id";

	// Build capture string
	private _captureString = format ["7;%1;%2", _timestamp, _entityId];

	// Append capture string to capture array
	ocap_captureArray pushBack _captureString;

	// Debug message
	if (ocap_debug) then {
		systemChat format["OCAP: [%1] %2 (%3) respawned", _timestamp, name _newEntity, _entityId];
		diag_log format["OCAP: [%1] %2 (%3) respawned", _timestamp, name _newEntity, _entityId];
	};
};

nil
