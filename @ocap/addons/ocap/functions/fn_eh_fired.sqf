/*
	Function: ocap_fnc_eh_fired

	Description:
	Event handler for "Fired". Builds a capture string for an entity firing a weapon
	and stores that information on the bullet itself. A "EpeContact" event handler is
	then hooked up to detect when the bullet hits something.

	Parameters:
	_unit = [OBJECT] Unit that fired
	_weapon = [STR] Fired weapon
	_muzzle = [STR] Muzzle that was used
	_mode = [STR] Fire mod of fired weapon
	_ammo = [STR] Ammo fired
	_magazine = [STR] Magazine type that was used
	_projectile = [OBJECT] The projectile that was fired
	_gunner = [STR] Gunner whose weapon is firing
	
	Returns:
	nil
	
	Author: TelluriumCrystal
*/

_this params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];

// Check if entity is initiliased with OCAP and isn't marked as excluded from capture
if (ocap_enableCapture and _unit getVariable ["ocap_isInitialised", false] and  !(_unit getVariable ["ocap_exclude", false])) then {
	
	// Get relevant data for capture and set up impact event handler
	private _timestamp = time;
	private _unitId = _unit getVariable "ocap_id";
	private _unitRawASL = getPosASL _unit;
	private _unitPosX = _unitRawASL select 0;
	private _unitPosY = _unitRawASL select 1;
	private _impactEventHandler = _projectile addEventHandler ["EpeContact", {_this call ocap_fnc_eh_firedImpact}];
	
	// Store data in projectile object
	_projectile setVariable ["shot_timestamp", _timestamp];
	_projectile setVariable ["shot_unitId", _unitId];
	_projectile setVariable ["shot_unitPosX", _unitPosX];
	_projectile setVariable ["shot_unitPosY", _unitPosY];
	_projectile setVariable ["shot_impactEventHandler", _impactEventHandler];
	_projectile setVariable ["shot_weapon", _weapon];
	_projectile setVariable ["shot_ammo", _ammo];

	// Debug message
	if (ocap_debug) then {
		private _unitName = "";
		if (_unit isKindOf "CAManBase") then {
			_unitName = name _unit;
		} else {
			_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
		};
		systemChat format["OCAP: [%1] %2 (%3) fired %4 with %5 at [%6, %7]", _timestamp, _unitName, _unitId, _ammo, _weapon, _unitPosX, _unitPosY];
		diag_log format["OCAP: [%1] %2 (%3) fired %4 with %5 at [%6, %7]", _timestamp, _unitName, _unitId, _ammo, _weapon, _unitPosX, _unitPosY];
	};
};

nil
