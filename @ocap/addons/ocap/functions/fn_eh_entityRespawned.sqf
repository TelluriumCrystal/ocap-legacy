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
if (_oldEntity getVariable ["ocap_isInitialised", false] and  !(_oldEntity getVariable ["ocap_exclude", false])) then {

	// Set up new entity with old entity ID
	_newEntity setVariable ["ocap_isInitialised", true];
	_newEntity setVariable ["ocap_id", _oldEntity getVariable "ocap_id"];
	_newEntity setVariable ["ocap_exclude", false];
	_newEntity call ocap_fnc_addEventHandlers;

	// Exclude body/wreck from capture and remove event handlers
	_oldEntity setVariable ["ocap_exclude", true];
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
