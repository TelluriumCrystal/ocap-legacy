/*
	Author: MisterGoodson, TelluriumCrystal

	Description:
	Calls extension (dll) and supplies given arguments.
	
	Extension is intended to be called multiple times to write
	successive JSON 'chunks' to a file. Once there is no more data
	to write, the extension should be called a final time (transfer mode)
	to transfer this file to a different location (local or remote).
	The location to transfer to is defined in the userconfig settings.

	Parameters:
	_string: STRING - Data to output to extension (e.g. JSON)
	_mode: INT - 0 to write JSON header, 1 to write passed string to JSON, 2 to transfer JSON to web host
*/

params ["_string", "_mode"];

switch (_mode) do {
    case 0: {
		// Write header to file
		_worldName = worldName;
		_missionName = briefingName;
		_missionAuthor = getMissionConfigValue ["author", ""];
		_missionDuration = ocap_endFrameNo * ocap_frameCaptureDelay; // Duration of mission (seconds)
		
		"ocap_exporter" callExtension format["{head;%1;%2;%3;%4;%5;%6;%7}",
			ocap_exportCapFilename,
			_worldName,
			_missionName,
			_missionAuthor,
			_missionDuration,
			ocap_frameCaptureDelay,
			ocap_endFrameNo
		];
	};
    case 1: {
		// Write string to file
		"ocap_exporter" callExtension format["{write;%1}%2", ocap_exportCapFilename, _string];
	};
	case 2: {
		// Transfer file to server
		"ocap_exporter" callExtension format["{transfer;%1;%2}",
			ocap_exportCapFilename,
			ocap_exportPath
		];
	};
};