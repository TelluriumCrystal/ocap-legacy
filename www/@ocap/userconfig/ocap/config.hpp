// OCAP Configuration Options

// If true, OCAP will begin capture as soon as ocap_minPlayerCount is met; if false, OCAP will not start capture until another script sets it true
ocap_capture = true;

// Absolute path to OCAP web server root directory (e.g. "C:/apache/htdocs/ocap/") - this is where the exporter will save mission data
ocap_exportPath = "C:/apache/htdocs/ocap/";

// Delay between each frame capture (in seconds). In a server with infinate CPU speed this sets the length of each frame. Set lower for higher fidelity data.
ocap_frameCaptureDelay = 1;
// Minimum player count before capture begins. Set this to 0 for immediate capture (assuming ocap_endCaptureOnNoPlayers = false)
ocap_minPlayerCount = 1;

// End (and export) capture once players are no longer present
ocap_endCaptureOnNoPlayers = true;
// End (and export) capture once mission ends
ocap_endCaptureOnEndMission = false;

// Debug mode
ocap_debug = false;
