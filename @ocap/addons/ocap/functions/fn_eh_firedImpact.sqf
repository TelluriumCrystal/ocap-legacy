/*
	Function: ocap_fnc_eh_firedImpact

	Description:
	Event handler for "EpeContact". Builds a capture string for an entity firing a weapon
	using information stored in the bullet object.

	Parameters:
	_object1 = [OBJECT] Bullet object
	_object2 = [OBJECT] Entity the bullet is impacting

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_object1", "_object2"];

// Remove event handler from bullet to prevent triggering on ricochets
_object1 removeEventHandler ["EpeContact", _object1 getVariable ["shot_impactEventHandler"]];

// Check if capture is allowed
if (ocap_enableCapture) then {

	// Get relevant data for capture and set up impact event handler
	private _shot_timestamp = _object1 getVariable ["shot_timestamp"];
	private _shot_unitId = _object1 getVariable ["shot_unitId"];
	private _shot_unitPosX = _object1 getVariable ["shot_unitPosX"];
	private _shot_unitPosY = _object1 getVariable ["shot_unitPosY"];
	private _shot_weapon = _object1 getVariable ["shot_weapon"];
	private _shot_ammo = _object1 getVariable ["shot_ammo"];
	private _impact_timestamp = time;
	private _impactRawASL = getPosASL _object1;
	private _impactPosX = _impactRawASL select 0;
	private _impactPosY = _impactRawASL select 1;

	// Build capture string and append to capture array
	private _captureString = format ["10;%1;%2;%3;%4;%5;%6;%7;%8;%9", _shot_unitId, _shot_weapon, _shot_ammo, _shot_timestamp, _shot_unitPosX, _shot_unitPosY, _impact_timestamp, _impactPosX, _impactPosY];
	ocap_captureArray pushBack _captureString;


	// Debug message
	if (ocap_debug) then {
		systemChat format["OCAP: [%1] (%3)'s projectile impacted at [%5, %6]", _impact_timestamp, _shot_unitId, _impactPosX, _impactPosY];
		diag_log format["OCAP: [%1] (%3)'s projectile impacted at [%5, %6]", _impact_timestamp, _shot_unitId, _impactPosX, _impactPosY];
	};
};

nil
