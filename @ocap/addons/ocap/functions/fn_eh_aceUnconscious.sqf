/*
	Function: ocap_fnc_eh_aceUnconscious

	Description:
	CBA event handler for "ace_unconscious". Builds a capture string for an entity gaining or losing
	consciousness and adds it to the capture array.

	Paramaters:
	_unit = [OBJECT] The unit gaining/losing consciousness
	_state = [BOOL] True if the unit gained consciousness, false if it lost consciousness

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_unit", "_state"];

// Check if entity is initiliased with OCAP and isn't marked as excluded from capture
if (ocap_enableCapture and _unit getVariable ["ocap_isInitialised", false] and  !(_unit getVariable ["ocap_exclude", false])) then {

	// Get relevant data for capture
	private _timestamp = time;
	private _unitId = _unit getVariable "ocap_id";

	// Build capture string
	private _captureString = format ["9;%1;%2;%3", _timestamp, _unitId, _state];

	// Append capture string to capture array
	ocap_captureArray pushBack _captureString;

	// Debug message
	if (ocap_debug) then {
		systemChat format["OCAP: [%1] %2 changed conscious state to %4", _timestamp, name _unit, _unitId, _state];
		diag_log format["OCAP: [%1] %2 changed conscious state to %4", _timestamp, name _unit, _unitId, _state];;
	};
};

nil
