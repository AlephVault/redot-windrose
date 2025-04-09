extends Object

## Stage of the movement-start operation.
## Used to tell on_movement_started which
## stage of the movement initiation is
## taking place.
enum MovementStartedStage {
	Begin, MovementAllocated, End
}

## Stage of the movement-cancel operation.
## Used to tell on_movement_cancelled which
## stage of the movement cancellation is
## taking place.
enum MovementClearedStage {
	Begin, MovementCleared, End
}

## Stage of the movement-confirm operation.
## Used to tell on_movement_finished which
## stage of the movement finish is taking
## place.
enum MovementConfirmedStage {
	Begin, PositionChanged, MovementCleared, End
}

## Stage of the teleport operation. Used
## to tell on_teleported which stage of
## the teleport is taking place. 
enum TeleportedStage {
	Begin, PositionChanged, End
}

var _entity_layer

## Returns the associated entity layer.
var entity_layer:
	get:
		return _entity_layer
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapRule", "entity_layer"
		)

var _size: Vector2i

## Returns the size for this strategy.
var size: Vector2i:
	get:
		return _size
	set(value):
		AlephVault__WindRose.Utils.AccessUtils.cannot_set(
			"MapRule", "size"
		)

## Construction takes the entity layer
## keeps that layer and size.
func _init(entity_layer) -> void:
	_entity_layer = entity_layer
	_size = entity_layer.size

var _initialized: bool = false

## Initializes the whole map rule.
func initialize():
	if self._initialized:
		return
	self._initialized = true

	# Initializes the internal data when it's ready.
	# This already comes from a TileMap, most likely.
	self.initialize_global_data()
	var s: Vector2i = self._size
	for y in range(s.y):
		for x in range(s.x):
			self.initialize_cell_data(Vector2i(x, y))

func initialize_global_data():
	pass

func initialize_cell_data(cell: Vector2i):
	pass

func update_cell_data(cell: Vector2i):
	pass

func can_attach(entity, cell: Vector2i) -> bool:
	return true

func on_entity_attached(entity, to_position: Vector2i):
	pass

func can_move(entity, direction: int) -> bool:
	return true

func on_movement_started(
	entity, start_position: Vector2i, end_position: Vector2i, direction: int,
	stage: MovementStartedStage
):
	pass

func on_movement_finished(
	entity, start_position: Vector2i, end_position: Vector2i, direction: int,
	stage: MovementConfirmedStage
):
	pass

func can_cancel_movement(entity, direction: int) -> bool:
	return true

func on_movement_cancelled(
	entity, start_position: Vector2i, reverted_position: Vector2i, direction: int,
	stage: MovementClearedStage
):
	pass

func on_teleported(
	entity, from_position: Vector2i, to_position: Vector2i,
	stage: TeleportedStage
):
	pass

func on_entity_detached(entity, from_position: Vector2i):
	pass

func on_property_updated(
	entity_rule: AlephVault__WindRose.Rules.EntityRule,
	property: String, old_value, new_value
):
	pass
