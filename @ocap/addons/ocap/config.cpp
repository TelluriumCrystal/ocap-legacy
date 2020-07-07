class CfgPatches
{
	class OCAP
	{
		// Editor meta info
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
			class ModuleDescription;	// Module description
			class Units;				// Selection of units on which the module is applied
		};
		// Description base classes, for more information see below
		class ModuleDescription
		{
			class EmptyDetector;
		};
	};
	class OCAP_ModuleInit: Module_F
	{
		// Standard object definitions
		scope = 2; // Editor visibility; 2 will show it in the menu, 1 will hide it.
		displayName = "OCAP Recorder"; // Name displayed in the menu
		category = "NO_CATEGORY";

		// Name of function triggered once conditions are met
		function = "ocap_fn_init";
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
			// Arguments shared by specific module type (have to be mentioned in order to be present)
			class Units: Units
			{
				property = "ocap_ModuleInit_Units";
			};
			// Module specific arguments
			class Yield: Combo
			{
				// Unique property, use "<moduleClass>_<attributeClass>" format to make sure the name is unique in the world
				property = "myTag_ModuleNuke_Yield";
				displayName = "Nuclear weapon yield"; // Argument label
				tooltip = "How strong will the explosion be"; // Tooltip description
				typeName = "NUMBER"; // Value type, can be "NUMBER", "STRING" or "BOOL"
				defaultValue = "50"; // Default attribute value. WARNING: This is an expression, and its returned value will be used (50 in this case)
				class Values
				{
					class 50Mt	{name = "50 megatons";	value = 50;}; // Listbox item
					class 100Mt	{name = "100 megatons"; value = 100;};
				};
			};
			class Name: Edit
			{
				displayName = "Name";
				tooltip = "Name of the nuclear device";
				// Default text filled in the input box
				// Because it's an expression, to return a String one must have a string within a string
				defaultValue = """Tsar Bomba""";
			};
			class ModuleDescription: ModuleDescription{}; // Module description should be shown last
		};

		// Module description. Must inherit from base class, otherwise pre-defined entities won't be available
		class ModuleDescription: ModuleDescription
		{
			description = "Short module description"; // Short description, will be formatted as structured text
			sync[] = {"LocationArea_F"}; // Array of synced entities (can contain base classes)

			class LocationArea_F
			{
				description[] = { // Multi-line descriptions are supported
					"First line",
					"Second line"
				};
				position = 0; // Position is taken into effect
				direction = 0; // Direction is taken into effect
				optional = 1; // Synced entity is optional
				duplicate = 1; // Multiple entities of this type can be synced
				synced[] = {"EmptyDetector"}; // Pre-define entities like "AnyBrain" can be used. See the list below
			};
		};
	};
};
