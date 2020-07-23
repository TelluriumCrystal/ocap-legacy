/*
	Function: ocap_fnc_eh_entityKilled

	Description:
	Mission event handler for "EntityKilled". Builds a capture string for an entity being killed
	and adds it to the capture array. Also disables tracking for the killed entity if it is not a
	vehicle.

	Paramaters:
	_victim = [OBJECT] Entity killed
	_killer = [OBJECT] Entity that killed the victim (vehicle or person)
	_instigator = [OBJECT] Person that pulled the trigger

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_victim", "_killer", "_instigator"];

// Check if entity is initiliased with OCAP and isn't marked as excluded from capture
if (ocap_enableCapture and _victim getVariable ["ocap_isInitialised", false] and  !(_victim getVariable ["ocap_exclude", false])) then {

	// Handle road kill special cases which would cause instigator to be null
	if (isNull _instigator) then {_instigator = UAVControl vehicle _killer select 0}; // UAV/UGV player operated road kill
	if (isNull _instigator) then {_instigator = _killer}; // Player driven vehicle road kill

	// Get relevant data for capture
	private _timestamp = time;
	private _victimId = _victim getVariable "ocap_id";
	private _instigatorId = "";

	// Get instigator ID if instigator exists
	if (!isNull _instigator) then {_instigatorId = _instigator getVariable "ocap_id"};

	// Build capture string
	private _captureString = format ["8;%1;%2;%3", _timestamp, _victimId, _instigatorId];

	// Append capture string to capture array
	ocap_captureArray pushBack _captureString;

	// Remove event handlers from victim
	{
		_victim removeEventHandler _x;
	} forEach (_victim getVariable "ocap_eventHandlers");

	// Exclude victim's corpse from tracking if victim is not a vehicle
	if (_victim isKindOf "CAManBase") then {
		_victim setVariable ["ocap_exclude", true];
	};

	// Debug message
	if (ocap_debug) then {
		private _victimName = "";
		if (_victim isKindOf "CAManBase") then {
			_victimName = name _victim;
		} else {
			_victimName = getText (configFile >> "CfgVehicles" >> typeOf _victim >> "displayName");
		};
		systemChat format["OCAP: [%1] %2 (%3) was killed by %4 (%5)", _timestamp, _victimName, _victimId, name _instigator, _instigatorId];
		diag_log format["OCAP: [%1] %2 (%3) was killed by %4 (%5)", _timestamp, _victimName, _victimId, name _instigator, _instigatorId];
	};
};

nil
