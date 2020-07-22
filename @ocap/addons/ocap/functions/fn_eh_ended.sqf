/*
	Function: ocap_fnc_eh_ended

	Description:
	Mission event handler for "Ended" and "MPEnded". Exports the capture data if configured to do so
	in the module settings.

	Paramaters:
	None

	Returns:
	nil

	Author: TelluriumCrystal
*/

// Check if configured to export on mission end and if so export capture data
if (ocap_endCaptureOnEndMission) then {

	[] call ocap_fnc_exportData;

	// Clear export capture on mission end in case MPEnded and Ended get called
	ocap_endCaptureOnEndMission = false;
};

// Debug message
if (ocap_debug) then {
	systemChat format["OCAP: Mission ended. Exporting capture data to %1", ocap_exportPath];
};

// Standard system log message
diag_log format["OCAP: Mission ended. Exporting capture data to %1", ocap_exportPath];

nil
