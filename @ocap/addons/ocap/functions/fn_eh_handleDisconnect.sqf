/*
	Function: ocap_fnc_eh_handleDisconnect

	Description:
	Mission event handler for "HandleDisconnect". Builds a capture string for a client disconnecting.

	Paramaters:
	_unit = [OBJECT] Entity the player was controlling
	_id = [NUM] Unique DirectPlay ID (very long number)
	_uid = [NUM] Player's steam ID
	_name = [STR] Player's profile name

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_unit", "_id", "_uid", "_name"];

if (ocap_enableCapture) then {

	// Get relevant data for capture
	private _timestamp = time;
	private _playerName = _name;
	private _entityId = "";

	// Check if entity exists, is initiliased with OCAP, and isn't marked as excluded from capture
	if (!isNull _unit and _unit getVariable ["ocap_isInitialised", false] and !(_unit getVariable ["ocap_exclude", false])) then {

		_entityId = _unit getVariable ["ocap_id"];
	};

	// Build capture string
	private _captureString = format ["6;%1;%2;0;%3", _timestamp, _playerName, _entityId];

	// Append capture string to capture array
	ocap_captureArray pushBack _captureString;

	// Debug message
	if (ocap_debug) then {
		systemChat format["OCAP: [%1] %2 controlling %3 (%4) disconnected", _timestamp, _playerName, name _unit, _entityId];
		diag_log format["OCAP: [%1] %2 controlling %3 (%4) disconnected", _timestamp, _playerName, name _unit, _entityId];
	};
};

nil
