extends Object
## Map rules manage / regulate what objects are allowed
## and how are they allowed to move in the map. All these
## methods are abstract and the user is responsible of
## implementing the strategies.
##
## It will be a very common pattern to create subclasses,
## especially considering the case where many strategies
## are needed and a composite pattern should be used.

var _map: AlephVault__WindRose.Maps.Map = null;

## The map this MapRule is related to.
var map: AlephVault__WindRose.Maps.Map:
	get:
		return _map
	set(value):
		assert(false, "The map cannot be set this way")

func _init(map: AlephVault__WindRose.Maps.Map):
	assert(map != null, "The MapRule needs a non-null map instance on init")
	_map = map

## Tells whether a specific entity rule is allowed by
## this map rule. This method will typically include
## the parts:
##
## 1. Type assertion.
## 2. Extra optional requirements.
func allows_object(obj: AlephVault__WindRose.Entities.Rules.Rule) -> bool:
	assert(false, "allows_object(obj) must be implemented")
	return false
