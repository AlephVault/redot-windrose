extends AlephVault__WindRose.Rules.EntityRule
## A Entity's EntityRule is an EntityRule that
## holds a reference to the related entity.

const _Entity = AlephVault__WindRose.Entities.Entity

var _entity: _Entity

## Returns the current entity.
var entity: _Entity:
	get:
		return _entity
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"EntityRule", "entity"
		)

func _init(entity: _Entity) -> void:
	_entity = entity

## Triggers the on_attached event.
func trigger_on_attached(entities_rule: _EntitiesRule, to_position: Vector2i):
	entity.on_attached.emit(entities_rule, to_position)

## Triggers the on_detached event.
func trigger_on_detached(entities_rule: _EntitiesRule, from_position: Vector2i):
	entity.on_detached.emit(entities_rule, from_position)

## Triggers the on_movement_rejected event.
func trigger_on_movement_rejected(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	entity.on_movement_rejected.emit(
		from_position, to_position, direction
	)

## Triggers the on_movement_started event.
func trigger_on_movement_started(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	entity.on_movement_started.emit(
		from_position, to_position, direction
	)

## Triggers the on_movement_finished event.
func trigger_on_movement_finished(
	from_position: Vector2i, to_position: Vector2i, direction: _Direction
):
	entity.on_movement_finished.emit(
		from_position, to_position, direction
	)

## Triggers the on_movement_cleared event. Reverted
## position will be (-1, -1) if there was no movement.
func trigger_on_movement_cleared(
	from_position: Vector2i, reverted_position: Vector2i, direction: _Direction
):
	entity.on_movement_cancelled.emit(
		from_position, reverted_position, direction
	)

## Triggers the on_teleported event.
func trigger_on_teleported(
	from_position: Vector2i, to_position: Vector2i
):
	entity.on_teleported.emit(
		from_position, to_position
	)
