/*
	Function: ocap_fnc_eh_mpHit

	Description:
	Event handler for "MPHit". Builds a capture string for an entity being hit
	and adds it to the capture array.

	Parameters:
	_unit = [OBJECT] Unit damaged
	_causedBy = [OBJECT] Entity that caused the damage
	_damage = [DBL] Level of damage caused by the hit
	_instigator = [OBJECT] Person that pulled the trigger

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_unit", "_causedBy", "_damage", "_instigator"];

// Only run on server
if (isServer) then {
	// Check if entity is initiliased with OCAP and isn't marked as excluded from capture
	if (ocap_enableCapture and _unit getVariable ["ocap_isInitialised", false] and  !(_unit getVariable ["ocap_exclude", false])) then {

		// Get relevant data for capture
		private _timestamp = time;
		private _unitId = _unit getVariable "ocap_id";
		private _instigatorId = "";

		// Get instigator ID if instigator exists
		if (!isNull _instigator) then {_instigatorId = _instigator getVariable "ocap_id"};

		// Build capture string
		private _captureString = format ["8;%1;%2;%3", _timestamp, _unitId, _instigatorId];

		// Append capture string to capture array
		ocap_captureArray pushBack _captureString;

		// Debug message
		if (ocap_debug) then {
			private _unitName = "";
			if (_unit isKindOf "CAManBase") then {
				_unitName = name _unit;
			} else {
				_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
			};
			systemChat format["OCAP: [%1] %2 (%3) was hit by %4 (%5)", _timestamp, _unitName, _unitId, name _instigator, _instigatorId];
			diag_log format["OCAP: [%1] %2 (%3) was hit by %4 (%5)", _timestamp, _unitName, _unitId, name _instigator, _instigatorId];
		};
	};
};

nil
