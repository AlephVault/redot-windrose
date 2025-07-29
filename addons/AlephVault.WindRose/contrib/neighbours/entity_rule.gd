extends AlephVault__WindRose.Core.EntityRule
## This is the implementation of an entity rule
## that can be detected to reach the boundaries
## of its containing map and be teleported to
## its neighbouring map in that direction.
##
## This entity rule class, on itself, add no extra
## implementation to the logic.

# The related map entity.
var _map_entity: AlephVault__WindRose.Maps.MapEntity

## The related map entity.
var map_entity: AlephVault__WindRose.Maps.MapEntity:
	get:
		return _map_entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "map_entity"
		)

func _init(
	map_entity: AlephVault__WindRose.Maps.MapEntity,
	root: bool = true
):
	super._init(map_entity.size, root)
	_map_entity = map_entity
