/*
	Author: TelluriumCrystal

	Description:
	Initalizes custom CBA settings.
*/

[
	"ocap_ModuleInit_ExportPath_default",	// Unique setting name. Matches resulting variable name <STRING>
	"EDITBOX",								// Type of setting. Can be "CHECKBOX", "EDITBOX", "LIST", "SLIDER" or "COLOR" <STRING>
	["Default export filepath",				// Display name or display name + tooltip (optional, default: same as setting name) <STRING, ARRAY>
		"This is where all mission tracks will be saved to. If the 'export filepath' field in the module is left blank then this value will be used."],
	"OCAP",									// Category for the settings menu + optional sub-category <STRING, ARRAY>
	"C:/apache/htdocs/ocap/",				// Default value of edit box <STRING>
	2,										// 1: all clients share the same setting, 2: setting can't be overwritten (optional, default: 0) <NUMBER>
	nil,									// Script to execute when setting is changed. (optional) <CODE>
	true									// Setting will be marked as needing mission restart after being changed. (optional, default false) <BOOL>
] call CBA_fnc_addSetting;