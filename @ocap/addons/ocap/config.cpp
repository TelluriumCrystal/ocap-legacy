// Mod meta info
class CfgPatches
{
	class OCAP
	{
		name = "OCAP";
		author = "OCAP Team";
		url = "https://github.com/TelluriumCrystal/ocap-revived";
		requiredversion = "1.68";
		requiredAddons[] = {"A3_Functions_F", "cba_main"};
		units[] = {};
		weapons[] = {};
	};
};

// All functions to be loaded into the game
class CfgFunctions
{
	class OCAP
	{
		class null
		{
			file = "ocap\functions";
			class init {};					// Initializes OCAP and starts recording
			class init_CBASettings {};		// Sets up the custom CBA settings option
			class exportData {};			// Stops recording and exports data, then shuts down OCAP
			class callExtension {};			// Calls the OCAP exporter .dll
			class captureLoop {};			// Starts the capture loop, which sustains itself afterwards
			class addEventHandlers {};		// Adds event handlers to a specific unit
			class eh_entityKilled {};		// Event handler for unit killed
			class eh_entityRespawned {};	// Event handler for unit respawned
			class eh_fired {};				// Event handler for unit fired
			class eh_firedTracker {};		// Event handler for tracking a bullet a unit fired (spawned by eh_fired)
			class eh_mpHit {};				// Event handler for unit hit
			class eh_gotIn {};				// Event handler for unit got in a vehicle
			class eh_gotOut {};				// Event handler for unit got out of a vehicle
			class eh_handleDisconnect {};	// Event handler for player disconnected
			class eh_playerConnected {};	// Event handler for player connected
			class eh_ended {};				// Event handler for mission ended
		};
	};
};

// XEH event handlers
class Extended_PreInit_EventHandlers {
    class ocap_pre_init_CBASettings {
        init = "call ocap_fnc_init_CBASettings";
    };
};

// OCAP Eden Editor module category
class CfgFactionClasses
{
	class NO_CATEGORY;
	class ocap_category: NO_CATEGORY
	{
		displayName = "OCAP";
	};
};

// Eden editor modules
class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class AttributesBase
		{
			class Default;
			class Edit;					// Default edit box (i.e., text input field)
			class Combo;				// Default combo box (i.e., drop-down menu)
			class Checkbox;				// Default checkbox (returned value is Bool)
			class CheckboxNumber;		// Default checkbox (returned value is Number)
		};
	};

	// OCAP initalization module
	class OCAP_ModuleInit: Module_F
	{
		// Standard module definitions
		scope = 2; 						// Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "OCAP Init"; 		// Name displayed in the menu
		category = "ocap_category";		// Editor category ("NO_CATEGORY = "Misc")
		function = "ocap_fnc_init";		// Name of function triggered once conditions are met
		functionPriority = 1;			// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0;					// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;			// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;				// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		is3DEN = 0;						// 1 to run init function in Eden Editor as well

		// Module user configurable settings
		class Attributes: AttributesBase
		{
			class ExportPath: Edit
			{
				property = "ocap_ModuleInit_ExportPath";
				displayName = "Export Filepath";
				tooltip = "This is where all mission tracks will be saved to. If left blank the value saved in the CBA settings will be used.";
				typeName = "STRING";
			};
			class CaptureDelay: Edit
			{
				property = "ocap_ModuleInit_CaptureDelay";
				displayName = "Capture Delay";
				tooltip = "Time in seconds to wait between each measurement. Lower = higher fidelity playback. Can be set to 0 for maximum playback fidelity but may slow down scheduled scripts.";
				typeName = "NUMBER";
				defaultValue = "1";
			};
			class PauseCaptureOnNoPlayers: Checkbox
			{
				property = "ocap_ModuleInit_EndCaptureOnNoPlayers";
				displayName = "Pause Capture When No Players";
				tooltip = "Automatically pause capture if all players leave the server. Note: no effect in singleplayer.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class EndCaptureOnEndMission: Checkbox
			{
				property = "ocap_ModuleInit_EndCaptureOnEndMission";
				displayName = "End Capture When Mission Ends";
				tooltip = "Automatically export data if the mission ends.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class DebugMode: Checkbox
			{
				property = "ocap_ModuleInit_DebugMode";
				displayName = "Debug Mode";
				tooltip = "Enable debug mode. Generates verbose messages for debugging and adds scroll menu commands to player for easier testing.";
				typeName = "BOOL";
				defaultValue = "false";
			};
		};
	};

	// OCAP export data module
	class OCAP_ModuleExport: Module_F
	{
		// Standard module definitions
		scope = 2; 						   		  // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "OCAP Export"; 	   		  // Name displayed in the menu
		category = "ocap_category";		   		  // Editor category ("NO_CATEGORY = "Misc")
		function = "ocap_fnc_exportData";  		  // Name of function triggered once conditions are met
		functionPriority = 1;			   		  // Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0;					   		  // 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;			   		  // 1 for module waiting until all synced triggers are activated
		isDisposable = 0;				   		  // 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		is3DEN = 0;						   		  // 1 to run init function in Eden Editor as well
	};
};
