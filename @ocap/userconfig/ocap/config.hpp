// OCAP Configuration Options

// true: Capture will automatically begin upon mission start
// false: Capture will not begin until set to true (e.g. in mission init.sqf) AND ocap_minPlayerCount is met.
// Setting to false allows for mission-specific capture
ocap_capture = true;

ocap_exportPath = "C:/apache/htdocs/ocap/"; // Absolute path to OCAP web server root directory (e.g. "C:/apache/htdocs/ocap/")

ocap_frameCaptureDelay = 1; // Delay between each frame capture. Each frame is roughly 1 second long.
ocap_minPlayerCount = 1;    // Minimum player count before capture begins. Set this to 0 for immediate capture (assuming ocap_endCaptureOnNoPlayers = false)

ocap_endCaptureOnNoPlayers = true;   // End (and export) capture once players are no longer present
ocap_endCaptureOnEndMission = false; // End (and export) capture once mission ends

ocap_debug = false; // Debug mode