/*
	Function: ocap_fnc_callExtension

	Description:
	Calls the extension (.dll) in the specified mode.

	The extension is intended to be called in different modes to manipulate the temp file.
	First it should be called in mode 0 to delete the temp file if it already exists. Next
	mode 1 should be called to create the special mission head, which requires the system time.
	All subsequent calls should be in mode 2 to write the current capture array contents
	to the temp file. Next, it should be called in mode 3 to transfer the temp file to the
	user specified directory and finally in mode 0 to delete the temp copy.

	Parameters:
	_mode: [INT] 0 = delete temp file (if present)
				 1 = write mission head capture string to temp file
				 2 = write contents of capture array to temp file
				 3 = export temp file to user specified directory

	Returns:
	nil

	Author: TelluriumCrystal
*/

params ["_mode"];

switch (_mode) do {
    case 0: {
		// Delete temp file
		"ocap_exporter" callExtension format["0"];
	};
	case 1: {
		// Write mission head capture string
		"ocap_exporter" callExtension format["1%1", ocap_captureArray select 0];
		ocap_captureArray = [];
	};
    case 2: {
		// Write contents of capture array to temp file
		{
			"ocap_exporter" callExtension format["2%1", _x];
		} forEach ocap_captureArray;
		ocap_captureArray = [];
	};
	case 3: {
		// Export temp file
		"ocap_exporter" callExtension format["3%1;%2", missionName, ocap_exportPath];
	};
};

nil
