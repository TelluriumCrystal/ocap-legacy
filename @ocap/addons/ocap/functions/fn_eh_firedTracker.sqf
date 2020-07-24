/*
	Function: ocap_fnc_eh_firedTracker

	Description:
	Secondary event handler for "Fired". Runs in the scheduler. Polls the position of the projectile
	until it despawns and then builds a capture string for an entity firing a weapon
	and adds it to the capture array.

	Parameters:
	_unit = [OBJECT] Unit that fired
	_projectile = [OBJECT] The projectile that was fired
	_gunner = [STR] Gunner whose weapon is firing
	_fired_timestamp = [DBL] Time the weapon was fired
	_fired_unitId = [INT] OCAP ID of the unit that fired
	_fired_weapon = [STR] Name of the weapon fired
	_fired_ammo = [STR] Name of the ammo used
	_fired_unitPosX = [DBL] X coordinate the weapon was fired at
	_fired_unitPosY = [DBL] Y coordinate the weapon was fired at

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_unit", "_projectile", "_fired_timestamp", "_fired_unitId", "_fired_weapon", "_fired_ammo", "_fired_unitPosX", "_fired_unitPosY"];

// Set up impact capture variables
private _impactTimestamp = time;
private _impactRawASL = getPosASL _projectile;
private _impactPosX = _impactRawASL select 0;
private _impactPosY = _impactRawASL select 1;

// Wait for bullet do despawn
waitUntil {
	if (isNull _projectile) exitWith {true};

	// Enter atomic block
	isNil {
		_impactTimestamp = time;
		_impactRawASL = getPosASL _projectile;
		_impactPosX = _impactRawASL select 0;
		_impactPosY = _impactRawASL select 1;
	};

	sleep 0.05;
	false
};

// Enter atomic block
isNil {

	// Check if OCAP is still running
	if (!isNil {ocap_captureArray}) then {

		// Build capture string and append to capture array
		private _captureString = format ["10;%1;%2;%3;%4;%5;%6;%7;%8;%9", _fired_unitId, _fired_weapon, _fired_ammo, _fired_timestamp, _fired_unitPosX, _fired_unitPosY, _impactTimestamp, _impactPosX, _impactPosY];
		ocap_captureArray pushBack _captureString;

		// Debug message
		if (ocap_debug) then {
			private _unitName = "";
			if (_unit isKindOf "CAManBase") then {
				_unitName = name _unit;
			} else {
				_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
			};
			systemChat format["OCAP: [%1] %2 (%3) fired %4 with %5 from [%6, %7] and hit at [%8, %9] at %10", _fired_timestamp, _unitName, _fired_unitId, _fired_ammo, _fired_weapon, _fired_unitPosX, _fired_unitPosY, _impactPosX, _impactPosY, _impactTimestamp];
			diag_log format["OCAP: [%1] %2 (%3) fired %4 with %5 from [%6, %7] and hit at [%8, %9] at %10", _fired_timestamp, _unitName, _fired_unitId, _fired_ammo, _fired_weapon, _fired_unitPosX, _fired_unitPosY, _impactPosX, _impactPosY, _impactTimestamp];
		};
	} else {

		// Log that an event was discarded
		private _unitName = "";
		if (_unit isKindOf "CAManBase") then {
			_unitName = name _unit;
		} else {
			_unitName = getText (configFile >> "CfgVehicles" >> typeOf _unit >> "displayName");
		};
		diag_log format["OCAP: Discarded Fired event handler that finished after OCAP shutdown for %1 (%2)", _unitName, _fired_unitId];
	};
};

nil
