/*
	Function: ocap_fnc_eh_fired

	Description:
	Event handler for "Fired". Grabs data on the entity firing and then
	spawns ocap_fnc_eh_firedTracker to finish handing the event.

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

_this params ["_unit", "_weapon", "", "", "_ammo", "", "_projectile", ""];

// Check if OCAP is still running, entity is initiliased with OCAP, and isn't marked as excluded from capture
if (ocap_enableCapture and _unit getVariable ["ocap_isInitialised", false] and  !(_unit getVariable ["ocap_exclude", false])) then {

	// Get relevant data for initial capture
	private _timestamp = time;
	private _unitId = _unit getVariable "ocap_id";
	private _unitRawASL = getPosASL _unit;
	private _unitPosX = _unitRawASL select 0;
	private _unitPosY = _unitRawASL select 1;
	private _weaponName = getText (configFile >> "CfgWeapons" >> _weapon >> "displayName");

	// Spawn bullet tracking script
	[_unit, _projectile, _timestamp, _unitId, _weaponName, _ammo, _unitPosX, _unitPosY] spawn ocap_fnc_eh_firedTracker;
};

nil
