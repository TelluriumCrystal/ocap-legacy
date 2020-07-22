/*
	Function: ocap_fnc_eh_playerConnected

	Description:
	Mission event handler for "PlayerConnected". Builds a capture string for a client connecting.

	Paramaters:
	_id = [NUM] Unique DirectPlay ID (very long number)
	_uid = [NUM] Player's steam ID
	_name = [STR] Player's profile name

	Returns:
	nil

	Author: TelluriumCrystal
*/

_this params ["_id", "_uid", "_name"];

if (ocap_enableCapture) then {

	// Get relevant data for capture
	private _timestamp = serverTime;
	private _playerName = _name;

	// Build capture string
	private _captureString = format ["6;%1;%2;1;", _timestamp, _playerName];

	// Append capture string to capture array
	ocap_captureArray pushBack _captureString;

	// Debug message
	if (ocap_debug) then {
		systemChat format["OCAP: [%1] %2 connected", _timestamp, _playerName, name _newEntity, _entityId];
		diag_log format["OCAP: [%1] %2 connected", _timestamp, _playerName, name _newEntity, _entityId];
	};
};

nil
