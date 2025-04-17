extends Object
## An EntityRule contains data and references
## the related entity. It is the counterpart
## of an EntitiesRule.

const _Direction = AlephVault__WindRose.Utils.DirectionUtils.Direction
const _EntitiesRule = AlephVault__WindRose.Rules.EntitiesRule

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
func trigger_on_attached(entities_rule: _EntitiesRule, to_position: Vector2i):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_attached"
	)

## Triggers the on_detached event.
func trigger_on_detached(entities_rule: _EntitiesRule, from_position: Vector2i):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_detached"
	)

## Triggers the on_movement_rejected event.
func trigger_on_movement_rejected(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_movement_rejected"
	)

## Triggers the on_movement_started event.
func trigger_on_movement_started(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_movement_started"
	)

## Triggers the on_movement_finished event.
func trigger_on_movement_finished(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_movement_finished"
	)

## Triggers the on_movement_cleared event. Reverted
## position will be (-1, -1) if there was no movement.
func trigger_on_movement_cleared(
	from_position: Vector2i, reverted_position: Vector2i, direction: _Direction
):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_movement_cleared"
	)

## Triggers the on_teleported event.
func trigger_on_teleported(
	from_position: Vector2i, to_position: Vector2i
):
	AlephVault__WindRose.Utils.AccessUtils.not_implemented(
		"EntityRule", "trigger_on_movement_teleported"
	)
