/*
	Function: ocap_fnc_eh_gotIn

	Description:
	Mission event handler for "GetIn". Builds a capture string for an entity entering a vehicle
	and adds it to the capture array.

	Paramaters:
	_vehicle = [OBJECT] Vehicle the unit got in
	_role = [STR] Role the unit has assumed, can be "driver", "gunner" or "cargo"
	_unit = [OBJECT] Unit that entered the vehicle
	_turret = [LIST] Turret path

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_vehicle", "_role", "_unit", "_turret"];

// Check if unit and vehicle are initiliased with OCAP and neither is marked as excluded from capture
if (ocap_enableCapture and _unit getVariable ["ocap_isInitialised", false] and _vehicle getVariable ["ocap_isInitialised", false]
	and !(_unit getVariable ["ocap_exclude", false]) and !(_vehicle getVariable ["ocap_exclude", false])) then {

	// Get relevant data for capture
	private _timestamp = time;
	private _unitId = _unit getVariable "ocap_id";
	private _vehicleId = _vehicle getVariable "ocap_id";

	// Build capture string
	private _captureString = format ["5;%1;%2;%3;1", _timestamp, _unitId, _vehicleId];

	// Append capture string to capture array
	ocap_captureArray pushBack _captureString;

	// Debug message
	if (ocap_debug) then {
		private _vehicleName = getText (configFile >> "CfgVehicles" >> typeOf _x >> "displayName");
		systemChat format["OCAP: [%1] %2 (%3) got in %4 (%5)", _timestamp, name _unit, _crewId, _vehicleName, _vehicleId];
		diag_log format["OCAP: [%1] %2 (%3) got in %4 (%5)", _timestamp, name _unit, _crewId, _vehicleName, _vehicleId];
	};
};

nil
