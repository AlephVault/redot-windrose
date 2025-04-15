extends AlephVault__WindRose.Rules.EntitiesRule
## A Map's EntitiesRule is an EntitiesRule that
## holds a reference to the related map.

const _Map = AlephVault__WindRose.Maps.Map

var _map: _Map

## Returns the current map.
var map: _Map:
	get:
		return _map
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "map"
		)
