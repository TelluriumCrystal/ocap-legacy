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
		units[] = {};
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
			class init {postInit = 1;};
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