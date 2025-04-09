extends Object
## An EntityRule contains data and references
## the related entity. It is the counterpart
## of an EntitiesRule.

## Returns the size of the rule's terrain.
func _get_size() -> Vector2i:
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "_get_size"
	)
	return Vector2i(0, 0)

## Returns the size for this rule.
var size: Vector2i:
	get:
		return _get_size()
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "size"
		)

func _init(entity: AlephVault__WindRose.Entities.Entity):
	pass
