class CfgPatches
{
	class OCAP
	{
		// Mod meta info
		name = "OCAP";
		author = "OCAP Team";
		url = "https://github.com/TelluriumCrystal/ocap-revived";
		requiredversion = "1.68";
		requiredAddons[] = {"A3_Functions_F", "cba_main"};
		units[] = {"OCAP_ModuleInit"};
		weapons[] = {};
	};
};

class CfgFunctions
{
	class OCAP
	{
		class null
		{
			file = "ocap\functions";
			class init {};
			class init_CBASettings{};
			class exportData {};
			class callExtension {};
			class startCaptureLoop {};
			class addEventHandlers {};
			class log {};
			class eh_killed {};
			class eh_fired {};
			class eh_hit {};
			class eh_disconnected {};
			class eh_connected {};
		};
	};
};

class Extended_PreInit_EventHandlers {
    class ocap_pre_init_CBASettings {
        init = "call ocap_fnc_init_CBASettings";
    };
};

class CfgFactionClasses
{
	class NO_CATEGORY;
	class ocap_category: NO_CATEGORY
	{
		displayName = "OCAP";
	};
};

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
		
		// Description base class
		class ModuleDescription;
	};
	class OCAP_ModuleInit: Module_F
	{
		// Standard object definitions
		scope = 2; 						// Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "OCAP Init"; 		// Name displayed in the menu
		category = "ocap_category";		// Editor category ("NO_CATEGORY = "Misc")
		function = "ocap_fnc_init";		// Name of function triggered once conditions are met
		functionPriority = 1;			// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0;					// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;			// 1 for module waiting until all synced triggers are activated
		isDisposable = 1;				// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		is3DEN = 0;						// 1 to run init function in Eden Editor as well

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Module specific arguments
			class ExportPath: Edit
			{
				property = "ocap_ModuleInit_ExportPath";
				displayName = "Export Filepath";
				tooltip = "This is where all mission tracks will be saved to. If left blank the value saved in the CBA settings will be used.";
				typeName = "STRING";
			};
			class FrameDelay: Edit
			{
				property = "ocap_ModuleInit_FrameDelay";
				displayName = "Frame Delay";
				tooltip = "Time in seconds to wait between each measurement. Lower = higher fidelity playback.";
				typeName = "NUMBER";
				defaultValue = "1";
			};
			class EndCaptureOnNoPlayers: Checkbox
			{
				property = "ocap_ModuleInit_EndCaptureOnNoPlayers";
				displayName = "End Capture When No Players";
				tooltip = "Automatically stop capture and export data if all players leave the server.";
				typeName = "BOOL";
				defaultValue = "false";
			};
			class EndCaptureOnEndMission: Checkbox
			{
				property = "ocap_ModuleInit_EndCaptureOnEndMission";
				displayName = "End Capture When Mission Ends";
				tooltip = "Automatically stop capture and export data if the mission ends.";
				typeName = "BOOL";
				defaultValue = "true";
			};
			class DebugMode: Checkbox
			{
				property = "ocap_ModuleInit_DebugMode";
				displayName = "Debug Mode";
				tooltip = "Enable debug mode. Generates verbose messages for debugging.";
				typeName = "BOOL";
				defaultValue = "false";
			};
		};
	};
	
	class OCAP_ModuleExport: Module_F
	{
		// Standard object definitions
		scope = 2; 						// Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "OCAP Export"; 	// Name displayed in the menu
		category = "ocap_category";		// Editor category ("NO_CATEGORY = "Misc")
		function = "ocap_fnc_init";		// Name of function triggered once conditions are met
		functionPriority = 1;			// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		isGlobal = 0;					// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isTriggerActivated = 1;			// 1 for module waiting until all synced triggers are activated
		isDisposable = 0;				// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		is3DEN = 0;						// 1 to run init function in Eden Editor as well
		};
	};
};
