/*
	Function: ocap_fnc_eh_fired

	Description:
	Event handler for "Fired". Builds a capture string for an entity firing a weapon
	and adds it to the capture array. This function must be spawned because it needs
	to wait for the bullet to impact.

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

	// Get relevant data for initial capture
	private _timestamp = time;
	private _unitId = _unit getVariable "ocap_id";
	private _unitRawASL = getPosASL _unit;
	private _unitPosX = _unitRawASL select 0;
	private _unitPosY = _unitRawASL select 1;
	private _impactTimestamp = _timestamp;
	private _impactPosX = _unitPosX;
	private _impactPosY = _unitPosY;

	// Wait for bullet do despawn
	waitUntil {
		if (isNull _projectile) exitWith {true};
		// Enter atomic block
		isNil {
			_impactTimestamp = time;
			private _impactRawASL = getPosASL _projectile;
			_impactPosX = _impactRawASL select 0;
			_impactPosY = _impactRawASL select 1;
		};
		false
	};

	// Build capture string and append to capture array
	private _captureString = format ["10;%1;%2;%3;%4;%5;%6;%7;%8;%9", _unitId, _weapon, _ammo, _timestamp, _unitPosX, _unitPosY, _impactTimestamp, _impactPosX, _impactPosY];
	ocap_captureArray pushBack _captureString;

	// Debug message
	if (ocap_debug) then {
		private _unitName = "";
		if (_unit isKindOf "CAManBase") then {
			_unitName = name _unit;
		} else {
			_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
		};
		systemChat format["OCAP: [%1] %2 (%3) fired %4 with %5 from [%6, %7] and hit at [%8, %9] at %10", _timestamp, _unitName, _unitId, _ammo, _weapon, _unitPosX, _unitPosY, _impactPosX, _impactPosY, _impactTimestamp];
		diag_log format["OCAP: [%1] %2 (%3) fired %4 with %5 from [%6, %7] and hit at [%8, %9] at %10", _timestamp, _unitName, _unitId, _ammo, _weapon, _unitPosX, _unitPosY, _impactPosX, _impactPosY, _impactTimestamp];
	};
};

nil
