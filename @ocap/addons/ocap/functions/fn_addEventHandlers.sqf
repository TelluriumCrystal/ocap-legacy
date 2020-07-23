/*
	Function: ocap_fnc_addEventHandlers

	Description:
	Adds event handlers to the given entity (unit/vehicle).

	Parameters:
	_entity: [OBJECT] - Entity to add event handlers to

	Returns:
	nil

	Author: MisterGoodson, TelluriumCrystal
*/

_this params ["_entity"];

// General event handlers
private _firedEH = _entity addEventHandler ["Fired", {_this spawn ocap_fnc_eh_fired}];
private _hitEH = _entity addMPEventHandler ["MPHit", {_this call ocap_fnc_eh_mpHit}];

// More event handlers if entity is a vehicle
if (!(_entity isKindOf "CAManBase")) then {
	
	private _gotInEH = _entity addEventHandler ["GetIn", {_this call ocap_fnc_eh_gotIn}];
	private _gotOutEH = _entity addEventHandler ["GetOut", {_this call ocap_fnc_eh_gotOut}];
	_entity setVariable ["ocap_eventHandlers", [["Fired", _firedEH], ["GetIn", _gotInEH], ["GetOut", _gotOutEH]]];
	_entity setVariable ["ocap_MPeventHandlers", [["MPHit", _hitEH]]];
} else {
	_entity setVariable ["ocap_eventHandlers", [["Fired", _firedEH]]];
	_entity setVariable ["ocap_MPeventHandlers", [["MPHit", _hitEH]]];
};

nil
