extends AlephVault__WindRose.Core.EntitiesRule
## This entities rule subclass ensures the are many
## types of navigability for the individual cells, and
## entities can move across cells that include the
## navigability allowed for them. This allows defining
## maps with e.g. walk / surf navigabilities, so they
## allow people to walk and ships to surf.

## The data layer to use.
const NAVIGABILITY_TYPE: String = "navigability_type"
const NAVIGABILITY_INCREMENTS: String = "navigability_increments"

# The map this rule is related to.
var _map: AlephVault__WindRose.Maps.Map

# The navigabilities array.
var _navigability_types: Array[int]

## The map this rule is related to.
var map: AlephVault__WindRose.Maps.Map:
	get:
		return _map
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntitiesRule", "map"
		)

## Initializes the cell data structure,
## by creating an integer array with the
## navigability types.
func initialize_global_data():
	_navigability_types = []
	_navigability_types.resize(size.x * size.y)

## Tells whether an entity can be attached
## to the map. In this case, the entity has
## the navigability rule attached.
func can_attach(
	entity_rule: AlephVault__WindRose.Core.EntityRule,
	cell: Vector2i
) -> bool:
	return entity_rule is AlephVault__WindRose.Contrib.Navigability.EntityRule

## Construction takes the map. This one is used
## to get information from tilemap layers and
## their cells.
func _init(map: AlephVault__WindRose.Maps.Map):
	_map = map
	super._init(map.size)
