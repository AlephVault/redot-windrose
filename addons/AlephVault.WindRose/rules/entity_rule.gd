extends Object
## An EntityRule contains data and references
## the related entity. It is the counterpart
## of an EntitiesRule.

var _entity: AlephVault__WindRose.Entities.Entity

## Returns the associated entity.
var entity: AlephVault__WindRose.Entities.Entity:
	get:
		return _entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "entity"
		)

var _size: Vector2i

## Returns the size for this rule.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "size"
		)

func _init(entity: AlephVault__WindRose.Entities.Entity):
	_entity = entity
	_size = entity.size
