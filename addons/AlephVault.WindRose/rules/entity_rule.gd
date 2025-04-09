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

## Triggers the on_attached event.
func trigger_on_attached(to_position: Vector2i):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_attached"
	)

## Triggers the on_detached event.
func trigger_on_detached(from_position: Vector2i):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_detached"
	)
