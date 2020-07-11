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
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "OCAP Recorder"; // Name displayed in the menu
		category = "NO_CATEGORY";

		// Name of function triggered once conditions are met
		function = "ocap_fnc_init";
		// Execution priority, modules with lower number are executed first. 0 is used when the attribute is undefined
		functionPriority = 1;
		// 0 for server only execution, 1 for global execution, 2 for persistent global execution
		isGlobal = 0;
		// 1 for module waiting until all synced triggers are activated
		isTriggerActivated = 1;
		// 1 if modules is to be disabled once it's activated (i.e., repeated trigger activation won't work)
		isDisposable = 1;
		// 1 to run init function in Eden Editor as well
		is3DEN = 0;

		// Menu displayed when the module is placed or double-clicked on by Zeus
		curatorInfoType = "RscDisplayAttributeModuleNuke";

		// Module attributes, uses https://community.bistudio.com/wiki/Eden_Editor:_Configuring_Attributes#Entity_Specific
		class Attributes: AttributesBase
		{
			// Module specific arguments
			class ExportPath: Edit
			{
				property = "ocap_ModuleInit_ExportPath";
				displayName = "Export Filepath";
				tooltip = "Absolute path to the OCAP web server root folder.";
				typeName = "STRING";
				defaultValue = "'C:/apache/htdocs/ocap/'";
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
};
